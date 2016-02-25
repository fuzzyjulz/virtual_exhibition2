  $(document).ready(function () {
    $('select[data-linked=select]').each(function (i) {
      var child_dom_id = $(this).attr('id');
      var parent_dom_id = $(this).data('linked-parent-id');
      var path_mask = $(this).data('linked-collection-path');
      var path_regexp = /:[0-9a-zA-Z_]+:/g;
      var option_value = $(this).data('linked-collection-value');
      var option_label = $(this).data('linked-collection-label');
      var child = $('select#' + child_dom_id);
      var parent = $('#' + parent_dom_id);
      var loading_prompt = $('<option value=\"\">').text('Loading options...');
      var no_items_prompt = $('<option value=\"\">').text('No options available');
      
      option_value = (option_value === undefined ? "id" : option_value);
      option_label = (option_label === undefined ? "name" : option_label);
      
      parent.on('change', function () {
        child.attr('disabled', true);
        child.empty().append(loading_prompt);
        child.trigger("chosen:updated")
        if (parent.val()) {
          var path = path_mask.replace(path_regexp, parent.val());
          $.getJSON(path, function (data) {
            child.empty();
            var itemsChanged = false;
            $.each(data, function (i, object) {
              if (object[option_value] === undefined) {
                $.each(object, function (i, subobject) {
                  child.append($('<option>').attr('value', subobject[option_value]).text(subobject[option_label]));
                  itemsChanged = true;
                });
              } else {
                child.append($('<option>').attr('value', object[option_value]).text(object[option_label]));
                itemsChanged = true;
              }
            });
            child.attr('disabled', !itemsChanged);
            if (!itemsChanged) {
              child.append(no_items_prompt);
            }
            child.trigger("chosen:updated")
          });
        }
      });
    });
  });