import React from "react";
import PropTypes from "prop-types";
import {
  Chat,
  Channel,
  ChannelHeader,
  Thread,
  Window,
  MessageList,
  MessageInput
} from "stream-chat-react";

import { StreamChat } from "stream-chat";

import "stream-chat-react/dist/css/index.css";

class ClientChat extends React.Component {
  constructor(props) {
    super(props);
    let apiKey;
    if (process.env.STREAM_URL) {
      [apiKey] = process.env.STREAM_URL.substr(8)
        .split("@")[0]
        .split(":");
    } else {
      apiKey = process.env.STREAM_API_KEY;
    }
    this.chatClient = new StreamChat(apiKey);
    this.chatClient.setUser(
      {
        id: this.props.userHandle,
        name: this.props.userName,
        image: `https://getstream.io/random_svg/?id=${
          this.props.userHandle
        }&name=${this.props.userName}`
      },
      this.props.userToken
    );
    this.channel = this.chatClient.channel("commerce", "", {
      // add as many custom fields as you'd like
      image:
        "https://cdn.chrisshort.net/testing-certificate-chains-in-go/GOPHER_MIC_DROP.png",
      name: `Support request - ${this.props.userHandle}`,
      source: "support",
      members: [this.props.userHandle, this.props.repId]
    });
  }
  render() {
    return (
      <Chat client={this.chatClient} theme={"commerce dark"}>
        <Channel channel={this.channel}>
          <Window>
            <ChannelHeader />
            <MessageList />
            <MessageInput />
          </Window>
          <Thread />
        </Channel>
      </Chat>
    );
  }
}

ClientChat.propTypes = {
  userHandle: PropTypes.string,
  userName: PropTypes.string,
  userToken: PropTypes.string,
  repId: PropTypes.string
};
export default ClientChat;
