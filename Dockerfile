FROM alpine
MAINTAINER steffen@familie-uhlig.net

RUN apk add             \
        --no-cache      \
      ca-certificates   \
      ruby              \
      ruby-bundler      \
      ruby-rake         \
      ruby-json

RUN    echo "gem: --no-document" > /etc/gemrc \
    && gem install bundler \
    && bundle config --global silence_root_warning 1 \
    && bundle config --global jobs 4

ADD . /opt
RUN cd /opt && bundle install --without=development test
