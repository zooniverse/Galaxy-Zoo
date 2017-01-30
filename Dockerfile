FROM ubuntu:14.04

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

WORKDIR /usr/src/app

RUN apt-get update && \
    apt-get install -y \
        ruby \
        bundler \
        git \
        libxml2-dev \
        libxslt-dev \
        curl \
        zlib1g-dev \
        && \
    curl https://deb.nodesource.com/setup_0.10 | bash - && \
    apt-get install -y nodejs && apt-get clean && \
    rm -rf /var/lib/apt/lists/*


COPY Gemfile /usr/src/app
COPY Gemfile.lock /usr/src/app

RUN bundle install

COPY package.json /usr/src/app

RUN git config --global url.https://github.com/.insteadOf ssh://git@github.com/

RUN npm install

COPY . /usr/src/app
