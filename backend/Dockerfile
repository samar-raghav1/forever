FROM node:20 AS build 

WORKDIR /app

COPY package*.json ./

RUN npm install


COPY .env.sample .env

COPY . .

FROM node:20-alpine

WORKDIR /app

COPY --from=build /app .

EXPOSE 4000

CMD ["node","server.js"]