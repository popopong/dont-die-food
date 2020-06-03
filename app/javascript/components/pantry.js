import $ from 'jquery'

// const trigger = $("#pantry-remove-trigger");
// const targets = $(".pantry-remove")

const removeItem = () => {
  // trigger.addEventListener("click", (event) => {
  //   targets.forEach( element => {
  //     element.classList.toggle("pantry_hide");
  //     element.disabled = "true";
  //   });
  // });
  $(".pantry_hide").each(function(event) {
    $( this ).hide();
  });

  $("#pantry-remove-trigger").click(function() {
    $(".pantry-remove").each(function(event) {
      if ($( this ).hasClass("pantry_hide")) {
        $( this ).fadeIn();
      } else {
        $( this ).fadeOut();
      }
      $( this ).toggleClass("pantry_hide");
    });
  });

};

export { removeItem }
