import $ from 'jquery';
import 'select2';


const initSelect2 = () => {

  if (!$('#ingredients').hasClass("select2-hidden-accessible")) {
  // Home screen search bar to dropdown
    $('#ingredients').select2({
      sorter: data => data.sort((a, b) => a.text.localeCompare(b.text)),
    });
  }

  if (!$('.food_trade_select').hasClass("select2-hidden-accessible")) {
    $('.food_trade_select').select2(); // (~ document.querySelectorAll)
  }

  if (!$('.food_trade_category_select').hasClass("select2-hidden-accessible")) {
    $('.food_trade_category_select').select2(); // (~ document.querySelectorAll)
  }

  if (!$('#pantry_item_ingredient_id').hasClass("select2-hidden-accessible")) {
    $('#pantry_item_ingredient_id').select2(); // (~ document.querySelectorAll)
  }
}

export { initSelect2 };
