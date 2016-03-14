namespace :articles do
  desc "TODO"
  task seed: :environment do

    [
      "http://observer.com/2014/08/heat-seek-nyc-the-app-set-to-protect-struggling-tenants-this-winter/",
      "http://www.wired.com/2014/08/heat-seek-nyc/",
      "http://www.engadget.com/2014/08/27/heat-seek-temperature-monitor-nyc-kickstarter/",
      "http://www.theverge.com/2014/8/27/6075129/Heat-Seek-NYC-smart-temperature-sensor-kickstarter",
      "http://www.bkmag.com/2014/08/26/new-app-will-track-landlords-who-dont-turn-up-the-heat/",
      "http://www.gadgetreview.com/2014/08/heat-seek-nyc.html",
      "http://gothamist.com/2014/08/26/new_app_measures_wintertime_apartme.php",
      "http://microsoftnewyork.com/2014/07/22/bigapps-and-open-data/",
      "http://betabeat.com/2014/06/slumlord-cyber-killers",
      "https://medium.com/@FlatironSchool/heat-seek-nyc-aims-to-keep-the-city-warm-with-code-d1da5d2a2641",
      "http://bit.ly/mlbmay2014"
    ].each do |article_link|
      article = Article.find_by(article_link: article_link)
      puts article
      article.destroy unless article.nil?
    end

    Article.create(
      title: "Heat Seek NYC: The App Set to Protect Struggling Tenants This Winter",
      company: "The New York Observer",
      company_link: "http://observer.com/",
      published_date: Date.parse("2014-08-28"),
      article_link: "http://observer.com/2014/08/heat-seek-nyc-the-app-set-to-protect-struggling-tenants-this-winter/",
      description: "With summer now drawing to a close, people are mentally preparing for winter. For many, though, heating their NYC apartments during these freezing months is a battle."
    )

    Article.create(
      title: "How to Use the Internet of Things to Fight Slumlords",
      company: "WIRED",
      company_link: "http://www.wired.com/",
      published_date: Date.parse("2014-08-26"),
      article_link: "http://www.wired.com/2014/08/heat-seek-nyc/",
      description: "Google’s Nest thermostat makes it easy to save money by automatically turning down the heat when you’re not around. But many people don’t have the luxury of controlling their own temperature settings, let alone the money to buy expensive gadgets that can do it automatically."
    )

    Article.create(
      title: "Heat Seek Temperature Monitors Want to Keep NYC Tenants Warm, Bring Scummy Landlords to Justice",
      company: "Engadget",
      company_link: "http://www.engadget.com/",
      published_date: Date.parse("2014-08-27"),
      article_link: "http://www.engadget.com/2014/08/27/heat-seek-temperature-monitor-nyc-kickstarter/",
      description: "Since it's darn hard getting an inspector to come and verify a heat violation, a new KickStarter project called Heat Seek NYC wants to give people the power to gather their own evidence using simple internet-connected temperature sensors."
    )

    Article.create(
      title: "This Smart Thermostat Wants to Turn Up the Heat On Slumlords",
      company: "The Verge",
      company_link: "http://www.theverge.com/",
      published_date: Date.parse("2014-08-27"),
      article_link: "http://www.theverge.com/2014/8/27/6075129/Heat-Seek-NYC-smart-temperature-sensor-kickstarter" ,
      description: "As it stands now, the biggest problem for tenants is gathering enough evidence. You need a city inspector to properly document the low temperatures, but the inspectors are stretched thin, appearing in a 36-hour window that often comes while tenants are at work. If the inspector comes on a warm day, the whole process has to start again."
    )

    Article.create(
      title: "New App Will Track Landlords Who Don’t Turn Up the Heat",
      company: "Brooklyn Magazine",
      company_link: "http://www.bkmag.com/",
      published_date: Date.parse("2014-08-27"),
      article_link: "http://www.bkmag.com/2014/08/26/new-app-will-track-landlords-who-dont-turn-up-the-heat/",
      description: "The way it works is simple: tenants install a system of web-enabled sensors throughout their apartments, which automatically take temperature readings every hour and record them in a centralized database online. Tenants, advocates, and watchdog lawyers can then log in to check the data and set alerts if it drops below a certain level."
    )

    Article.create(
      title: "Heat Seek NYC Wants To Fix New York City’s Heating Crisis",
      company: "Gadget Review",
      company_link: "http://www.gadgetreview.com/",
      published_date: Date.parse("2014-08-26"),
      article_link: "http://www.gadgetreview.com/2014/08/heat-seek-nyc.html",
      description: "It feels really good knowing you did something good for another person, and that’s exactly the feeling you’re get when you invest in a Heat Seek NYC thermometer. What makes this thermometer so special is that it connects to the web to help NYC turn the heat on for thousands of tenants that will go with no heat in brutal Big Apple winters."
    )

    Article.create(
      title: "New App Will Hold Bad Landlords Accountable For Frigid Apartments",
      company: "Gothamist",
      company_link: "http://gothamist.com/",
      published_date: Date.parse("2014-08-26"),
      article_link: "http://gothamist.com/2014/08/26/new_app_measures_wintertime_apartme.php",
      description: "It was only a matter of time before someone decided to battle this age-old lamentation with sleek technology, and now it's here. The device, and accompanying app, is called Heat Seek NYC, and it aims to prevent vulnerable New Yorkers from suffering in their own homes."
    )

    Article.create(
      title: "BigApps and Open Data",
      company: "Microsoft New York",
      company_link: "http://microsoftnewyork.com/",
      published_date: Date.parse("2014-07-22"),
      article_link: "http://microsoftnewyork.com/2014/07/22/bigapps-and-open-data/",
      description: "[The] winner of the people’s choice vote may have been the biggest star of the day: Heat Seek NYC."
    )

    Article.create(
      title: "Slumlord Cyber Killers — An App to Bust Heat Misers",
      company: "BetaBeat",
      company_link: "http://betabeat.com",
      published_date: Date.parse("2014-06-03"),
      article_link: "http://betabeat.com/2014/06/slumlord-cyber-killers",
      description: "Techies turn up the heat on shady NYC slumlords."
    )

    Article.create(
      title: "Heat Seek NYC Aims to Keep the City Warm with Code",
      company: "Flatiron School",
      company_link: "http://flatironschool.com",
      published_date: Date.parse("2014-05-20"),
      article_link: "https://medium.com/@FlatironSchool/heat-seek-nyc-aims-to-keep-the-city-warm-with-code-d1da5d2a2641",
      description: "Flatiron Alums William Jeffries and Tristan Siegel want to help NYC residents turn up their heat with an app that records temperature."
    )

    Article.create(
      title: "New York Tech Meetup: Hack of the Month",
      company: "New York Tech Meetup",
      company_link: "http://nytm.org",
      published_date: Date.parse("2014-05-06"),
      article_link: "http://bit.ly/mlbmay2014",
      description: "Heat Seek NYC: helps tenants prove their apartment is too cold when their landlords don't turn the heat up in the winter (fast forward through video to Hack of the Month bookmark)."
    )
  end

end
