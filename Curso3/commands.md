# 🚀 Workflow Docker

### Parar todos os containers:
docker stop $(docker ps -aq)

### Remover todos os containers:
docker rm $(docker ps -aq)

### Build da imagem:
docker build -t app-node:latest .

### Rodar o container:
docker run -d -p 8000:3000 --name app-node-container app-node:latest

-> -p 8000:3000 

### Resumo:

stop / rm → limpa containers antigos

build → cria imagem app-node:latest

run → sobe container na porta 8000 do host → 3000 do container