const alert = document.querySelector('.alert');

const flashes = () => {
  if (alert) {
    $(".success-alert").fadeTo(2000, 500).slideUp(500, function(){
      $(".success-alert").slideUp(500);
    });
  }
}

export { flashes }