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

### Network:

Inspecionar informações de rede de um container
`docker inspect <container-id>`

Mostra detalhes do container, incluindo as redes às quais ele está conectado.

Listar redes existentes
`docker network ls`

Criar uma rede customizada
`docker network create --driver <bridge|host|none> minha-rede`


- bridge → rede isolada padrão do Docker, onde containers podem se comunicar entre si pelo nome do container (DNS interno).

- host → o container compartilha diretamente a rede do host (sem isolamento de portas).

- none → o container não possui rede; fica isolado.

Comunicação entre containers

Obs:

Para comunicar via nome do container (ping ubuntu2), é necessário usar uma rede customizada bridge.

Para comunicar via IP do container, a rede bridge padrão já permite.

Exemplo:

`docker run -it --name ubuntu1 --network minha-rede ubuntu bash`
`docker run -it --name ubuntu2 --network minha-rede ubuntu sleep 1d`

Dentro de ubuntu1:
`ping ubuntu2`

Funciona, pois estão na mesma rede e podem se resolver pelo DNS interno do Docker.

**Driver host**

No modo host, o container não possui stack de rede isolada:

Ele compartilha a mesma interface e IP do host.

Útil quando queremos máxima performance em rede ou evitar NAT.

As portas expostas do container ficam acessíveis diretamente no host sem precisar de -p.

Exemplo com app-node:latest (servidor HTTP na porta 3000):
`docker run --rm --network host app-node:latest`


O servidor ficará acessível em: `http://localhost:3000` (sem precisar mapear porta com -p).

**Driver none**

No modo none, o container não tem interface de rede configurada.

Ele fica isolado, sem acesso à rede externa ou a outros containers.

Útil para cenários de segurança ou containers que não precisam de rede.

Exemplo:

`docker run -it --network none app-node:latest`

Neste caso o container sobe, mas não terá conectividade de rede.
Só poderá ser acessado via docker exec (terminal interno).