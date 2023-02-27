FROM node:16.19 as builder
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
ARG VERSION=${VERSION}
RUN npm version ${VERSION} && npm run build

FROM nginx:1.22.1
RUN mkdir /app
COPY --from=builder /usr/src/app/dist /app
CMD sed -i -e "s,{{ VUE_APP_API_URL }},$VUE_APP_API_URL,g" /app/js/app.*.js && nginx -g "daemon off;"
EXPOSE 8080
