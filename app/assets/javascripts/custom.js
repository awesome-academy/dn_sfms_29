function dropdown() {
  $('.dropdown-menu-right').slideToggle();
}
$(document).ready(function() {
  $("body").on("click", ".like_subpitch", function(e){
    e.preventDefault();
  });
});
$(function () {
  $('#datetimepicker1, #datetimepicker2').datetimepicker({
    format: 'YYYY-MM-DD'
  });
});
