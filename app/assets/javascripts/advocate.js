$(function () {
  $('#permissions-show-div').on('click', '.collaborator-link-div', function(e){
    var link = $(this).find('a').first().attr('href');
    window.location.href = link;
  });
});