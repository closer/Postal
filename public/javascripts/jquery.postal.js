(function($){

$.fn.postalize = function(callback){
  var field = $(this);
  var id = field.attr('id');
  var button = $('.'+id+'-load');
  if(button.length == 0) button = $('<button>Load</button>').insertAfter(field.get(-1));
  var callback = callback || defaultCallback;

  button.click(function(){
    var zipcode = $.map(field, function(f){
      return $(f).val();
    }).join('').replace(/[^0-9]/g, '');
    $.getJSON(postal_base_url + 'api/' + zipcode + '?callback=?', onSuccess);
    return false;
  });

  function onSuccess(data) {
    callback(data);
  };

  function defaultCallback(data){
    var data = data[0];
    $.each(['prefecture', 'city', 'town', 'address'], function(){
      var elm = $('.'+id+'-'+this);
      var text = this == 'address'
        ? data['city'] + data['town']
        : data[this];
      switch(true) {
        case elm.is('select'):
          var options = elm.find('option');
          options.each(function(){
            if($.trim($(this).text()) == text || $(this).val() == text) {
              $(this).attr('selected', true);
            }
          });
          break;
        case elm.is('input'):
          elm.val(text);
          break;
        default:
          elm.text(text);
      }
      elm.focus();
    });
  }
  return this;
};

$(function(){
  $('.postalize').each(function(){
    $(this).postalize();
  });
});

})(jQuery);
