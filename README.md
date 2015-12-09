[![CodeShip](https://www.codeship.io/projects/13e8e870-b9be-0131-0742-5af5088413f2/status)](https://www.codeship.io/projects/13e8e870-b9be-0131-0742-5af5088413f2/status)
[![Code Climate](https://codeclimate.com/github/wfjeff/twinenyc.png)](https://codeclimate.com/github/wfjeff/twinenyc)
[![Coverage Status](https://coveralls.io/repos/wfjeff/twinenyc/badge.png)](https://coveralls.io/r/wfjeff/twinenyc)

# Heat Seek NYC

## Description

We created Heat Seek NYC to address the need of adequate heating for low income tenants in NYC. Unfortunately, landlords will commonly lower the heating in their buildings to inhospitable levels in attempts to save money on heating, or to drive out poorer tenants to raise the rents.  This has serious impacts on the people living inside such buildings, range from deciding whether to eat this week or heat their apartment with expensive, dangerous space-heaters, to an increase likely hood of illness and death.

We designed Heat Seek NYC to help validate tenants claims against their landlords.  We use the Internet of things to record the temperature of apartments and remotely send them back to us.  Combined with real time measurements of the outside temperature, we create a record of every hour that the user's apartment's temperature is below the legal minimum.  By moving the burden of evidence off a tenant to a third party we hope to remove ambiguity from a court case that can be tinged with speculative evidence.

Heat Seek NYC thanks its three real world users that allowed us to collect data from their apartments for our proof of concept.

## Screenshots

![dashboard screenshot](https://raw.githubusercontent.com/wfjeff/twinenyc/master/app/assets/images/dashboard_screenshot.png)
![search screenshot](https://raw.githubusercontent.com/wfjeff/twinenyc/master/app/assets/images/search_screenshot.png)
![user edit screenshot](https://raw.githubusercontent.com/wfjeff/twinenyc/master/app/assets/images/user_edit_screenshot.png)

## Background

### Why did you want to make this app?

The Flatiron School's motto is "make yourself useful" and we took that to heart. We wanted to build something useful for the community that has given us so much. Additionally, we have dealt with improper heating in our own apartments and personally know people who are seriously affected by these issues every year.

###What was your development process like?

We started off with a bare-bones application that simply registered readings from temperature sensors using wifi. After proving that it was even possible we started implementing a mobile-first user experience in coordination with a local advocacy non-profit. The finished product you see now was custom built to suit the real needs of the community in collaboration with its members.

## Features

### Hourly Temperature Readings

The most important feature of our application is the ability to collect  temperature readings from apartments anywhere in New York and store them in our remote web servers. We implemented this feature using Twines from SuperMechanical to take the readings, collecting that information with Poltergeist using PhantomJS and Capybara.

### Export to PDF

Perhaps the second most important feature of the application is the ability to export our readings into a printable PDF file that can easily be used by attorneys in court as evidence. We implemented that with Prawn.

### Collaborators

This feature allows both users and collaborators such as lawyers and social workers to access their data.

## Security

This application uses Devise for authentication and a custom built authorization system to control access to user data. This way only the people who should have access can get to your information.

## Usage

Any advocacy group interested in using our application to help New Yorkers is more than welcome to. Let us know and we will be glad to help you get set up.

## Development/Contribution

If you'd like to submit a pull request please adhere to the following:

Your code must be tested. Please TDD your code!
No single-character variables
Two-spaces instead of tabs
Single-quotes instead of double-quotes unless you are using string interpolation or escapes
General Rails/Ruby naming conventions for files and classes

## Development Environment
We use [Vagrant](https://vagrantup.com) to ensure all of our development environments are consistent.

[Find out more about the vagrant virtual machine lifecycle.](https://docs.vagrantup.com/v2/getting-started/index.html)

If you are on a mac:
```
git clone https://github.com/heatseeknyc/heatseeknyc.git
brew install caskroom/cask/brew-cask
brew cask install virtualbox vagrant
vagrant plugin install vagrant-hostmanager vagrant-cachier
cd heatseeknyc
vagrant up
vagrant ssh
```

On a mac, you'll be able to find your development environment by running:
```
open http://`whoami`.dev.heatseeknyc.com
```
The rails app lives in ```/vagrant/```

## Future

This technology is currently in use by the [Urban Justice Center](http://www.urbanjustice.org/) who provided us with users for our proof-of-concept. We hope that this project will be used next heating season by advocacy groups like them.

## Authors
[William Jeffries](http://www.linkedin.com/in/williamjeffries), and [Tristan Siegel](http://www.linkedin.com/in/tristantsiegel), students at the [Flatiron School](http://flatironschool.com/) in New York.

## License
This application is MIT Licensed. See [LICENSE](https://github.com/wfjeff/twinenyc/blob/master/LICENSE) for details.
