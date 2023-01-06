# Домашнее задание к занятию "1. Введение в Ansible"
## Основная часть
1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.
    > `some_fact` имеет значение `12`
2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.
    ```bash
    ok: [localhost] => {
        "msg": "all default fact"
    }
    ```
3. Воспользуйтесь подготовленным (используется docker) или создайте собственное окружение для проведения дальнейших испытаний.
    ```bash
    $ docker run -dit --name centos7 pycontribs/centos:7
    e607412cf3fdd6a52ee168a704b27b11eec5144cd07ffad96e7a3a8b63823164

    $ docker run -dit --name ubuntu pycontribs/ubuntu
    bd59da76eabcf402badcf1a6ddc261d48fcb49a470434a5e01820f4d5b3b7926

    $ docker ps
    CONTAINER ID   IMAGE               COMMAND       CREATED              STATUS              PORTS     NAMES
    bd59da76eabc   pycontribs/ubuntu   "/bin/bash"   About a minute ago   Up About a minute             ubuntu
    9e6f6d06d05a   pycontribs/ubuntu   "/bin/bash"   2 minutes ago        Up 2 minutes                  centos7
    ```
4. Проведите запуск playbook на окружении из prod.yml. Зафиксируйте полученные значения some_fact для каждого из managed host.
    ```bash
    ok: [centos7] => {
        "msg": "el"
    }
    ok: [ubuntu] => {
        "msg": "deb"
    }
    ```
5. Добавьте факты в group_vars каждой из групп хостов так, чтобы для some_fact получились следующие значения: для deb - 'deb default fact', для el - 'el default fact'.
    * [deb vars file link](./playbook/group_vars/deb/examp.yml)
    * [el vars file link](./playbook/group_vars/el/examp.yml)
6. Повторите запуск playbook на окружении prod.yml. Убедитесь, что выдаются корректные значения для всех хостов.
    ```bash
    ok: [centos7] => {
        "msg": "el default fact"
    }
    ok: [ubuntu] => {
        "msg": "deb default fact"
    }
    ```
7. При помощи ansible-vault зашифруйте факты в group_vars/deb и group_vars/el с паролем netology.
    ```bash
    $ ansible-vault encrypt deb/*.yml el/*.yml
    New Vault password: 
    Confirm New Vault password: 
    Encryption successful

    $ cat deb/* el/* 
    $ANSIBLE_VAULT;1.1;AES256
    32626631396366633964616565653630383037326562636532383966323638653435343261626231
    3838636331653734623539653338313061393839386432320a633563353437643238333464613639
    61653761626531643333393761323537346430386434636666356337353832666435646363383166
    3636346134636235310a653637653138623136396133663135613632343039313166323731363431
    65303034356638313237643539386261633234646535646637363762623333363633623762396266
    3562363832643136613230636639623161346537663933303961
    $ANSIBLE_VAULT;1.1;AES256
    61663362346664386635386465363366613232383231316334316133383533366661393864643862
    3239356636313633303564313831613165626138666431300a626162343934383762656563386461
    35333139656465343839663935376235346134656165376339336539633939336564363062356135
    6665646163306364370a363364616135366434353430616632613264663466313462343062376136
    37333566383161363232383863333266316130343438636434323666363638326233393538336436
    3631643931366663303732333235656636303766376437383735
    ```
8. Запустите playbook на окружении prod.yml. При запуске ansible должен запросить у вас пароль. Убедитесь в работоспособности.
    ```bash
    ansible-playbook --ask-vault-password -i inventory/prod.yml site.yml
    Vault password: 

    PLAY [Print os facts] ************************************************************************************************

    TASK [Gathering Facts] ************************************************************************************************
    ok: [ubuntu]
    ok: [centos7]

    TASK [Print OS] ************************************************************************************************
    ok: [ubuntu] => {
        "msg": "Ubuntu"
    }
    ok: [centos7] => {
        "msg": "CentOS"
    }

    TASK [Print fact] ************************************************************************************************
    ok: [centos7] => {
        "msg": "el default fact"
    }
    ok: [ubuntu] => {
        "msg": "deb default fact"
    }

    PLAY RECAP ************************************************************************************************
    centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
    ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
    ```
9. Посмотрите при помощи ansible-doc список плагинов для подключения. Выберите подходящий для работы на control node.
    ```bash
    $ ansible-doc -l -t connection | grep 'control'
    local                          execute on controller 
    ```
10. В prod.yml добавьте новую группу хостов с именем local, в ней разместите localhost с необходимым типом подключения.
    * [prod.yml](./playbook/inventory/prod.yml)
11. Запустите playbook на окружении prod.yml. При запуске ansible должен запросить у вас пароль. Убедитесь что факты some_fact для каждого из хостов определены из верных group_vars.
    ```bash
    ok: [localhost] => {
        "msg": "all default fact"
    }
    ok: [centos7] => {
        "msg": "el default fact"
    }
    ok: [ubuntu] => {
        "msg": "deb default fact"
    }
    ```
## Необязательная часть
1. При помощи ansible-vault расшифруйте все зашифрованные файлы с переменными.
    ```bash
    ansible-vault decrypt deb/*.yml el/*.yml
    Vault password: 
    Decryption successful
    
    $ cat deb/* el/*
    ---
    some_fact: "deb default fact"---
    some_fact: "el default fact"%
    ```
2. Зашифруйте отдельное значение PaSSw0rd для переменной some_fact паролем netology. Добавьте полученное значение в group_vars/all/exmp.yml.
    ```bash
    $ ansible-vault encrypt_string PaSSw0rd
    New Vault password: 
    Confirm New Vault password: 
    !vault |
            $ANSIBLE_VAULT;1.1;AES256
            63366261326438323836333364373064366262663661376630346134333363393363373663386231
            3032643565633763336436373538303963396465333931380a326466326438396536353135396337
            35623164313835653762303933646164333038653332653762336332373465333365316565613532
            6164363635346532660a306162386537333739663832353862373266336566353066653036376330
            3632
    Encryption successful
    ```
3. Запустите playbook, убедитесь, что для нужных хостов применился новый fact.
    ```bash
    ok: [localhost] => {
        "msg": "PaSSw0rd"
    }
    ok: [centos7] => {
        "msg": "el default fact"
    }
    ok: [ubuntu] => {
        "msg": "deb default fact"
    }
    ```
4. Добавьте новую группу хостов fedora, самостоятельно придумайте для неё переменную.
    * [fedora_vars](./playbook/group_vars/fedora/examp.yml)
5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.
```bash
$ export VAULT_PASSWORD=netology && ./execute.sh
d0213e203e864b034f304374e1eeeef5f4c28306c8ded346275fd39eca12a9dd
9c6721240c1b0092bd4eb5f78f3a4e0d20f4931e620a9d03642940902b8f97df
8fb0a1d09c11ec74f3add047d7730d7f349f62ae77c41c3c44f4b060cbd32c18

PLAY [Print os facts] ********************************************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************************************
ok: [localhost]
ok: [fedora]
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host ubuntu should use /usr/bin/python3, but is using /usr/bin/python for backward compatibility with prior Ansible 
releases. A future Ansible release will default to using the discovered platform python for this host. See 
https://docs.ansible.com/ansible/2.10/reference_appendices/interpreter_discovery.html for more information. This feature will be removed in version 2.12. Deprecation 
warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] **************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [fedora] => {
    "msg": "Fedora"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "PaSSw0rd"
}
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [fedora] => {
    "msg": "fedora default fact"
}

PLAY RECAP *******************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
fedora                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```