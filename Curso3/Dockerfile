FROM node:18-slim

# copiar o conteudo da pasta projeto-node (onde esta o package.json e server.js) para a pasta /app dentro do container
COPY ./projeto-node /app
WORKDIR /app

# definir a variavel de ambiente PORT para 3000, que e utilizada no server.js
ENV PORT=3000


# a nivel de documentacao apenas, para informar que a aplicacao escuta na porta 3000 e pode ser mapeada nela
EXPOSE ${PORT}

RUN npm install


ENTRYPOINT [ "node", "server.js" ]
