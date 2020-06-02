import $ from 'jquery';
import 'select2';

const initSelect2 = () => {
  $('#food_trade_user_owned_ingredient_id').select2(); // (~ document.querySelectorAll)
  // Home screen search bar to dropdown
  $('#ingredients').select2({
    sorter: data => data.sort((a, b) => a.text.localeCompare(b.text)),
    });
}

export { initSelect2 };
