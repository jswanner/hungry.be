(function($){
  $.fn.hintedTextBox = function(text){
    return this.each(function(){
      var $this = $(this);
      $this
        .val(text)
        .addClass('hint')
        .bind('focus', function(){
          if($this.val() == text){
            $this
              .val('')
              .removeClass('hint');
          }
        })
        .bind('blur', function(){
          if($this.val() == ''){
            $this
              .val(text)
              .addClass('hint');
          }
        });

      // clear hint on form submit
      $this
        .parents('form')
        .bind('submit', function(){
          if($this.val() == text){
            $this
              .val('')
              .removeClass('hint');
          }
        });
    });
  };

  $.fn.titleAsHint = function(){
    return this.each(function(){
      var $this = $(this);
      $this.hintedTextBox($this.attr('title'));
    });
  };

  $.fn.labelAsHint = function(){
    return this.each(function(){
      var labels = $('label[for]');
      labels.each(function(){
        var label_for = $(this).attr('for');
        var textbox = $('#'+label_for+'[type="text"]');
        if(textbox.length > 0){
          textbox.hintedTextBox($(this).text());
          $(this).hide();
        }
      }); 
    });
  };
})(jQuery);
