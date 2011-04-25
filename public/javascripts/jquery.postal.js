(function($){

var base_url = "http://localhost:3000/";

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
    $.getJSON(base_url + zipcode, callback);
  });

  function defaultCallback(data){
    var data = data[0];
    $.each(['prefecture', 'city', 'town', 'address'], function(){
      var elm = $('.'+id+'-'+this);
      var text = this == 'address'
        ? data['city'] + data['town']
        : data[this];
      switch(true) {
        case elm.is('select'):
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

})(jQuery);
