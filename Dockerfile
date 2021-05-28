FROM ruby:2.7.3
RUN apt-get update -qq && \
        apt-get install -y build-essential \
                                libpq-dev \
                                nodejs

WORKDIR /hospital_scraper

ADD Gemfile /hospital_scraper/Gemfile
ADD Gemfile.lock /hospital_scraper/Gemfile.lock

RUN gem install bundler
RUN bundle install

ADD . /hospital_scraper
