# 🚀 Workflow Docker

### Parar todos os containers:
`docker stop $(docker ps -aq)`

### Remover todos os containers:
`docker rm $(docker ps -aq)`

### Remover todas as imagens:
`docker rmi $(docker image ls -aq) --force`

### Build da imagem:
`docker build -t app-node:latest .`

### Rodar o container:
`docker run -d -p 8000:3000 --name app-node-container app-node:latest`

-> `-p 8000:3000` porta de entrada 8000 refletira na porta 3000 do container

### Login DockerHub
`docker login -u nicolasmp8`


### Subir imagem no DockerHub
`docker push app-node:latest`

OBS: 
- é necessario seguir o padrao de tag imagem: ```<nome-user>/<nome-imagem>:<versao>```
se nao seguir este padrao, é gerado um erro de access denied no repositorio (```<nome-user>```)

- para alterar a tag da imagem usamos (copia a imagem com nova tag): ```docker tag <nome-antigo-imagem> <nome-novo-imagem>``` -> ```docker tag app-node:latest nicolasmp8/app-node:latest```

### Volumes:
- docker run -it -v "~/Documents/dados":/app ubuntu bash --> tudo que for criado em /app dentro do container sera mapeado no host em /dados no host
- docker run -it --mount type=bind,source="~/Documents/dados",target=/app ubuntu bash --> mesmo resultado que o comando acima, porem utilizando bind mounts

Criar volume:
- `docker volume create meu-volume`
- `docker volume ls`

- `docker run -it -v meu-volume:/app ubuntu bash` --> utilizando o volume criado

Os dados dos volumes criados ficam em `/var/lib/docker/volumes/<nome-volume>`

É uma boa pratica utilizar o volume do docker, pois da mais opcoes para gerenciamento destes volumes

Além de volumes, existe a opção de montar um sistema de arquivos em memoria RAM, usando tmpfs.

- `docker run -it --tmpfs /app ubuntu bash`

Os dados ficam apenas na memória RAM, não no disco.

Util quando precisa de desempenho na Leitura/Escrita ou armazenamento temporário dos dados.

Volume → Persistente, armazenado em disco, sobrevive à parada e recriação de containers.
tmpfs → Temporário, armazenado em RAM, desaparece quando o container é parado.