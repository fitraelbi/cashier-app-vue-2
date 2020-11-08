FROM node:12.2.0-alpine as build
WORKDIR /app
COPY package.json /app/package.json
RUN yarn install --silent
RUN yarn add @vue/cli@3.7.0 -g
COPY . /app
RUN yarn run build

FROM nginx:1.16.0-alpine
COPY --from=build /app/dist /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
COPY ./nginx.conf /etc/nginx/conf.d
VOLUME /var/log/nginx/log
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
