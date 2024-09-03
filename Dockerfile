FROM node:16

RUN apt-get update && \
    apt-get install -y git && \
    apt-get clean autoclean && apt-get autoremove --yes && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/bincdianshangcun/sonos-web.git

WORKDIR /sonos-web/client
RUN npm install && \
    npm run build && \
    mv dist ../server/

WORKDIR /sonos-web
RUN rm -rf client

WORKDIR /sonos-web/server
RUN npm install && \
	npm install https://github.com/bincdianshangcun/node-sonos#v1.15.0-test

EXPOSE 5050
CMD npm start
