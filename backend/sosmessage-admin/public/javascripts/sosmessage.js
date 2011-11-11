$(document).ready(function() {
  $('.delete-message').each(function() {
     $(this).click(function() {
         return confirm("Are you sure you want to delete this message?");
   }) ;
  });
  $('.delete-category').each(function() {
     $(this).click(function() {
         return confirm("Are you sure you want to delete this category?");
     }) ;
  });

  $('#select-category').change(function() {
    $('#select-category option:selected').each(function () {
      window.location.href = '/category/' + $(this).attr("value")  + '/messages';
    });
  })
});


