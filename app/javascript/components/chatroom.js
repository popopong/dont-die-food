const chatroom = () => {
  const messagesContainer = document.getElementById('messages');
  const message = document.querySelectorAll('.message');
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

    // Show time when clicked on message
    message.forEach((m) => {
      m.addEventListener("click", (event) => {
        let id = event.currentTarget.id;
        document.getElementById(`time-${id}`).classList.toggle("d-none");
      });
    })


  } 
};

export { chatroom };