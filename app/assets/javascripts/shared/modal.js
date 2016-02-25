  modal_sizeFunction = null;
  modal_size = null
  
  function resizeModal() {
    var $modal = $('#information-modal');
    var width = 0, height = 0;
    if (modal_sizeFunction != null) {
      size = modal_sizeFunction($modal);
      if (size != null && size.length == 2 && size[0] != null) {
        width = size[0];
        height = size[1];
      }
    } else if (modal_size != null) {
      width = modal_size[0];
      height = modal_size[1];
    } 
    
    if (width == null || width <= 0) {
      width = 800;
    }
    
    $modal.css('margin-left',0);
    $modal.css('width',width);
    $modal.css('left',$(window).width()/2 - width/2);
    if (height != null && height > 0) {
      $modal.css('height',height);
      $modal.css('top',$(window).height()/2 - height/2);
    }
    $modal.css('margin-top',0);
    $("#information-modal .modal-body").height(height-83);
    $("#information-modal .popupSignIn .panel-body").height(height-49);
    
  }

  function modalSetContentSize(width, height) {
    $("#information-modal .contentMediaDisplay > iframe").width(width).height(height);
    $("#information-modal .contentMediaDisplay > img").width(width).height(height);
    $("#information-modal .contentItemArea > .contentMediaDisplay > .contentDownloadButton > .fa").css("font-size", height+"px").width(width).height(height>width?height:width);
  }
  
  function refreshModal() {
    var $modal = $('#information-modal');
    $modal.modal('layout');
  }
  
  function openModalUrl(url, title, size, top) {
      $("modal-backdrop").remove();
      $("modal-scrollable").remove();
      modal_sizeFunction = (typeof(size) == "function" ? size : null);
      size = (typeof(size) != "function" ? size : null);
      modal_size = size;
  
      var options;
      width = 1100;
      height = null
      if (modal_sizeFunction != null) {
        size = modal_sizeFunction($('#information-modal'));
      }
      if (size != null && size.length == 2 && size[0] != null) {
        width = size[0];
        height = size[1];
      }
      if (top == null) {
        top = 150;
      }
      
      $modal = $('#information-modal');
      
      if (height != null) {
        $modal.height(height);
        $modal.attr("height",height+"px")
      }

      $('body').modalmanager('loading');
      $(window).resize(resizeModal);
      $modal.load(url, '', function(){
        resizeModal();
        $modal.modal({width: width, height: height, resize: false});
        resizeModal();
      });
      $modal.on('hidden.bs.modal', function (e) {
        $('#information-modal .contentMediaDisplay').html('blank');
      });
      return false;
  }
  function applyModalPopupClass() {
      $('.modal_popup').not(".modal_click_applied").click(function(event){
        event.preventDefault();
        var size;
        if ($(this).attr('modalSizeFunction') != undefined) {
          size = eval($(this).attr('modalSizeFunction'));
        } else {
          width = $(this).attr('modalwidth');
          width = width == undefined ? null : width;
          height = $(this).attr('modalheight');
          height = height == undefined ? null : height;
          
          size = [width,height];
        }
        openModalUrl($(this).attr('href'), $(this).children('a').attr('title'),size);
        resizeModal();
        
      });
      $('.modal_popup').not(".modal_click_applied").addClass("modal_click_applied");
  }
  

  // ----- Modal Dialog processing ----- 
  applyModalPopupClass();
  $(document).ready(function () {
    applyModalPopupClass();
  });

  // Override default spinner for modal manager
  $.fn.modal.defaults.spinner = $.fn.modalmanager.defaults.spinner = 
  '<div class="loading-spinner" style="width: 200px; margin-left: -100px;">' +
      '<div class="progress progress-striped active">' +
          '<div class="progress-bar" style="width: 100%;"></div>' +
      '</div>' +
  '</div>';
  // ----- END Modal Dialog processing ----- 
  