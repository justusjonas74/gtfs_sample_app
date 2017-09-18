jQuery(function() {
  return $('#search_stop_term').autocomplete({
    source: $('#search_stop_term').data('autocomplete-source'),
    minLength: 2,
    select: function(event, ui) { 
        $("#search_stop_term").val(ui.item.label);
        $("#search-form").submit(); }
  });
});

