import React from "react";
import PropTypes from "prop-types";
import {
  Channel,
  ChannelHeader,
  ChannelList,
  ChannelListMessenger,
  ChannelPreviewCompact,
  Chat,
  InfiniteScrollPaginator,
  MessageInput,
  MessageInputFlat,
  MessageList,
  Thread,
  TypingIndicator,
  Window
} from "stream-chat-react";

import { StreamChat } from "stream-chat";

import "stream-chat-react/dist/css/index.css";

class RepresentativeChat extends React.Component {
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
        id: this.props.repId,
        name: this.props.repName,
        image:
          "https://getstream.io/random_svg/?id=${repUserId}&name=Representative"
      },
      this.props.repToken
    );
  }
  render() {
    const filters = {
      type: "messaging",
      source: "support",
      members: { $in: [this.props.repId] }
    };
    const sort = {
      last_message_at: -1,
      cid: 1
    };
    return (
      <Chat client={this.chatClient} theme={"messaging dark"}>
        <ChannelList
          List={ChannelListMessenger}
          Preview={ChannelPreviewCompact}
          filters={filters}
          sort={sort}
          Paginator={props => (
            <InfiniteScrollPaginator threshold={300} {...props} />
          )}
        />
        <Channel>
          <Window>
            <ChannelHeader />
            <MessageList TypingIndicator={TypingIndicator} />
            <MessageInput Input={MessageInputFlat} focus />
          </Window>
          <Thread />
        </Channel>
      </Chat>
    );
  }
}

RepresentativeChat.propTypes = {
  repId: PropTypes.string,
  repToken: PropTypes.string,
  repName: PropTypes.string
};

export default RepresentativeChat;
