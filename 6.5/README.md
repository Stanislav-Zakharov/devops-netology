### Домашнее задание к занятию "6.5. Elasticsearch"
1. Развертывание Elasticsearch  
    * [Dockerfile](./Dockerfile)
    * [DockerHub image link](https://hub.docker.com/layers/svzaharov/elasticsearch/8.4.3/images/sha256-552791c92f01421c98bb3842ed17b13ecdee6e48857843d33f1d4e5a3dca2f45?context=repo)
    * ответ elasticsearch на запрос пути / в json виде:
        ```json
        {
        "name" : "netology_test",
        "cluster_name" : "elasticsearch",
        "cluster_uuid" : "kv-gzRC3Qq6dujk2-EV2hA",
        "version" : {
            "number" : "8.4.3",
            "build_flavor" : "default",
            "build_type" : "tar",
            "build_hash" : "42f05b9372a9a4a470db3b52817899b99a76ee73",
            "build_date" : "2022-10-04T07:17:24.662462378Z",
            "build_snapshot" : false,
            "lucene_version" : "9.3.0",
            "minimum_wire_compatibility_version" : "7.17.0",
            "minimum_index_compatibility_version" : "7.0.0"
        },
        "tagline" : "You Know, for Search"
        }        
        ```
2. Создание индексов
 * Получите список индексов и их статусов, используя API и приведите в ответе на задание.  
    ```bash
    $ curl -X GET "localhost:9200/_cat/indices?v=true&s=index&pretty" 
    ealth status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    green  open   ind-1 FBuuMCPGTEyd9dWrYsGaJg   1   0          0            0       225b           225b
    yellow open   ind-2 rW1dHI3nQUuHICrXGazfNw   2   1          0            0       450b           450b
    yellow open   ind-3 -92WOEaOSYGz4XuAY0LHZQ   4   2          0            0       900b           900b
    ```
* Получите состояние кластера elasticsearch, используя API.
    ```bash
    $ curl -X GET "localhost:9200/_cluster/health/?pretty"
    {
    "cluster_name" : "elasticsearch",
    "status" : "yellow",
    "timed_out" : false,
    "number_of_nodes" : 1,
    "number_of_data_nodes" : 1,
    "active_primary_shards" : 8,
    "active_shards" : 8,
    "relocating_shards" : 0,
    "initializing_shards" : 0,
    "unassigned_shards" : 10,
    "delayed_unassigned_shards" : 0,
    "number_of_pending_tasks" : 0,
    "number_of_in_flight_fetch" : 0,
    "task_max_waiting_in_queue_millis" : 0,
    "active_shards_percent_as_number" : 44.44444444444444
    }
    ```
* Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?
    > Часть индексов и кластер в состоянии `yellow` так как в кластере присутствуют неназначенные шарды, т.е. из-за отсутствия нод, кроме нашей, реплики шардов некуда размещать.
* Удалите все индексы.
    ```bash
    $ curl -X DELETE "localhost:9200/ind-1,ind-2,ind-3?pretty" 
    {
    "acknowledged" : true
    }
    ```
3. Backup and restore
* Используя API зарегистрируйте данную директорию как snapshot repository c именем netology_backup.
    ```bash
    $ curl -X PUT "localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d' 
    {
    "type": "fs",
    "settings": {
        "location": "/elasticsearch/snapshots"
    }
    }
    '

    {
    "acknowledged" : true
    }
    ```
* Создайте индекс test с 0 реплик и 1 шардом и приведите в ответе список индексов.
    ```bash
    $ curl -X PUT "localhost:9200/test?pretty" -H 'Content-Type: application/json' -d'
    {
    "settings": {
        "index": {
        "number_of_shards": 1,  
        "number_of_replicas": 0 
        }
    }
    }
    '

    {
    "acknowledged" : true,
    "shards_acknowledged" : true,
    "index" : "test"
    }

    $ curl -X GET "localhost:9200/_cat/indices?v=true&s=index&pretty"

    health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    green  open   test  an-24meqRvGPtX03X2knKQ   1   0          0            0       225b           225b
    ```
* Создайте snapshot состояния кластера elasticsearch
    ```bash
   $ curl -X PUT "localhost:9200/_snapshot/netology_backup/%3Cnetology_backup_%7Bnow%2Fd%7D%3E?pretty"

    {
    "accepted" : true
    }
    ```
* Приведите в ответе список файлов в директории со snapshotами
    ```bash
    $ docker exec -it elastic bash -c "ls -a /elasticsearch/snapshots" 
    .  ..  index-0	index.latest  indices  meta-9G3MFJEVSteNkRvR9EUA1Q.dat	snap-9G3MFJEVSteNkRvR9EUA1Q.dat
    ```
* Удалите индекс test и создайте индекс test-2. Приведите в ответе список индексов.
    ```bash
    $ curl -X GET "localhost:9200/_cat/indices?v=true&s=index&pretty" 

    health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    green  open   test-2 0lSgJZnjSoKY5qGX5SDp5A   1   0          0            0       225b           225b
    ```
* Восстановите состояние кластера elasticsearch из snapshot, созданного ранее.
    ```bash
    $ curl -X POST "localhost:9200/_snapshot/netology_backup/netology_backup_2022.11.05/_restore?pretty"

    {
    "accepted" : true
    }

    $ curl -X GET "localhost:9200/_cat/indices?v=true&s=index&pretty" 

    health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    green  open   test   b6hDCPIpRcCS7QAKJTxGXQ   1   0          0            0       225b           225b
    green  open   test-2 0lSgJZnjSoKY5qGX5SDp5A   1   0          0            0       225b           225b
    ```
