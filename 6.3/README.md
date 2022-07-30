### Домашнее задание к занятию "6.3. MySQL"

1. Восстановление из dump'а
* Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.
    > [docker-compose.yml](./docker-compose.yml)
* Изучите бэкап БД и восстановитесь из него.

    ```bash
    ~/devops/netology/6.3 $ docker exec -it mysql \
    mysql -uroot -proot -e "create database test_db; use test_db; source /usr/local/data/mysql/backup/test_dump.sql;"            
    mysql: [Warning] Using a password on the command line interface can be insecure.
    ```
* Найдите команду для выдачи статуса БД и приведите в ответе из ее вывода версию сервера БД.
    ```bash
    mysql> status
    --------------
    mysql  Ver 8.0.30 for Linux on x86_64 (MySQL Community Server - GPL)

    Connection id:		76
    Current database:	test_db
    Current user:		root@localhost
    SSL:			Not in use
    Current pager:		stdout
    Using outfile:		''
    Using delimiter:	;
    Server version:		8.0.30 MySQL Community Server - GPL
    Protocol version:	10
    Connection:		Localhost via UNIX socket
    Server characterset:	utf8mb4
    Db     characterset:	utf8mb4
    Client characterset:	latin1
    Conn.  characterset:	latin1
    UNIX socket:		/var/lib/mysql/mysql.sock
    Binary data as:		Hexadecimal
    Uptime:			26 min 42 sec

    Threads: 2  Questions: 220  Slow queries: 0  Opens: 204  Flush tables: 3  Open tables: 122  Queries per second avg: 0.137
    --------------
    ```
* Подключитесь к восстановленной БД и получите список таблиц из этой БД.
    ```bash
    mysql> show tables;
    +-------------------+
    | Tables_in_test_db |
    +-------------------+
    | orders            |
    +-------------------+
    1 row in set (0.01 sec)
    ```
* Приведите в ответе количество записей с price > 300.
    ```bash
    mysql> select count(*) from orders where price > 300;
    +----------+
    | count(*) |
    +----------+
    |        1 |
    +----------+
    1 row in set (0.00 sec)
    ```
2. Создание пользователя
* Создайте пользователя test в БД c паролем test-pass
    ```bash
    mysql> create user test 
        -> identified with mysql_native_password by 'test-pass' 
        -> with max_queries_per_hour 100 
        -> password expire interval 180 day 
        -> failed_login_attempts 3
        -> attribute '{"firstName": "James", "lastName": "Pretty"}';
    Query OK, 0 rows affected (0.01 sec)
    ```
* Предоставьте привелегии пользователю test на операции SELECT базы test_db
    ```bash
    mysql> grant select on test_db.* to test;
    Query OK, 0 rows affected (0.01 sec)
    ```
* Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю test и приведите в ответе к задаче.
    ```bash
    mysql> select * from information_schema.user_attributes where user = 'test';
    +------+------+----------------------------------------------+
    | USER | HOST | ATTRIBUTE                                    |
    +------+------+----------------------------------------------+
    | test | %    | {"lastName": "Pretty", "firstName": "James"} |
    +------+------+----------------------------------------------+
    1 row in set (0.01 sec)
    ```
3. Профилирование
* Исследуйте, какой engine используется в таблице БД test_db и приведите в ответе.
    > Engine таблицы `orders` - `InnoDB`
    ```bash
    mysql> show table status where name = 'orders'\G
    *************************** 1. row ***************************
            Name: orders
            Engine: InnoDB
            Version: 10
        Row_format: Dynamic
            Rows: 5
    Avg_row_length: 3276
        Data_length: 16384
    Max_data_length: 0
    Index_length: 0
        Data_free: 0
    Auto_increment: 6
        Create_time: 2022-07-30 15:15:39
        Update_time: 2022-07-30 15:15:39
        Check_time: NULL
        Collation: utf8mb4_0900_ai_ci
        Checksum: NULL
    Create_options: 
            Comment: 
    1 row in set (0.00 sec)
    ```
* Измените engine и приведите время выполнения и запрос на изменения из профайлера в ответе:
    * на MyISAM
        ```bash
        mysql> show profiles;
        +----------+------------+-----------------------------------------+
        | Query_ID | Duration   | Query                                   |
        +----------+------------+-----------------------------------------+
        |        1 | 0.00527250 | show table status where name = 'orders' |
        |        2 | 0.02615275 | alter table orders engine = MyISAM      |
        +----------+------------+-----------------------------------------+
        2 rows in set, 1 warning (0.00 sec)

        mysql> show profile for query 2;
        +--------------------------------+----------+
        | Status                         | Duration |
        +--------------------------------+----------+
        | starting                       | 0.000144 |
        | Executing hook on transaction  | 0.000017 |
        | starting                       | 0.000040 |
        | checking permissions           | 0.000039 |
        | checking permissions           | 0.000015 |
        | init                           | 0.000024 |
        | Opening tables                 | 0.000237 |
        | setup                          | 0.000105 |
        | creating table                 | 0.002928 |
        | waiting for handler commit     | 0.000026 |
        | waiting for handler commit     | 0.003961 |
        | After create                   | 0.000982 |
        | System lock                    | 0.000025 |
        | copy to tmp table              | 0.000219 |
        | waiting for handler commit     | 0.000019 |
        | waiting for handler commit     | 0.000016 |
        | waiting for handler commit     | 0.000065 |
        | rename result table            | 0.000059 |
        | waiting for handler commit     | 0.002173 |
        | waiting for handler commit     | 0.000026 |
        | waiting for handler commit     | 0.004015 |
        | waiting for handler commit     | 0.000036 |
        | waiting for handler commit     | 0.006357 |
        | waiting for handler commit     | 0.000036 |
        | waiting for handler commit     | 0.001388 |
        | end                            | 0.001495 |
        | query end                      | 0.001549 |
        | closing tables                 | 0.000027 |
        | waiting for handler commit     | 0.000048 |
        | freeing items                  | 0.000055 |
        | cleaning up                    | 0.000033 |
        +--------------------------------+----------+
        31 rows in set, 1 warning (0.00 sec)    
        ```
    * на InnoDB
        ```bash
        mysql> show profiles;
        +----------+------------+-----------------------------------------+
        | Query_ID | Duration   | Query                                   |
        +----------+------------+-----------------------------------------+
        |        1 | 0.00527250 | show table status where name = 'orders' |
        |        2 | 0.02615275 | alter table orders engine = MyISAM      |
        |        3 | 0.05531425 | alter table orders engine = InnoDB      |
        +----------+------------+-----------------------------------------+
        3 rows in set, 1 warning (0.00 sec)

        mysql> show profile for query 3;
        +--------------------------------+----------+
        | Status                         | Duration |
        +--------------------------------+----------+
        | starting                       | 0.000158 |
        | Executing hook on transaction  | 0.000024 |
        | starting                       | 0.000057 |
        | checking permissions           | 0.000022 |
        | checking permissions           | 0.000016 |
        | init                           | 0.000028 |
        | Opening tables                 | 0.000505 |
        | setup                          | 0.000178 |
        | creating table                 | 0.000233 |
        | After create                   | 0.024398 |
        | System lock                    | 0.000043 |
        | copy to tmp table              | 0.000266 |
        | rename result table            | 0.002556 |
        | waiting for handler commit     | 0.000033 |
        | waiting for handler commit     | 0.003680 |
        | waiting for handler commit     | 0.000035 |
        | waiting for handler commit     | 0.012785 |
        | waiting for handler commit     | 0.000036 |
        | waiting for handler commit     | 0.006254 |
        | waiting for handler commit     | 0.000031 |
        | waiting for handler commit     | 0.001251 |
        | end                            | 0.001269 |
        | query end                      | 0.001252 |
        | closing tables                 | 0.000029 |
        | waiting for handler commit     | 0.000073 |
        | freeing items                  | 0.000068 |
        | cleaning up                    | 0.000038 |
        +--------------------------------+----------+
        27 rows in set, 1 warning (0.00 sec)
        ```
4. Изменить my.cnf согласно ТЗ
    . [my.cnf](./my.cnf)