## Домашнее задание к занятию "6.6. Troubleshooting"
1. Пользователь (разработчик) написал в канал поддержки, что у него уже 3 минуты происходит CRUD операция в MongoDB и её нужно прервать.
* напишите список операций, которые вы будете производить для остановки запроса пользователя  
    > 1. Определить `id` с помощью команды `db.currentOp({"active" : true, "secs_running" : { "$gt" : 180 }})` в mongo-shell активную операцию, которая выполняется более 3-х минут;
    > 2. С помощью команды `db.killOp(opid)` с передачей в качестве аргумента `id`, полученного на предыдущем шаге, прервать выполняемую операцию.
* предложите вариант решения проблемы с долгими (зависающими) запросами в MongoDB  
    С помощью команды .explain() проанализировать план выполнения запроса и провести его оптимизацию
2. Вы запустили инстанс Redis для использования совместно с сервисом, который использует механизм TTL. Причем отношение количества записанных key-value значений к количеству истёкших значений есть величина постоянная и увеличивается пропорционально количеству реплик сервиса. (**Redis блокирует операции записи**)
    > Время жизни большого количества ключей в БД истекает в одно и тоже время, следовательно на удаление этих ключей задача Redis'а будет тратить больше времени. Учитывая что Redis является однопоточным приложением, все операции ввода/вывода синхронизированы, как следствие операции записи ключей будут заблокированы на это время
3.  Вы подняли базу данных MySQL для использования в гис-системе. При росте количества записей, в таблицах базы, пользователи начали жаловаться на ошибки вида: Lost connection to MySQL server during query
    > Проблема связана с разрывом соединения, либо по причине сетевого сбоя, либо из-за превышения timeout'а получения результата выполненения операции от сервера ввиду слишком большого результирующего набора данных. Во втором случае можно увеличить значение параметра конфигурации `net_read_timeout` до достаточного уровня.
4. После запуска пользователи PostgreSQL начали жаловаться, что СУБД время от времени становится недоступной. В dmesg вы видите, что: `postmaster invoked oom-killer`
    > Проблема связана с нехваткой виртуальной памяти на хосте с PostgeSQL
    > * Увеличить объем оперативной памяти
    > * Согласно документации, при использовании большого объема `shared_buffers`, рекомендуется сконфигурировать PostgreSQL и ОС на использование "больших страниц" (huge_pages), что существенно снизить накладные расходы при использовании больших непрерывных блоков памяти.
    > * Провести анализ запросов и попытаться их оптимизировать, для уменьшения исползуемого объема разделяемого буфера.