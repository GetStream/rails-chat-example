class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  def query_bot(text)
    query_input = { text: { text: text, language_code: 'en'}}
    response = @dialogflow.detect_intent @dialogflow_session, query_input
    query_result = response.query_result
    query_result.fulfillment_text
  end

  def message
    if params[:type] == 'message.new'
      user = User.find_by handle: params[:user][:id]
      if !user.nil?
        channel = @chat.query_channels({"type": "messaging", "source": "support", "members": { "$in": [params[:user][:id], "representative"]}})["channels"][0]["channel"]
        bot_response = query_bot(params[:message][:text])
        c = @chat.channel(channel["type"], channel_id: channel["id"])
        c.send_message({'id' => SecureRandom.uuid, 'text' => bot_response}, "helperbot")
      end
    end
  end
end
