const trigger = document.getElementById("pantry-remove-trigger");

const targets = document.querySelectorAll(".pantry-remove")

const removeItem = () => {
  trigger.addEventListener("click", (event) => {
    targets.forEach( element => {
      element.classList.toggle("pantry_hide");
      element.disabled = "true";
    });
  });
};

export { removeItem }
