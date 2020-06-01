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
<<<<<<< HEAD
=======
import { typed } from "../components/typed_js"
import { initMapbox } from '../plugins/init_mapbox';
import { initSelect2 } from '../plugins/init_select2';
>>>>>>> 94dd2891127687697d2175a9ae6bd16bf1b25d6e

// Internal imports, e.g:
// import { initSelect2 } from '../components/init_select2';
import { typed } from "../components/typed_js"
import { chatroom } from "../components/chatroom"
// import { btmNavbar } from "../components/btm_navbar";
import { initMapbox } from '../plugins/init_mapbox';
import { initSelect2 } from '../plugins/init_select2';
import { initChatroomCable  } from '../channels/chatroom_channel';

document.addEventListener('turbolinks:load', () => {
  // Call your functions here, e.g:
  initSelect2();
  typed();
  initMapbox();
  initChatroomCable();
  chatroom();
});
