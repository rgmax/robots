FROM node:8-alpine

RUN apk update && apk add --no-cache wget openssl tini

ARG NODE_ENV='production'
ENV NODE_ENV = ${NODE_ENV}

WORKDIR /usr/service
COPY ./package.json ./
RUN apk add --no-cache make gcc g++ python && \
  yarn install --pure-lockfile && \
  apk del make gcc g++ python

RUN yarn global add forever

COPY . .

ENTRYPOINT ["/sbin/tini"]

CMD yarn start
