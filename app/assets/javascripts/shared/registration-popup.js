function loginPopupSize(modal) {
  var width, height;
  height = ($(window).height() * .90);
  if ($("#new").hasClass("active")) {
    if($(window).width() > 670) {
      width = 650;
      height = height > 620 ? 620 : height;
    } else if($(window).width() > 450) {
      width = 430;
      height = height > 790 ? 790 : height;
    } else {
      width = $(window).width()*.90;
      height = height > 700 ? 700 : height;
    }
  } else if ($("#existing").hasClass("active")) {
    if($(window).width() > 670) {
      width = 650;
      height = height > 470 ? 470 : height;
    } else if($(window).width() > 450) {
      width = 430;
      height = height > 580 ? 580 : height;
    } else {
      width = $(window).width()*.90;
      height = height > 550 ? 550 : height;
    }
  } 
  
  return [width,height];
}
