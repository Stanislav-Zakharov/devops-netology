## Домашнее задание к занятию "2. Работа с Playbook"
* Подготовьте хосты в соответствии с группами из предподготовленного playbook.
    * Инфраструктура подготовлена при помощи `vagrant + virtualbox`, [конфигурация инфраструктуры](./infra/)
* Приготовьте свой собственный inventory файл [prod.yml](./playbook/inventory/prod.yml)

* Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает vector.
    * [site.yml](./playbook/site.yml)
    * В playbook был добавлен еще один play, в котором описаны два задания для установки `Vector`:
        * Задача на скачивание пакета `Vector` с внешнего ресурса в текущую папку пользователя. Используется модуль `ansible.builtin.get_url`
        * Задача на установку ранее загруженного пакета `Vector`. 
            - Испоьзуется модуль `ansible.builtin.get_url`. 
            - В качестве параметров используются:
                - `become` - атрибут задачи на разрешение смены пользователя (для эскалации привилегий)
                - `disable_gpg_check` - для отключения проверки GPG подписи пакета. Playbook в моем случае воспроизводится на CentOS 8, где проверка не проходит.
                - `name` - массив загруженных файлов пакетов для установки

* Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
    ```bash
    $ ansible-lint site.yml -v
    WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: site.yml
    INFO     Executing syntax check on site.yml (0.77s)
    ```

* Попробуйте запустить playbook на этом окружении с флагом --check
  * Play в режиме `--check` завершается с ошибкой на этапе установки пакетов (yum) по причине отсутствия соответствующих файлов пакетов
    ```bash
    TASK [Install clickhouse packages] ***************************************************************************************************************************************************************
    fatal: [clickhouse-01]: FAILED! => {"changed": false, "module_stderr": "Shared connection to 192.168.56.11 closed.\r\n", "module_stdout": "Failed to set locale, defaulting to C.UTF-8\r\nTraceback (most recent call last):\r\n  File \"/root/.ansible/tmp/ansible-tmp-1673373059.220765-69669-28014305840638/AnsiballZ_dnf.py\", line 102, in <module>\r\n    _ansiballz_main()\r\n  File \"/root/.ansible/tmp/ansible-tmp-1673373059.220765-69669-28014305840638/AnsiballZ_dnf.py\", line 94, in _ansiballz_main\r\n    invoke_module(zipped_mod, temp_path, ANSIBALLZ_PARAMS)\r\n  File \"/root/.ansible/tmp/ansible-tmp-1673373059.220765-69669-28014305840638/AnsiballZ_dnf.py\", line 40, in invoke_module\r\n    runpy.run_module(mod_name='ansible.modules.dnf', init_globals=None, run_name='__main__', alter_sys=True)\r\n  File \"/usr/lib64/python3.6/runpy.py\", line 205, in run_module\r\n    return _run_module_code(code, init_globals, run_name, mod_spec)\r\n  File \"/usr/lib64/python3.6/runpy.py\", line 96, in _run_module_code\r\n    mod_name, mod_spec, pkg_name, script_name)\r\n  File \"/usr/lib64/python3.6/runpy.py\", line 85, in _run_code\r\n    exec(code, run_globals)\r\n  File \"/tmp/ansible_ansible.legacy.dnf_payload_ruuy2dqf/ansible_ansible.legacy.dnf_payload.zip/ansible/modules/dnf.py\", line 1330, in <module>\r\n  File \"/tmp/ansible_ansible.legacy.dnf_payload_ruuy2dqf/ansible_ansible.legacy.dnf_payload.zip/ansible/modules/dnf.py\", line 1319, in main\r\n  File \"/tmp/ansible_ansible.legacy.dnf_payload_ruuy2dqf/ansible_ansible.legacy.dnf_payload.zip/ansible/modules/dnf.py\", line 1294, in run\r\n  File \"/tmp/ansible_ansible.legacy.dnf_payload_ruuy2dqf/ansible_ansible.legacy.dnf_payload.zip/ansible/modules/dnf.py\", line 942, in ensure\r\n  File \"/tmp/ansible_ansible.legacy.dnf_payload_ruuy2dqf/ansible_ansible.legacy.dnf_payload.zip/ansible/modules/dnf.py\", line 842, in _install_remote_rpms\r\n  File \"/usr/lib/python3.6/site-packages/dnf/base.py\", line 1179, in add_remote_rpms\r\n    raise IOError(_(\"Could not open: {}\").format(' '.join(pkgs_error)))\r\nOSError: Could not open: clickhouse-common-static-22.3.3.44.rpm clickhouse-client-22.3.3.44.rpm clickhouse-server-22.3.3.44.rpm\r\n", "msg": "MODULE FAILURE\nSee stdout/stderr for the exact error", "rc": 1}
    ```

* Запустите playbook на prod.yml окружении с флагом --diff. Убедитесь, что изменения на системе произведены.
  * Выполним сценарий
    ```bash
    $ ansible-playbook -i inventory/prod.yml site.yml --diff

    PLAY [Install Clickhouse] ************************************************************************************************************************************************************************

    TASK [Gathering Facts] ***************************************************************************************************************************************************************************
    ok: [clickhouse-01]

    TASK [Get clickhouse distrib] ********************************************************************************************************************************************************************
    changed: [clickhouse-01] => (item=clickhouse-client)
    changed: [clickhouse-01] => (item=clickhouse-server)
    failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

    TASK [Get clickhouse distrib] ********************************************************************************************************************************************************************
    changed: [clickhouse-01]

    TASK [Install clickhouse packages] ***************************************************************************************************************************************************************
    changed: [clickhouse-01]

    TASK [Start clickhouse service] ******************************************************************************************************************************************************************
    changed: [clickhouse-01]

    TASK [Little bit pause for server started] *******************************************************************************************************************************************************
    Pausing for 5 seconds
    (ctrl+C then 'C' = continue early, ctrl+C then 'A' = abort)
    ok: [clickhouse-01]

    TASK [Create database] ***************************************************************************************************************************************************************************
    changed: [clickhouse-01]

    PLAY [Vector Install] ****************************************************************************************************************************************************************************

    TASK [Gathering Facts] ***************************************************************************************************************************************************************************
    ok: [vector-01]

    TASK [Get vector distrib] ************************************************************************************************************************************************************************
    changed: [vector-01]

    TASK [Install Vector packages] *******************************************************************************************************************************************************************
    changed: [vector-01]

    PLAY RECAP ***************************************************************************************************************************************************************************************
    clickhouse-01              : ok=6    changed=5    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
    vector-01                  : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ```

  * Убедимся, что результат достигнут
    ```bash
    $ ssh root@192.168.56.11 "clickhouse-client --version"
    ClickHouse client version 22.3.3.44 (official build).

    $ ssh root@192.168.56.12 "vector --version" 
    vector 0.26.0 (x86_64-unknown-linux-gnu c6b5bc2 2022-12-05)
    ```

* Повторно запустите playbook с флагом --diff и убедитесь, что playbook идемпотентен.
    ```bash
    ansible-playbook -i inventory/prod.yml site.yml --diff                                                                ✔  15s     21:11:17  

    PLAY [Install Clickhouse] ************************************************************************************************************************************************************************

    TASK [Gathering Facts] ***************************************************************************************************************************************************************************
    ok: [clickhouse-01]

    TASK [Get clickhouse distrib] ********************************************************************************************************************************************************************
    ok: [clickhouse-01] => (item=clickhouse-client)
    ok: [clickhouse-01] => (item=clickhouse-server)
    failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "secontext": "unconfined_u:object_r:admin_home_t:s0", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

    TASK [Get clickhouse distrib] ********************************************************************************************************************************************************************
    ok: [clickhouse-01]

    TASK [Install clickhouse packages] ***************************************************************************************************************************************************************
    ok: [clickhouse-01]

    TASK [Start clickhouse service] ******************************************************************************************************************************************************************
    ok: [clickhouse-01]

    TASK [Little bit pause for server started] *******************************************************************************************************************************************************
    Pausing for 5 seconds
    (ctrl+C then 'C' = continue early, ctrl+C then 'A' = abort)
    ok: [clickhouse-01]

    TASK [Create database] ***************************************************************************************************************************************************************************
    ok: [clickhouse-01]

    PLAY [Vector Install] ****************************************************************************************************************************************************************************

    TASK [Gathering Facts] ***************************************************************************************************************************************************************************
    ok: [vector-01]

    TASK [Get vector distrib] ************************************************************************************************************************************************************************
    ok: [vector-01]

    TASK [Install Vector packages] *******************************************************************************************************************************************************************
    ok: [vector-01]

    PLAY RECAP ***************************************************************************************************************************************************************************************
    clickhouse-01              : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
    vector-01                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ```