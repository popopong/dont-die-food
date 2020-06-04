import $ from 'jquery'

const removeItem = () => {

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
