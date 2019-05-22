import React from "react";

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

const repUserId = process.env.REP_USER_ID;
const repUserToken = process.env.REP_USER_TOKEN;

class RepresentativeChat extends React.Component {
  constructor(props) {
    super(props);
    this.chatClient = new StreamChat(process.env.STREAM_API_KEY);
    this.chatClient.setUser(
      {
        id: repUserId,
        name: "Representative",
        image:
          "https://getstream.io/random_svg/?id=${repUserId}&name=Representative"
      },
      repUserToken
    );
  }
  render() {
    const filters = { type: "commerce", source: "support" };
    const sort = {
      last_message_at: -1,
      cid: 1
    };
    return (
      <Chat client={this.chatClient} theme={"commerce dark"}>
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

export default RepresentativeChat;
