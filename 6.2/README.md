### Домашнее задание к занятию "6.2. SQL"

1. Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.

    [docker-compose.yml](./01/docker-compose.yml)

    ```bash
    ~/devops/netology/6.2/01 $ docker ps
    CONTAINER ID   IMAGE         COMMAND                  CREATED         STATUS         PORTS                                       NAMES
    b564be8aba20   postgres:12   "docker-entrypoint.s…"   8 minutes ago   Up 8 minutes   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   pg
    ```

2. В БД из задачи 1:
* Cоздайте пользователя test-admin-user и БД test_db
    ```bash
    postgres=# create user "test-admin-user" with encrypted password 'test';
    CREATE ROLE    

    postgres=# create database test_db;
    CREATE DATABASE

    postgres=# \l
                                    List of databases
    Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
    -----------+----------+----------+------------+------------+-----------------------
    postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
    template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
            |          |          |            |            | postgres=CTc/postgres
    template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
            |          |          |            |            | postgres=CTc/postgres
    test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
    (4 rows)


    postgres=# \c test_db
    You are now connected to database "test_db" as user "postgres".
    ```
* В БД test_db создайте таблицу orders и clients 
    ```bash
    test_db=# create table orders(id serial primary key, name varchar, price integer);
    CREATE TABLE

    test_db=# \d orders
    id     | integer           |           | not null | nextval('orders_id_seq'::regclass)
    name   | character varying |           |          | 
    price  | integer           |           |          | 


    test_db=# create table clients(id serial primary key, lastname varchar, country varchar, order_id integer references orders(id));
    CREATE TABLE

    test_db=# \d clients
                                    Table "public.clients"
    Column  |       Type        | Collation | Nullable |               Default               
    ----------+-------------------+-----------+----------+-------------------------------------
    id       | integer           |           | not null | nextval('clients_id_seq'::regclass)
    lastname | character varying |           |          | 
    country  | character varying |           |          | 
    order_id | integer           |           |          | 
    Indexes:
        "clients_pkey" PRIMARY KEY, btree (id)
    Foreign-key constraints:
        "clients_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(id)
    ```
* Предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
    ```bash
    test_db=# grant ALL ON ALL tables in schema public to "test-admin-user";
    GRANT

    test_db=# select * from information_schema.role_table_grants where grantee = 'test-admin-user';
    grantor  |     grantee     | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy 
    ----------+-----------------+---------------+--------------+------------+----------------+--------------+----------------
    postgres | test-admin-user | test_db       | public       | orders     | INSERT         | NO           | NO
    postgres | test-admin-user | test_db       | public       | orders     | SELECT         | NO           | YES
    postgres | test-admin-user | test_db       | public       | orders     | UPDATE         | NO           | NO
    postgres | test-admin-user | test_db       | public       | orders     | DELETE         | NO           | NO
    postgres | test-admin-user | test_db       | public       | orders     | TRUNCATE       | NO           | NO
    postgres | test-admin-user | test_db       | public       | orders     | REFERENCES     | NO           | NO
    postgres | test-admin-user | test_db       | public       | orders     | TRIGGER        | NO           | NO
    postgres | test-admin-user | test_db       | public       | clients    | INSERT         | NO           | NO
    postgres | test-admin-user | test_db       | public       | clients    | SELECT         | NO           | YES
    postgres | test-admin-user | test_db       | public       | clients    | UPDATE         | NO           | NO
    postgres | test-admin-user | test_db       | public       | clients    | DELETE         | NO           | NO
    postgres | test-admin-user | test_db       | public       | clients    | TRUNCATE       | NO           | NO
    postgres | test-admin-user | test_db       | public       | clients    | REFERENCES     | NO           | NO
    postgres | test-admin-user | test_db       | public       | clients    | TRIGGER        | NO           | NO
    (14 rows)
    ```
* Создайте пользователя test-simple-user
    ```bash
    test_db=# create user "test-simple-user" with encrypted password 'test';
    CREATE ROLE
    ```
* Предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db
    ```bash
    test_db=# grant SELECT, INSERT, UPDATE, DELETE on all tables in schema public to "test-simple-user";
    GRANT

    test_db=# select * from information_schema.role_table_grants where grantee = 'test-simple-user';
    grantor  |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy 
    ----------+------------------+---------------+--------------+------------+----------------+--------------+----------------
    postgres | test-simple-user | test_db       | public       | orders     | INSERT         | NO           | NO
    postgres | test-simple-user | test_db       | public       | orders     | SELECT         | NO           | YES
    postgres | test-simple-user | test_db       | public       | orders     | UPDATE         | NO           | NO
    postgres | test-simple-user | test_db       | public       | orders     | DELETE         | NO           | NO
    postgres | test-simple-user | test_db       | public       | clients    | INSERT         | NO           | NO
    postgres | test-simple-user | test_db       | public       | clients    | SELECT         | NO           | YES
    postgres | test-simple-user | test_db       | public       | clients    | UPDATE         | NO           | NO
    postgres | test-simple-user | test_db       | public       | clients    | DELETE         | NO           | NO
    (8 rows)

    test_db=# \du
                                        List of roles
        Role name     |                         Attributes                         | Member of 
    ------------------+------------------------------------------------------------+-----------
    postgres         | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
    test-admin-user  |                                                            | {}
    test-simple-user |                                                            | {}
    ```
3. Используя SQL синтаксис - наполните таблицы тестовыми данными:
    ```bash
    test_db=# insert into orders(name, price) select name, price from (values('Шоколад', 10), ('Принтер', 3000), ('Книга', 500), ('Монитор', 7000), ('Гитара', 4000)) list(name, price);
    INSERT 0 5

    test_db=# select * from orders;
    id |  name   | price 
    ----+---------+-------
    5 | Шоколад |    10
    6 | Принтер |  3000
    7 | Книга   |   500
    8 | Монитор |  7000
    9 | Гитара  |  4000
    (5 rows)

    test_db=# insert into clients(lastname, country) select lastname, country from (values('Иванов Иван Иванович', 'USA'), ('Петров Петр Петрович', 'Canada'), ('Иоганн Себастьян Бах', 'Japan'), ('Ронни Джеймс Дио', 'Russia'), ('Ritchie Blackmore', 'Russia')) list(lastname, country);
    INSERT 0 5

    test_db=# select * from clients;
    id |       lastname       | country | order_id 
    ----+----------------------+---------+----------
    1 | Иванов Иван Иванович | USA     |         
    2 | Петров Петр Петрович | Canada  |         
    3 | Иоганн Себастьян Бах | Japan   |         
    4 | Ронни Джеймс Дио     | Russia  |         
    5 | Ritchie Blackmore    | Russia  |         
    (5 rows)

    test_db=# select 'orders' as table_name, count(*) as row_count from orders
    union all
    select 'clients' as table_name, count(*) as row_count from clients;
    table_name | row_count 
    ------------+-----------
    orders     |         5
    clients    |         5
    (2 rows)
    ```

4. Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.
    ```bash
    test_db=# update clients set order_id = 7 where id = 1;
    UPDATE 1
    test_db=# update clients set order_id = 8 where id = 2;
    UPDATE 1
    test_db=# update clients set order_id = 9 where id = 3;
    UPDATE 1

    test_db=# select c.id, c.lastname, c.country, o.name from clients c join orders o on c.order_id = o.id;
    id |       lastname       | country |  name   
    ----+----------------------+---------+---------
    1 | Иванов Иван Иванович | USA     | Книга
    2 | Петров Петр Петрович | Canada  | Монитор
    3 | Иоганн Себастьян Бах | Japan   | Гитара
    (3 rows)
    ```

5. Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 (используя директиву EXPLAIN).
    ```bash
    test_db=# explain select c.id, c.lastname, c.country, o.name from clients c join orders o on c.order_id = o.id;
                                QUERY PLAN                                
    -------------------------------------------------------------------------
    Hash Join  (cost=37.00..57.24 rows=810 width=100)
    Hash Cond: (c.order_id = o.id)
    ->  Seq Scan on clients c  (cost=0.00..18.10 rows=810 width=72)
    ->  Hash  (cost=22.00..22.00 rows=1200 width=36)
            ->  Seq Scan on orders o  (cost=0.00..22.00 rows=1200 width=36)
    (5 rows)

    ```

    > Оптимизатор запросов построил план выполнения, в котором будет использован метод хэш-соединения двух таблиц, где предварительно будет произведено последовательное сканирование (seq scan) кдючей таблицы `orders` с вычислением хешей ключа (o.id) и заполнением хэш-таблицы (ассоциативный массив), а затем последовательное сканирование `clients` с вычислением хешей ключа (c.order_id) и фильтрацией записей на основе поиска соответствующего хэша ключа в предварительно наполненной HashMap (по orders).

6. Backup
* Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1). 
    ```bash
    root@b564be8aba20:/# pg_dump -U postgres -Fc test_db > /var/lib/postgresql/backup/test_db.dump

    root@c2b3b87cb66e:/# pg_dumpall -g -U postgres > /var/lib/postgresql/backup/test_db_global.dump
    ```
* Остановите контейнер с PostgreSQL (но не удаляйте volumes).
    ```bash
    ~/devops/netology/6.2/01 $ docker compose stop
    [+] Running 1/1
    ⠿ Container pg  Stopped 
    ```
* Поднимите новый пустой контейнер с PostgreSQL.

    [docker-compose.yml](./06/docker-compose.yml)
    ```bash
    ~/devops/netology/6.2/06 $ docker ps
    CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS          PORTS                                       NAMES
    613aca812ed2   postgres:12   "docker-entrypoint.s…"   48 seconds ago   Up 46 seconds   0.0.0.0:5442->5432/tcp, :::5442->5432/tcp   pg2
    ```
* Восстановите БД test_db в новом контейнере.
    ```bash
    root@ef80d74bba5a:/# psql -U postgres
    psql (12.11 (Debian 12.11-1.pgdg110+1))
    Type "help" for help.

    postgres=# create database test_db;
    CREATE DATABASE
    
    postgres=# exit
    
    root@ef80d74bba5a:/# psql -U postgres test_db < /var/lib/postgresql/backup/test_db_global.dump 
    SET
    SET
    SET
    ERROR:  role "postgres" already exists
    ALTER ROLE
    CREATE ROLE
    ALTER ROLE
    CREATE ROLE
    ALTER ROLE
    
    root@ef80d74bba5a:/# pg_restore -U postgres -d test_db /var/lib/postgresql/backup/test_db.dump

    postgres=# \c test_db
    You are now connected to database "test_db" as user "postgres".
    
    test_db=# \d+
                                List of relations
    Schema |      Name      |   Type   |  Owner   |    Size    | Description 
    --------+----------------+----------+----------+------------+-------------
    public | clients        | table    | postgres | 16 kB      | 
    public | clients_id_seq | sequence | postgres | 8192 bytes | 
    public | orders         | table    | postgres | 16 kB      | 
    public | orders_id_seq  | sequence | postgres | 8192 bytes | 
    (4 rows)
    ```