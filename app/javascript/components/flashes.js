let alert = document.querySelector('.alert');

const flashes = () => {
  if (alert) {
    $(".alert-success").fadeTo(2000, 500).slideUp(500, function(){
      $(".alert-success").slideUp(500);
    });
  }
}

export { flashes }