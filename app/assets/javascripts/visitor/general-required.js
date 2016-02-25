var escapeHTML = (function () {
    'use strict';
    var chr = { '"': '&quot;', '&': '&amp;', '<': '&lt;', '>': '&gt;',':':'%3A' };
    return function (text) {
        return text.replace(/[\"&<>:]/g, function (a) { return chr[a]; });
    };
}());

function applyDiscusCommentCount(disqusShortname) {
  if (typeof window.addedDisqus == "undefined") {
    window.addedDisqus = true;
    function addDisqusCommentCount() {
      var dataToLoad = ""
      $.each ($("[data-disqus-identifier]"), function (i, element) {
        if (dataToLoad.length > 0) dataToLoad += "&" 
        dataToLoad += "1=" + escapeHTML(element.attributes["data-disqus-identifier"].value);
      });
      var scriptObj = $(document.createElement("script")).attr("src","http://"+disqusShortname+".disqus.com/count-data.js?"+dataToLoad).attr("async","async");
      var tempWidget = false
      if (typeof DISQUSWIDGETS == "undefined") {
        DISQUSWIDGETS = function() {};
        DISQUSWIDGETS.displayCount = function (data) {
          for (var enumer = data.counts, data = data.text.comments; element = enumer.shift();) {
            $("[data-disqus-identifier='"+element.id+"']").html(element.comments);
          }
        }
      }
      $("head").append(scriptObj);
      
    }
    var disqus_shortname = disqusShortname;
  

    $(document).on("vc.new_content_added", addDisqusCommentCount);
  }
};
$(window).scroll(function(){
  if( $(window).scrollTop() > $('nav.navbar').height() ) {
    $('.adminToolbar').addClass("fadeout");
  } else {
    $('.adminToolbar').removeClass("fadeout");
  }
});
