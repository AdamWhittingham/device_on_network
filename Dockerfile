FROM ruby:2.2.1

# Update image packages
RUN apt-get update  -y -qq
RUN apt-get install -y build-essential

# Update project dependencies
RUN apt-get install -y nmap

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile $APP_HOME/Gemfile
RUN bundle install --without test development

ADD . $APP_HOME
