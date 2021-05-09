FROM ruby:3.0.1

RUN apt-get update && apt-get -y install cron

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN bundle exec whenever --update-crontab
