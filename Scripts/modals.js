
$(document)  
  .on('show.bs.modal', '.modal', function(event) {
    $(this).appendTo($('.modal-container'));
  })
  .on('shown.bs.modal', '.modal.in', function(event) {
    setModalsAndBackdropsOrder();
  })
  .on('hidden.bs.modal', '.modal', function(event) {
    setModalsAndBackdropsOrder();
    if ($('.modal.in').length == 0) {
      $('body').removeClass('modal-open');
    }
  });

function setModalsAndBackdropsOrder() {  
  $('body').addClass('modal-open');
  var modalZIndex = $('.modal.in').length + 1050 + 1;
  var backdropZIndex = modalZIndex - 1;
  $('.modal-backdrop').addClass('hidden');
  $('.modal.in:last').css('z-index', modalZIndex);
  $('.modal-backdrop.in:last').css('z-index', backdropZIndex).removeClass('hidden');
}