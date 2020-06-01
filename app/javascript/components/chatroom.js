const chatroom = () => {
  const messagesContainer = document.getElementById('messages');
  if (messagesContainer) {
    // By default, window is showing latest messages (bottom of conversation)
    messagesContainer.scrollTo(0, messagesContainer.scrollHeight);

    // Enter sends the message
    messagesContainer.addEventListener("keyup", (event) => {
      if (event.keyCode === 13) {
        event.preventDefault();
        document.getElementById("submit-mess").click();
      }
    });
  }
};

export { chatroom };