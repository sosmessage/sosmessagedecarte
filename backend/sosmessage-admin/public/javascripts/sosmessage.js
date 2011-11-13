$(document).ready(function() {
  $('.delete-category').each(function() {
    $(this).click(function() {
      return confirm("Are you sure you want to delete this category?");
    }) ;
  });
  $('.delete-message').each(function() {
    $(this).click(function() {
      return confirm("Are you sure you want to delete this message?");
    }) ;
  });
  $('.approve-button').each(function() {
    $(this).click(function() {
      return confirm("Are you sure you want to approve this message?");
    }) ;
  });
  $('.reject-button').each(function() {
    $(this).click(function() {
      return confirm("Are you sure you want to reject this message?");
    }) ;
  });
  $('.approve-all-waiting').each(function() {
    $(this).click(function() {
      return confirm("Are you sure you want to approve all waiting messages?");
    }) ;
  });
  $('.delete-all-waiting').each(function() {
    $(this).click(function() {
      return confirm("Are you sure you want to delete all waiting messages?");
    }) ;
  });
  $('.reject-all-waiting').each(function() {
    $(this).click(function() {
      return confirm("Are you sure you want to reject all waiting messages?");
    }) ;
  });

  $('.approve-all-rejected').each(function() {
    $(this).click(function() {
      return confirm("Are you sure you want to approve all rejected messages?");
    }) ;
  });
  $('.delete-all-rejected').each(function() {
    $(this).click(function() {
      return confirm("Are you sure you want to delete all rejected messages?");
    }) ;
  });

  $('#select-category').change(function() {
    $('#select-category option:selected').each(function () {
      window.location.href = $(this).attr("sosmessage-redirect-url");
    });
  });
});
