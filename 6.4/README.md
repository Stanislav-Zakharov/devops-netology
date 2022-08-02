### Домашнее задание к занятию "6.4. PostgreSQL"
1. Развертывание экземпляра PostgreSQL 
* Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.
    > [docker-compose.yml](./docker-compose.yml)

* Найдите и приведите управляющие команды для:
    * вывода списка БД
        > `\l`
    * подключения к БД
        > `\c`
    * вывода списка таблиц
        > `\dt`
    * вывода описания содержимого таблиц
        > `\d table_name`
    * выхода из psql
        > `\q`
2. Восстановление из dump'а
* Восстановите бэкап БД в test_database
    ```bash
    ~/devops/netology/6.4 $ docker exec -it pg bash -c 'psql -U postgres -c "create database test_database"; psql -U postgres -d test_database < /var/lib/postgresql/backup/test_dump.sql'
    CREATE DATABASE
    SET
    SET
    SET
    SET
    SET
    set_config 
    ------------
    
    (1 row)

    SET
    SET
    SET
    SET
    SET
    SET
    CREATE TABLE
    ALTER TABLE
    CREATE SEQUENCE
    ALTER TABLE
    ALTER SEQUENCE
    ALTER TABLE
    COPY 8
    setval 
    --------
        8
    (1 row)

    ALTER TABLE
    ```
* Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.
    ```bash
    test_database=# analyze verbose orders;
    INFO:  analyzing "public.orders"
    INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
    ANALYZE
    ```
* Используя таблицу pg_stats, найдите столбец таблицы orders с наибольшим средним значением размера элементов в байтах.
    ```bash
    test_database=# select attname, avg_width from pg_stats where tablename = 'orders' order by avg_width desc limit 1;
    attname | avg_width 
    ---------+-----------
    title   |        16
    (1 row)
    ```
3. Шардировать таблицу
    > При решении задачи исходим из текущих вводных, а именно - отсутствие внешних ключей из других таблиц, что дает нам возможность достаточно просто пересоздать текущую таблицу и использовать `декларативный` подход к секционированию. В противном случае, опять же в зависимости от ситуации возможно пришлось бы прибегнуть к секционированию через наследование.  
    >
    > Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders? - При проектировании схемы БД всегда можно исключить последующие "танцы с бубном", если проектирование сопровождается анализом бизнес-процессов.

    ```bash
    test_database=# alter table orders drop constraint orders_pkey;
    ALTER TABLE

    test_database=# alter table orders add primary key(id, price);
    ALTER TABLE

    test_database=# create table test (like orders including all) partition by range(price);
    CREATE TABLE

    postgres=# alter sequence orders_id_seq OWNED BY test.id;
    ALTER SEQUENCE

    test_database=# create table orders_1 partition of test for values from (500) to (maxvalue);
    CREATE TABLE

    test_database=# create table orders_2 partition of test for values from (minvalue) to (500);
    CREATE TABLE

    test_database=# insert into test (select * from orders);
    INSERT 0 8

    test_database=# drop table orders;
    DROP TABLE

    test_database=# alter table test rename to orders;
    ALTER TABLE

    postgres=# insert into orders(title, price) values ('New partitioned row', 999);
    INSERT 0 1

    postgres=# select * from orders;
    id |        title         | price 
    ----+----------------------+-------
    1 | War and peace        |   100
    3 | Adventure psql time  |   300
    4 | Server gravity falls |   300
    5 | Log gossips          |   123
    7 | Me and my bash-pet   |   499
    2 | My little database   |   500
    6 | WAL never lies       |   900
    8 | Dbiezdmin            |   501
    9 | New partitioned row  |   999
    (9 rows)

    postgres=# select * from orders_1;
    id |        title        | price 
    ----+---------------------+-------
    2 | My little database  |   500
    6 | WAL never lies      |   900
    8 | Dbiezdmin           |   501
    9 | New partitioned row |   999
    (4 rows)

    postgres=# select * from orders_2;
    id |        title         | price 
    ----+----------------------+-------
    1 | War and peace        |   100
    3 | Adventure psql time  |   300
    4 | Server gravity falls |   300
    5 | Log gossips          |   123
    7 | Me and my bash-pet   |   499
    (5 rows)

    ```
4. Модификация dump'а
* Используя утилиту pg_dump создайте бекап БД test_database.
    ```bash
    ~/devops/netology/6.4 $ docker exec -it pg bash -c 'pg_dump -U postgres -d test_database > /var/lib/postgresql/backup/dump2.sql';
    ```
* Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца title для таблиц test_database?
    > [dump2_modified.sql (rows:164 - 174)](./backup/dump2_modified.sql)
