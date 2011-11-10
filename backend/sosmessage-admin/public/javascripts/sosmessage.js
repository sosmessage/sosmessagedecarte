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
});


