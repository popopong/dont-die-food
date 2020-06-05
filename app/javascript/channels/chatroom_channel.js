import consumer from "./consumer";

const initChatroomCable = () => {
  const messagesContainer = document.getElementById('messages');
  if (messagesContainer) {
    const id = messagesContainer.dataset.chatroomId;
    const currentUserId = messagesContainer.dataset.currentUserId;

    consumer.subscriptions.create({ channel: "ChatroomChannel", id: id }, {
      received(dataString) {
        const data = JSON.parse(dataString);

        if (data.receiver_id === Number.parseInt(currentUserId)) {
          messagesContainer.insertAdjacentHTML('beforeend', data.message_html);
          messagesContainer.scrollTo(0, messagesContainer.scrollHeight);
        }
      },
    });
  }
}

export { initChatroomCable };
