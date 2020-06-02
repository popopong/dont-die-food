import $ from 'jquery';
import 'select2';


const initSelect2 = () => {
 // (~ document.querySelectorAll)
  // Home screen search bar to dropdown
  $('#ingredients').select2({
    sorter: data => data.sort((a, b) => a.text.localeCompare(b.text)),
    });

  document.querySelectorAll(".food_trade_select").forEach((select) => {
    $(select).select2()
  })
}

export { initSelect2 };
