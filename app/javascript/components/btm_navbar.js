const btmNavbar = () => {
  window.onscroll = function() {myFunction()};

  var navbar = document.getElementById("btm-navbar");
  var sticky = navbar.offsetTop;

  function myFunction() {
    if (window.pageYOffset >= sticky) {
      navbar.classList.add("sticky")
    } else {
      navbar.classList.remove("sticky");
    }
  }

  const icons = document.querySelectorAll(".btm-nav-icons");
  icons.forEach((icon) => {
    icon.addEventListener("click", (event) => {
    event.preventDefault();
    event.currentTarget.classList.add("active");
      // event.currentTarget.classList.add("active");
      console.log(event.currentTarget);
    });
  });
};

export { btmNavbar };