FROM node:14
COPY ./projeto-node /app
WORKDIR /app
RUN npm install
ENTRYPOINT [ "node server.js" ]