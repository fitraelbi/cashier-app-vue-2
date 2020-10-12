FROM node:12.2.0-alpine
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY package.json /app/package.json
RUN yarn install
RUN yarn add @vue/cli@3.7.0 -g
CMD ["yarn", "serve"]
