$ ->
  "use strict"
  
  #-- Enable uniform for controls.
  $('[type=checkbox], [type=radio]').uniform()
  
  $('.chosen').chosen
    width: "100%"
    allow_single_deselect: true

  $(document).on("vc.scripts.refreshTooltips", () -> 
    if (!(/iphone|ipad|ipod/i.test(navigator.userAgent.toLowerCase())))
      $("div[data-toggle=tooltip], a[data-toggle=tooltip], a[data-tooltip=tooltip]").not(".tooltip_applied").tooltip()
      $("div[data-toggle=tooltip], a[data-toggle=tooltip], a[data-tooltip=tooltip]").not(".tooltip_applied").addClass("tooltip_applied")
  )
  $.event.trigger("vc.scripts.refreshTooltips");
