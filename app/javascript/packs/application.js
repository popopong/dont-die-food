// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)


// ----------------------------------------------------
// Note(lewagon): ABOVE IS RAILS DEFAULT CONFIGURATION
// WRITE YOUR OWN JS STARTING FROM HERE 👇
// ----------------------------------------------------

// External imports
import "bootstrap";

// Internal imports, e.g:
// import { initSelect2 } from '../components/init_select2';
// import { typed } from "../components/typed_js"
import { typed } from "../components/typed_js"
import { flashes } from "../components/flashes"
import { initMapbox } from '../plugins/init_mapbox';
import { initSelect2 } from '../plugins/init_select2';
import { chatroom } from "../components/chatroom"
import { initChatroomCable  } from '../channels/chatroom_channel';
import { removeItem } from "../components/pantry";
import { initSweetalert } from '../plugins/init_sweetalert';
import { initSweetalertDelete } from '../plugins/init_sweetalert_delete';

document.addEventListener('turbolinks:load', () => {
  // Call your functions here, e.g:
  // initFoodTradeSelect2();
  initSelect2();
  typed();
  initMapbox();
  initChatroomCable();
  chatroom();
  removeItem();
  flashes();
  initSweetalert('#sweet-alert', {
    title: "Successfully created!",
    icon: "success"
  }, (value) => {
    if (value) {
      const link = document.getElementById('create-link');
      link.click();
    }
  });

  initSweetalertDelete('#sweet-alert-delete', {
    title: "Are you sure?",
    dangerMode: true,
    buttons: ["Cancel", "Delete"]
    }, (value) => {
      if (value) {
        const link = document.getElementById('delete-link');
        link.click();
      }
    });
 });
