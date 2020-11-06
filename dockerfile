FROM node:lts-alpine

WORKDIR /app

COPY package*.json ./

RUN yarn install

COPY . .

RUN yarn add @vue/cli@3.7.0 -g

EXPOSE 8080

CMD [ "yarn", "serve" ]
