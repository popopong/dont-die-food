import $ from 'jquery';
import 'select2';


const initSelect2 = () => {
 // (~ document.querySelectorAll)
  // Home screen search bar to dropdown
  $('#ingredients').select2({
    sorter: data => data.sort((a, b) => a.text.localeCompare(b.text)),
    });
  // $('.food_trade_select').each((i, e) => { 
  //   // $(e).select2();
  //   // console.log(i, e);
  //   });
  document.querySelectorAll(".food_trade_select").forEach((select) => {
    $(select).select2()
  })
}

// window.initFoodTradeSelect2 = function(ingredientName) {
//   if (ingredientName) {
    // console.log(ingredientName);
    // $(`.food_trade_${ingredientName}`).select2({
    //   default: ingredientName,
    // });
//   }
// };

export { initSelect2 };
