function dropdown() {
  $('.dropdown-menu-right').slideToggle();
}
$(document).ready(function() {
  $("body").on("click", ".like_subpitch", function(e){
    e.preventDefault();
  });
});
