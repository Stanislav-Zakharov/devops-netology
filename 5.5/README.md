### Домашнее задание к занятию "5.5. Оркестрация кластером Docker контейнеров на примере Docker Swarm"

1. Дайте письменые ответы на следующие вопросы:
  * В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?
    > `replication` - режим с возможностью конфигурирования количества реплик  
    > `global` - режим в котором сервис будет принудительно развернут на всех нодах кластера docker-swarm (не более одного экземпляра на каждой ноде)
  * Какой алгоритм выбора лидера используется в Docker Swarm кластере?
    > Для обеспечения функционирования кластера docker-swarm используется алгоритм `RAFT`, который основан на принципах согластованности всех узлов (consensus-based). Согласованность, в общем случае достигается путем гарантированной доставки всех сигналов на все узлы с соблюдением их последовательности.  
    При потере `heartbeat` от лидера, узел отправляет другим узлам запрос на голосование и переходит в режим "кандидата". Каждый узел голосует за тот узел, от которого первым пришел запрос на голосование. В случае возобновления связи с лидером, кандидат снимает свою кандидатуру и переходит в обычный режим. Побеждает в голосовании тот узел, который соответственно получил наибольшее количество голосов.
  * Что такое Overlay Network?
    >В контексте docker-swarm, это виртуальная сеть, которая поднимается поверх существующих связей между хостами, являющимися узлами кластера docker-swarm.  
    Фактически это дает возможность всем контейнерам, присодениненным к одном сети (docker network) взаимодействовать между собой не зависимо от того, на каких хостах они развернуты и какое физическое устройство сети между этими хостами.

2. Создать ваш первый Docker Swarm кластер в Яндекс.Облаке
    ```bash
    [root@node01 ~]# docker node ls
    ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
    ajxlcktqqcfsepyc8lckt0hjf *   node01.netology.yc   Ready     Active         Leader           20.10.17
    q994bz154abavoxgln8mgtlct     node02.netology.yc   Ready     Active         Reachable        20.10.17
    onq19q9ml5a7rxwwkxl07en2r     node03.netology.yc   Ready     Active         Reachable        20.10.17
    0p62saf97tif6s6kocf1v3u2y     node04.netology.yc   Ready     Active                          20.10.17
    r50q1wrka65e7drayd8uipkc2     node05.netology.yc   Ready     Active                          20.10.17
    wdhr4jjoxcjul5ibl9r66pwsc     node06.netology.yc   Ready     Active                          20.10.17
    ```
3. Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.
    ```bash
    [root@node01 ~]# docker service ls
    ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
    ujco57xcqsp5   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0    
    yx0l11qv1v0y   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
    jessnqjgnqkc   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest                         
    qnfyt61zs1un   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest                      
    m7sy2wbdvcf6   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4           
    vx3mjgpa7kwc   swarm_monitoring_node-exporter      global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0   
    sh0h4i7d10y5   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0       
    3w6q3tpm59l7   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0    
    ```
4. Выполнить на лидере Docker Swarm кластера команду (указанную ниже) и дать письменное описание её функционала, что она делает и зачем она нужна:
    ```bash
    [root@node01 ~]# docker swarm update --autolock=true
    Swarm updated.
    To unlock a swarm manager after it restarts, run the `docker swarm unlock`
    command and provide the following key:

        SWMKEY-1-AYTBo4CStrZiwIv6z5tCRBk50VkOELHMCQrffzZQOSg

    Please remember to store this key in a password manager, since without it you
    will not be able to restart the manager.    
    ```
    > Swarm использует алгоритм Raft, где, как мы уже говорили ранее, для достижения согласованности менеджеров используется гарантированная доставка всех сигналов от лидера ко всем узлам. Сигналы журналируются на узлах (Raft logs) для возможности восстановления состояния при перезапуске и перехвата инициативы стать лидером. В вышеуказанном журнале, в том числе хранятся и конфедециальные данные (credentials, certificates etc.), которые распространяются в контейнеры, развернутые в Swarm через механизм [Docker secrets](https://docs.docker.com/engine/swarm/secrets/). В целях безопасности, журналы (Raft logs) зашифрованы, с помощью ассиметричной пары ключей, которая также используется для установки TLS соединения между менеджерами кластера. Вышеуказанная пара ключей хранится в файловой системе менеджеров и может быть скомпрометирована. Комманда `docker swarm update --autolock=true` шифрует эти ключи симметричным ключем, который нигде на сохраняется. Таким образом мы блокируем работу Swarm при перезапуске, где для разблокировки (расшифровки и получения доступа к Raft logs encryptions keys) необходимо ввести симметричный ключ, полученный в результате блокирования.