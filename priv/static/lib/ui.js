jQuery(document).ready(function($){
  $(window).scroll(function(){
    if( $(this).scrollTop() > 0 ){
      $('.navbar').addClass('filled');
    } else {
      $('.navbar').removeClass('filled');
    }
  });
});