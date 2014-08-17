$(function () {
  var twitterLink = $('#kickstarter .twitter button');
  var facebookLink = $('#kickstarter .facebook button');
  var kickstarterLink = $('#kickstarter .ks-video button');
  var progressBar = $('#kickstarter progress');
  var percentage = $('#kickstarter .progress .percentage');
  var
    twitterVisited,
    facebookVisited,
    kickstarterVisited;

  var increaseProgress = function (link) {
    if (link === 'twitter') {
      twitterLink.attr('data-visited', 1);
    } else if (link === 'facebook') {
      facebookLink.attr('data-visited', 1);
    } else if (link === 'kickstarter') {
      kickstarterLink.attr('data-visited', 1);
    }
    twitterVisited = twitterLink.attr('data-visited') | 0;
    facebookVisited = facebookLink.attr('data-visited') | 0;
    kickstarterVisited = kickstarterLink.attr('data-visited') | 0;
    progress = parseInt(twitterVisited) + 
      parseInt(facebookVisited) + 
      parseInt(kickstarterVisited);
    progressBar.attr('value', progress);
    progress = Math.round(progress * 100 / 3);
    percentage.text(progress + '%');
  };

  twitterLink.on('click', function(){increaseProgress('twitter')});
  facebookLink.on('click', function(){increaseProgress('facebook')});
  kickstarterLink.on('click', function(){increaseProgress('kickstarter')});
});
