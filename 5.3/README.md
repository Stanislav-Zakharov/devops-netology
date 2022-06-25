### Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"
1. Реализуйте функциональность: запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код...


> Базовый образ Nginx содержит конфигурацию с http-прослушивателем на 80 порту
> и стартовой страницей index.html в директории `/usr/share/nginx/html`  
> Соответственно, для достижения цели нам необходимо скопировать соответствующий 
> файл в вышеуказанную директорию (можно было примонтировать volume, но не будем 
> усложнять, так как страница статичная и задание простое)  
> - Source project [link](https://github.com/Stanislav-Zakharov/devops-netology/tree/main/5.3/01)
> - Docker-image link [svzaharov/static-http-server:1.0.0](https://hub.docker.com/layers/240777542/svzaharov/static-http-server/1.0.0/images/sha256-79391402591e6d058f838f5737ef068a95b7cc3e9ffd4ec594675626e7414951?context=repo) 

```bash
$ docker run --name static-http -p 8080:80 -d svzaharov/static-http-server:1.0.0          ✔  23:18:36 
Unable to find image 'svzaharov/static-http-server:1.0.0' locally
1.0.0: Pulling from svzaharov/static-http-server
2408cc74d12b: Pull complete
dd61fcc63eac: Pull complete
f9686e628075: Pull complete
ceb5504faee7: Pull complete
ce5d272a5b4f: Pull complete
136e07b65aca: Pull complete
7447df38acd3: Pull complete
Digest: sha256:79391402591e6d058f838f5737ef068a95b7cc3e9ffd4ec594675626e7414951
Status: Downloaded newer image for svzaharov/static-http-server:1.0.0
51e7566498cef708fe689a6ed0cca64eb6bbe19e708838173f077488ed1e3c2b

$ docker logs static-http                                                         ✔  40s   23:20:22 
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2022/06/23 20:20:22 [notice] 1#1: using the "epoll" event method
2022/06/23 20:20:22 [notice] 1#1: nginx/1.23.0
2022/06/23 20:20:22 [notice] 1#1: built by gcc 11.2.1 20220219 (Alpine 11.2.1_git20220219)
2022/06/23 20:20:22 [notice] 1#1: OS: Linux 5.10.102.1-microsoft-standard-WSL2
2022/06/23 20:20:22 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
2022/06/23 20:20:22 [notice] 1#1: start worker processes
2022/06/23 20:20:22 [notice] 1#1: start worker process 32
2022/06/23 20:20:22 [notice] 1#1: start worker process 33
2022/06/23 20:20:22 [notice] 1#1: start worker process 34
2022/06/23 20:20:22 [notice] 1#1: start worker process 35
2022/06/23 20:20:22 [notice] 1#1: start worker process 36
2022/06/23 20:20:22 [notice] 1#1: start worker process 37
2022/06/23 20:20:22 [notice] 1#1: start worker process 38
2022/06/23 20:20:22 [notice] 1#1: start worker process 39

$ curl http://localhost:8080                                                              ✔  23:20:40 
<html>
  <head>
    Hey, Netology
  </head>
  <body>
    <h1>I’m DevOps Engineer!</h1>
  </body>
</html>%
```
2. Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина?
> > - *Высоконагруженное монолитное java веб-приложение;*  
> > Если речь идет о "Серверах приложений", то однозначно виртуальная машина.  
> > Использование Docker будет бессмысленным, так как развертывание сервлетов происходит
> > без перезапуска сервера приложений, а сам сервер должен быть сконфигурирован по принципу
> > "настроил и забыл". Плюс издержки транспортного слоя...
>
> > - *Nodejs веб-приложение;*
> > Только Docker.  
> > Идемпотентность в проектах Node.js - вещь очень критичная, важно соблюдать "правильные" 
> > и всегда одинаковые комбинации версий npm и зависимостей на всех средах, в противном
> > случае побочных эффектов не избежать
>
> > - *Мобильное приложение c версиями для Android и iOS;*  
> > Тут не совсем понятна связь со средой виртуализации/контейнеризации  
> > Если речь идет об автоматизации CI/CD, в частности сборки артефактов и их доставки
> > то конечно Docker
>
> > - *Шина данных на базе Apache Kafka;*  
> > Есть большой опыт работы с данным брокерм сообщений как у разработчика.  
> > В инфраструктуре используется и как в Docker-контейнерах и в кластере на VM.
> > в зависимости от круга задач.
>
> > - *Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;*  
> > Не вижу проблем развернуть данную инфраструктуру в Docker
>
> > - *Мониторинг-стек на базе Prometheus и Grafana;*  
> > На мой взгляд, прекрасно вписывается в развертывание в Docker-контейнерах, во всех случаях так и поступаем
>
> > - *MongoDB, как основное хранилище данных для java-приложения;*  
> > На текущем этапе не вижу выгоды развертывать СУБД в контейнерах, все будет так или иначе примонтировано в хостовую систему, 
> > а сетевой слой накладывать издержки. Кроме того требуется обслуживание, резервное копирование
> > по специальным сценариям и т.д.
>
> > - *Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.*  
> > На официальном ресурсе Gitlab имеются руководства по развертыванию как в Docker-контейнере, так и 
> > без контейнеризации. Я бы попробовал развернуть в Docker.
3. Смонтировать общий volume для двух контейнеров
```bash
$ docker run --name centos -v /mnt/d/#devops/devops-netology/5.3/03/data:/data -it -d centos:7
Unable to find image 'centos:7' locally
7: Pulling from library/centos
2d473b07cdd5: Pull complete
Digest: sha256:c73f515d06b0fa07bb18d8202035e739a494ce760aa73129f60f4bf2bd22b407
Status: Downloaded newer image for centos:7
0e5344a50b97af1d3f40a9c6fae1c205fed08483d127829f89a39543e8968673

$ docker run --name debian -v /mnt/d/#devops/devops-netology/5.3/03/data:/data -it -d debian:11.3-slim
Unable to find image 'debian:11.3-slim' locally
11.3-slim: Pulling from library/debian
b85a868b505f: Pull complete
Digest: sha256:f6957458017ec31c4e325a76f39d6323c4c21b0e31572efa006baa927a160891
Status: Downloaded newer image for debian:11.3-slim
8d9ff7c85cac1d4a159ea52fd8543ce95a19831aaa9ab4d95921b88d43198ce8

$ docker ps
CONTAINER ID   IMAGE                                COMMAND                  CREATED          STATUS          PORTS                  NAMES
8d9ff7c85cac   debian:11.3-slim                     "bash"                   41 seconds ago   Up 39 seconds                          debian
0e5344a50b97   centos:7                             "/bin/bash"              3 minutes ago    Up 3 minutes                           centos

$ docker exec -it centos bash
[root@0e5344a50b97 /]# echo 'centos internal created data' > /data/centos.txt
[root@0e5344a50b97 /]# exit
exit

$ echo 'host created data' > /mnt/d/#devops/devops-netology/5.3/03/data/host.txt

$ docker exec -it debian bash
root@8d9ff7c85cac:/# ls /data -al
total 4
drwxrwxrwx 1 1000 1000 4096 Jun 25 21:04 .
drwxr-xr-x 1 root root 4096 Jun 25 20:59 ..
-rwxrwxrwx 1 1000 1000   29 Jun 25 21:03 centos.txt
-rwxrwxrwx 1 1000 1000   18 Jun 25 21:04 host.txt
root@8d9ff7c85cac:/# cat /data/centos.txt
centos internal created data
root@8d9ff7c85cac:/# cat /data/host.txt
host created data
```
4. Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.
> - Docker-image link [svzaharov/ansible:2.9.24](https://hub.docker.com/layers/242039718/svzaharov/ansible/2.9.24/images/sha256-d6fc1cfc97f50306802791995b25efd0894b40d7db3c8203ead2fc81393fbbde?context=repo)
```bash
$ docker run --rm svzaharov/ansible:2.9.24
ansible-playbook [core 2.13.1]
  config file = None
  configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3.9/site-packages/ansible
  ansible collection location = /root/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible-playbook
  python version = 3.9.5 (default, Nov 24 2021, 21:19:13) [GCC 10.3.1 20210424]
  jinja version = 3.1.2
  libyaml = False
```
