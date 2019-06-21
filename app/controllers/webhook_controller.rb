require 'digest/sha1'

class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  def query_bot(session_id, text)
    query_input = { text: { text: text, language_code: 'en'}}
    bot_session = @dialogflow.class.session_path ENV['GOOGLE_PROJECT_ID'], session_id
    response = @dialogflow.detect_intent bot_session, query_input
    query_result = response.query_result
    end_conversation = JSON.parse(query_result.to_json).fetch('diagnosticInfo', {})['end_conversation']
    return query_result.fulfillment_text, end_conversation
  end

  def message
    if params[:type] == 'message.new'
      user = User.find_by handle: params[:user][:id]
      if !user.nil?
        session_id = Digest::SHA1.hexdigest(params[:cid])
        channel = @chat.query_channels({
          "cid" => params[:cid],
        })["channels"][0]["channel"]
        c = @chat.channel(channel["type"], channel_id: channel["id"])
        if !channel["silence_bot"]
          bot_response, end_conversation = query_bot(session_id, params[:message][:text])
          if end_conversation
            c.update({'silence_bot' => true})
            c.add_members(["representative"])
          end
          c.send_message({'id' => SecureRandom.uuid, 'text' => bot_response}, "helperbot")
        end
      end
    end
  end
end
