###node_exporter
1. Запуск Node Exporter в качестве сервиса 
* Создаем пользователя для запуска сервиса
```bash
sudo useradd -rs /bin/false node_exporter
```
* Создадим файл для указания параметров запуска сервиса **/etc/default/node_exporter** со следующим содержимым
```editorconfig
OPTIONS="--collector.mountstats --collector.interrupts"
```
* В файл параметров сервиса **/etc/systemd/system/node_exporter.service** помещаем слудующее
```editorconfig
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
EnvironmentFile=/etc/default/node_exporter
ExecStart=/usr/local/bin/node_exporter $OPTIONS
Restart=on-failure

[Install]
WantedBy=multi-user.target
```
* Активируем автозагрузку сервиса
```bash
sudo systemctl enable node_exporter
```
* Перезагружаем VM и проверяем запустился ли сервис автоматически
```bash
sudo systemctl status node_exporter
```
2. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.
>**node_cpu_seconds_total** - в частности отношение **idle** к занятому времени  
>**node_disk_read_bytes_total** - Общее кол-во считанных байтов  
>**node_disk_read_time_seconds_total** - Время в секундах, затраченное на операции чтения  
>**node_disk_written_bytes_total** Общее кол-во записанных байтов  
>**node_disk_write_time_seconds_total** - Время в секундах, затраченное на операции записи  
>**process_virtual_memory_bytes** - Размер виртуальной памяти  
>**process_virtual_memory_max_bytes** - Максимальное кол-во доступной виртуальной памяти  
3. Установите в свою виртуальную машину Netdata. 
>Netdata - установлен, порт 19999 проброшен, на хостовой машине web-интерфейс открывается
4. Можно ли по выводу dmesg понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?
```bash
dmesg | grep 'Hypervisor'
[    0.000000] Hypervisor detected: KVM
```
5. Как настроен sysctl fs.nr_open на системе по-умолчанию?
```bash
sysctl fs.nr_open
fs.nr_open = 1048576 # Максимальное количество открытых дескрипторов файловой системы в рамках процесса
```
6. Запустите любой долгоживущий процесс в отдельном неймспейсе процессов ... покажите, что ваш процесс работает под PID 1 через nsenter
```bash
unshare -f --pid --mount-proc sleep 1h
nsenter --target 1991 --pid --mount
ps -al
F S   UID     PID    PPID  C PRI  NI ADDR SZ WCHAN  TTY          TIME CMD
4 S     0       1       0  0  80   0 -  1369 hrtime pts/0    00:00:00 sleep
0 S     0      18       0  1  80   0 -  1809 do_wai pts/1    00:00:00 bash
0 R     0      29      18  0  80   0 -  2203 -      pts/1    00:00:00 ps
```
7. Найдите информацию о том, что такое :(){ :|:& };:
>Объявление рекурсивной функции с именем **:** которая параллельно запускает 2 своих экземпляра и так до бесконечности.  
> Полагаю, что стабилизация системы произошла в результате отказа "pids controller'а" fork'ать процессы, порожденные "нашим вызовом"
```bash
vagrant@vagrant:~$ dmesg | grep 'fork rejected'
[  235.353989] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-4.scope
```
