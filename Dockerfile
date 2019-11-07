FROM ruby:2.6
MAINTAINER Stanislav Mekhonoshin <ejabberd@gmail.com>

WORKDIR /app

RUN gem install foreman bundler

COPY ./Gemfile /app/Gemfile
COPY ./Gemfile.lock /app/Gemfile.lock
RUN bundle install

COPY . /app/

ENTRYPOINT ["/app/entrypoint.sh"]
