const chatroom = () => {
  const messagesContainer = document.getElementById('messages');
  if (messagesContainer) {
    messagesContainer.scrollTo(0, messagesContainer.scrollHeight);
  }
};

export { chatroom };