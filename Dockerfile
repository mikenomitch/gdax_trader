FROM ruby:2.3.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /trader
WORKDIR /trader
ADD Gemfile /trader/Gemfile
ADD Gemfile.lock /trader/Gemfile.lock
RUN bundle install
ADD . /trader
