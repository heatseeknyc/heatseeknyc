# Contributing Code to HeatSeek

## Write Tests

We have a rails integrated rspec test suite, with support for javascript interactions with webdriver.

## Run Tests

```
bundle exec rspec
```

## CI

When a pull request is made Circle CI runs the test suite before pushing to the Heroku dev environment. A pull request
can only be accepted if the build passes.
