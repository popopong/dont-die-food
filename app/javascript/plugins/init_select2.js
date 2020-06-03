import $ from 'jquery';
import 'select2';


const initSelect2 = () => {

  if (!$('#ingredients').hasClass("select2-hidden-accessible")) {
  // Home screen search bar to dropdown
    $('#ingredients').select2({
      sorter: data => data.sort((a, b) => a.text.localeCompare(b.text)),
    });
    
  document.querySelectorAll(".food_trade_select").forEach((select) => {
    $(select).select2()
  })
  }

  if (!$('#food_trade_user_owned_ingredient_id').hasClass("select2-hidden-accessible")) {
    $('#food_trade_user_owned_ingredient_id').select2(); // (~ document.querySelectorAll)
  }
}

