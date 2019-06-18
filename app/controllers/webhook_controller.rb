class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  def query_bot(text)
    query_input = { text: { text: text, language_code: 'en'}}
    response = @dialogflow.detect_intent @dialogflow_session, query_input
    query_result = response.query_result
    end_conversation = JSON.parse(query_result.to_json).fetch('diagnosticInfo', {})['end_conversation']
    return query_result.fulfillment_text, end_conversation
  end

  def message
    if params[:type] == 'message.new'
      user = User.find_by handle: params[:user][:id]
      if !user.nil?
        channel = @chat.query_channels({
          "type" => "messaging",
          "source" => "support",
          "members" => {
            "$in" => [params[:user][:id]]
          }
        })["channels"][0]["channel"]
        c = @chat.channel(channel["type"], channel_id: channel["id"])
        if !channel["silence_bot"]
          bot_response, end_conversation = query_bot(params[:message][:text])
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
