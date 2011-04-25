(function($){

$.fn.postalize = function(callback){
  var field = $(this);
  var id = field.attr('id');
  var button = $('.'+id+'-load');
  if(button.length == 0) button = $('<button>Load</button>').insertAfter(field);
  var callback = callback || defaultCallback;

  button.click(function(){
    var zipcode = field.val().replace(/[^0-9]/g, '');
    $.getJSON('/'+zipcode, callback);
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
    });
  }
  return this;
};

})(jQuery);
