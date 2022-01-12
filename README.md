5. Выделенные ресурсы по-умолчанию:
   CPU: 2
   RAM: 1Gb
   Image volume size: 64Gb

6. Как добавить оперативной памяти или ресурсов процессора виртуальной машине?

   Vagrant.configure("2") do |config|
     config.vm.box = "bento/ubuntu-20.04"

     config.vm.provider "virtualbox" do |vb|
       vb.cpus = 4
       vb.memory = 2048
     end
   end

8. 
  1) HISTFILESIZE - line 690
  2) ignoreboth - объединяет действия ignorespace и ignoredups параметра HISTCONTROL, который управляет поведением сохранения команд в журнале истории

9. В каких сценариях использования применимы скобки {}
   1) Compound Commands { list; } - line 221
   2) Shell Function Definitions - line 337
   3) Brace Expansion - line 886
   4) Подстановка переменных ${parameter} - line 948 

10.
  1) touch {000001..100000}
  2) Вышеуказанным способом 300000 файлов создать не получится, так как превышена допустимая длина аргументов 2097152 (getconf ARG_MAX)

     for num in {000001..300000}; do touch ${num}; done
     Медленно, неэффективно, но результат достигнут:)

11. Что делает конструкция [[ -d /tmp ]]
    Конструкция возвращает результат выражения (man line 230).
    В нашем случае производится оценка наличия директории /tmp

12. 
    mkdir /tmp/new_path_directory -p
    ln -s /bin/bash /tmp/new_path_directory/bash
    sudo ln -s /bin/bash /usr/local/bin/bash
    export PATH=/tmp/new_path_directory:$PATH
    type -a bash

    bash is /tmp/new_path_directory/bash
    bash is /usr/local/bin/bash
    bash is /usr/bin/bash
    bash is /bin/bash

13. Чем отличается планирование команд с помощью batch и at
    batch - планирует выполнение команды, которая будет запущена основываясь на загрузке системы
    at    - соответственно, в указанный период
