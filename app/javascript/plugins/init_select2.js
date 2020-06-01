import $ from 'jquery';
import 'select2';

const initSelect2 = () => {
  $('#food_trade_user_owned_ingredient_id').select2(); // (~ document.querySelectorAll)
  $('#ingredients').select2(); // Home screen search bar to dropdown
};

export { initSelect2 };
