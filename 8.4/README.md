## Домашнее задание к занятию "4. Работа с roles"

* Инфраструктура для воспроизведения [playbook](ansible/site.yml) была подготовлена с помощью [сценария](infra/) Vagrant
* Playbook был декомпозирован на отдельные роли по продуктам:
    - [vector-role](https://github.com/Stanislav-Zakharov/vector-role)
    - [lighthouse-role](https://github.com/Stanislav-Zakharov/lighthouse-role)
* Nginx был внедрен в роль `lighthouse-role` в качестве зависимости, так как role play должен включать в себя task'и, связанные с установкой одного продукта, но для функионирования lighthouse требуется Nginx
* Требуемые для нашего playbook роли были включены в файл [requirements.yml](./ansible/requirements.yml)
* Устанавливаем требуемые роли
    ```bash
    $ ansible-galaxy role install -p roles -r requirements.yml
    Starting galaxy role install process
    - extracting clickhouse to /home/stanislav/devops/netology/8.4/ansible/roles/clickhouse
    - clickhouse (1.11.0) was installed successfully
    - extracting vector-role to /home/stanislav/devops/netology/8.4/ansible/roles/vector-role
    - vector-role (1.0.0) was installed successfully
    - extracting lighthouse-role to /home/stanislav/devops/netology/8.4/ansible/roles/lighthouse-role
    - lighthouse-role (1.0.0) was installed successfully
    - adding dependency: nginxinc.nginx
    - downloading role 'nginx', owned by nginxinc
    - downloading role from https://github.com/nginxinc/ansible-role-nginx/archive/0.24.0.tar.gz
    - extracting nginxinc.nginx to /home/stanislav/devops/netology/8.4/ansible/roles/nginxinc.nginx
    - nginxinc.nginx (0.24.0) was installed successfully
    ```
* Запускаем playbook на заранее подготовленной инфраструктуре
    ```bash
    $ ansible-playbook -i inventory site.yml

    PLAY [Install Clickhouse] **********************************************************************************************************************************************************************************************

    TASK [Gathering Facts] *************************************************************************************************************************************************************************************************
    ok: [clickhouse-01]

    TASK [clickhouse : Include OS Family Specific Variables] ***************************************************************************************************************************************************************
    ok: [clickhouse-01]

    TASK [clickhouse : include_tasks] **************************************************************************************************************************************************************************************
    included: /home/stanislav/devops/netology/8.4/ansible/roles/clickhouse/tasks/precheck.yml for clickhouse-01

    TASK [clickhouse : Requirements check | Checking sse4_2 support] *******************************************************************************************************************************************************
    ok: [clickhouse-01]

    TASK [clickhouse : Requirements check | Not supported distribution && release] *****************************************************************************************************************************************
    skipping: [clickhouse-01]

    TASK [clickhouse : include_tasks] **************************************************************************************************************************************************************************************
    included: /home/stanislav/devops/netology/8.4/ansible/roles/clickhouse/tasks/params.yml for clickhouse-01

    TASK [clickhouse : Set clickhouse_service_enable] **********************************************************************************************************************************************************************
    ok: [clickhouse-01]

    TASK [clickhouse : Set clickhouse_service_ensure] **********************************************************************************************************************************************************************
    ok: [clickhouse-01]

    TASK [clickhouse : include_tasks] **************************************************************************************************************************************************************************************
    included: /home/stanislav/devops/netology/8.4/ansible/roles/clickhouse/tasks/install/yum.yml for clickhouse-01

    TASK [clickhouse : Install by YUM | Ensure clickhouse repo GPG key imported] *******************************************************************************************************************************************
    changed: [clickhouse-01]

    TASK [clickhouse : Install by YUM | Ensure clickhouse repo installed] **************************************************************************************************************************************************
    changed: [clickhouse-01]

    TASK [clickhouse : Install by YUM | Ensure clickhouse package installed (latest)] **************************************************************************************************************************************
    changed: [clickhouse-01]

    TASK [clickhouse : Install by YUM | Ensure clickhouse package installed (version latest)] ******************************************************************************************************************************
    skipping: [clickhouse-01]

    TASK [clickhouse : include_tasks] **************************************************************************************************************************************************************************************
    included: /home/stanislav/devops/netology/8.4/ansible/roles/clickhouse/tasks/configure/sys.yml for clickhouse-01

    TASK [clickhouse : Check clickhouse config, data and logs] *************************************************************************************************************************************************************
    ok: [clickhouse-01] => (item=/var/log/clickhouse-server)
    changed: [clickhouse-01] => (item=/etc/clickhouse-server)
    changed: [clickhouse-01] => (item=/var/lib/clickhouse/tmp/)
    changed: [clickhouse-01] => (item=/var/lib/clickhouse/)

    TASK [clickhouse : Config | Create config.d folder] ********************************************************************************************************************************************************************
    changed: [clickhouse-01]

    TASK [clickhouse : Config | Create users.d folder] *********************************************************************************************************************************************************************
    changed: [clickhouse-01]

    TASK [clickhouse : Config | Generate system config] ********************************************************************************************************************************************************************
    changed: [clickhouse-01]

    TASK [clickhouse : Config | Generate users config] *********************************************************************************************************************************************************************
    changed: [clickhouse-01]

    TASK [clickhouse : Config | Generate remote_servers config] ************************************************************************************************************************************************************
    skipping: [clickhouse-01]

    TASK [clickhouse : Config | Generate macros config] ********************************************************************************************************************************************************************
    skipping: [clickhouse-01]

    TASK [clickhouse : Config | Generate zookeeper servers config] *********************************************************************************************************************************************************
    skipping: [clickhouse-01]

    TASK [clickhouse : Config | Fix interserver_http_port and intersever_https_port collision] *****************************************************************************************************************************
    skipping: [clickhouse-01]

    TASK [clickhouse : Notify Handlers Now] ********************************************************************************************************************************************************************************

    RUNNING HANDLER [clickhouse : Restart Clickhouse Service] **************************************************************************************************************************************************************
    ok: [clickhouse-01]

    TASK [clickhouse : include_tasks] **************************************************************************************************************************************************************************************
    included: /home/stanislav/devops/netology/8.4/ansible/roles/clickhouse/tasks/service.yml for clickhouse-01

    TASK [clickhouse : Ensure clickhouse-server.service is enabled: True and state: restarted] *****************************************************************************************************************************
    changed: [clickhouse-01]

    TASK [clickhouse : Wait for Clickhouse Server to Become Ready] *********************************************************************************************************************************************************
    ok: [clickhouse-01]

    TASK [clickhouse : include_tasks] **************************************************************************************************************************************************************************************
    included: /home/stanislav/devops/netology/8.4/ansible/roles/clickhouse/tasks/configure/db.yml for clickhouse-01

    TASK [clickhouse : Set ClickHose Connection String] ********************************************************************************************************************************************************************
    ok: [clickhouse-01]

    TASK [clickhouse : Gather list of existing databases] ******************************************************************************************************************************************************************
    ok: [clickhouse-01]

    TASK [clickhouse : Config | Delete database config] ********************************************************************************************************************************************************************
    skipping: [clickhouse-01]

    TASK [clickhouse : Config | Create database config] ********************************************************************************************************************************************************************
    skipping: [clickhouse-01]

    TASK [clickhouse : include_tasks] **************************************************************************************************************************************************************************************
    included: /home/stanislav/devops/netology/8.4/ansible/roles/clickhouse/tasks/configure/dict.yml for clickhouse-01

    TASK [clickhouse : Config | Generate dictionary config] ****************************************************************************************************************************************************************
    skipping: [clickhouse-01]

    TASK [clickhouse : include_tasks] **************************************************************************************************************************************************************************************
    skipping: [clickhouse-01]

    PLAY [Install Vector] **************************************************************************************************************************************************************************************************

    TASK [Gathering Facts] *************************************************************************************************************************************************************************************************
    ok: [vector-01]

    TASK [vector-role : Get vector distrib] ********************************************************************************************************************************************************************************
    changed: [vector-01]

    TASK [vector-role : Install Vector packages] ***************************************************************************************************************************************************************************
    changed: [vector-01]

    PLAY [Install Lighthouse] **********************************************************************************************************************************************************************************************

    TASK [Gathering Facts] *************************************************************************************************************************************************************************************************
    ok: [lighthouse-01]

    TASK [nginxinc.nginx : Validate distribution and role variables] *******************************************************************************************************************************************************
    included: /home/stanislav/devops/netology/8.4/ansible/roles/nginxinc.nginx/tasks/validate/validate.yml for lighthouse-01

    TASK [nginxinc.nginx : Check whether you are using a supported NGINX distribution] *************************************************************************************************************************************
    ok: [lighthouse-01] => {
        "changed": false,
        "msg": "Your distribution, CentOS 7.8 (x86_64), is supported by NGINX Open Source."
    }

    TASK [nginxinc.nginx : Check that 'nginx_setup' is an allowed value] ***************************************************************************************************************************************************
    ok: [lighthouse-01] => {
        "changed": false,
        "msg": "All assertions passed"
    }

    TASK [nginxinc.nginx : Check that 'nginx_branch' is an allowed value] **************************************************************************************************************************************************
    ok: [lighthouse-01] => {
        "changed": false,
        "msg": "All assertions passed"
    }

    TASK [nginxinc.nginx : Check that 'nginx_install_from' is an allowed value] ********************************************************************************************************************************************
    ok: [lighthouse-01] => {
        "changed": false,
        "msg": "All assertions passed"
    }

    TASK [nginxinc.nginx : Set up prerequisites] ***************************************************************************************************************************************************************************
    included: /home/stanislav/devops/netology/8.4/ansible/roles/nginxinc.nginx/tasks/prerequisites/prerequisites.yml for lighthouse-01

    TASK [nginxinc.nginx : Install dependencies] ***************************************************************************************************************************************************************************
    included: /home/stanislav/devops/netology/8.4/ansible/roles/nginxinc.nginx/tasks/prerequisites/install-dependencies.yml for lighthouse-01

    TASK [nginxinc.nginx : (Alpine Linux) Install dependencies] ************************************************************************************************************************************************************
    skipping: [lighthouse-01]

    TASK [nginxinc.nginx : (Debian/Ubuntu) Install dependencies] ***********************************************************************************************************************************************************
    skipping: [lighthouse-01]

    TASK [nginxinc.nginx : (Amazon Linux/CentOS/Oracle Linux/RHEL) Install dependencies] ***********************************************************************************************************************************
    changed: [lighthouse-01]

    TASK [nginxinc.nginx : (SLES) Install dependencies] ********************************************************************************************************************************************************************
    skipping: [lighthouse-01]

    TASK [nginxinc.nginx : (FreeBSD) Install dependencies using package(s)] ************************************************************************************************************************************************
    skipping: [lighthouse-01]

    TASK [nginxinc.nginx : (FreeBSD) Install dependencies using port(s)] ***************************************************************************************************************************************************
    skipping: [lighthouse-01] => (item=security/ca_root_nss) 
    skipping: [lighthouse-01]

    TASK [nginxinc.nginx : Check if SELinux is enabled] ********************************************************************************************************************************************************************
    skipping: [lighthouse-01]

    TASK [nginxinc.nginx : Configure SELinux] ******************************************************************************************************************************************************************************
    skipping: [lighthouse-01]

    TASK [nginxinc.nginx : Set up signing keys] ****************************************************************************************************************************************************************************
    included: /home/stanislav/devops/netology/8.4/ansible/roles/nginxinc.nginx/tasks/keys/setup-keys.yml for lighthouse-01

    TASK [nginxinc.nginx : (Alpine Linux) Set up NGINX signing key URL] ****************************************************************************************************************************************************
    skipping: [lighthouse-01]

    TASK [nginxinc.nginx : (Alpine Linux) Download NGINX signing key] ******************************************************************************************************************************************************
    skipping: [lighthouse-01]

    TASK [nginxinc.nginx : (Debian/Red Hat/SLES OSs) Set up NGINX signing key URL] *****************************************************************************************************************************************
    ok: [lighthouse-01]

    TASK [nginxinc.nginx : (Debian/Ubuntu) Add NGINX signing key] **********************************************************************************************************************************************************
    skipping: [lighthouse-01]

    TASK [nginxinc.nginx : (Red Hat/SLES OSs) Add NGINX signing key] *******************************************************************************************************************************************************
    changed: [lighthouse-01]

    TASK [nginxinc.nginx : Install NGINX Open Source] **********************************************************************************************************************************************************************
    included: /home/stanislav/devops/netology/8.4/ansible/roles/nginxinc.nginx/tasks/opensource/install-oss.yml for lighthouse-01

    TASK [nginxinc.nginx : Install NGINX from the official package repository] *********************************************************************************************************************************************
    included: /home/stanislav/devops/netology/8.4/ansible/roles/nginxinc.nginx/tasks/opensource/install-redhat.yml for lighthouse-01

    TASK [nginxinc.nginx : (AlmaLinux/Amazon Linux/CentOS/Oracle Linux/RHEL/Rocky Linux) Configure NGINX repository] *******************************************************************************************************
    changed: [lighthouse-01]

    TASK [nginxinc.nginx : (AlmaLinux/Amazon Linux/CentOS/Oracle Linux/RHEL/Rocky Linux) Force Yum cache refresh] **********************************************************************************************************
    ok: [lighthouse-01]

    TASK [nginxinc.nginx : (AlmaLinux/Amazon Linux/CentOS/Oracle Linux/RHEL/Rocky Linux) Install NGINX] ********************************************************************************************************************
    changed: [lighthouse-01]

    TASK [nginxinc.nginx : Install NGINX from the distribution's package repository] ***************************************************************************************************************************************
    skipping: [lighthouse-01]

    TASK [nginxinc.nginx : Install NGINX from source] **********************************************************************************************************************************************************************
    skipping: [lighthouse-01]

    TASK [nginxinc.nginx : Install NGINX in Unix systems] ******************************************************************************************************************************************************************
    skipping: [lighthouse-01]

    TASK [nginxinc.nginx : Set up NGINX Plus license] **********************************************************************************************************************************************************************
    skipping: [lighthouse-01]

    TASK [nginxinc.nginx : Install NGINX Plus] *****************************************************************************************************************************************************************************
    skipping: [lighthouse-01]

    TASK [nginxinc.nginx : Install NGINX dynamic modules] ******************************************************************************************************************************************************************
    skipping: [lighthouse-01]

    TASK [nginxinc.nginx : Remove NGINX Plus license] **********************************************************************************************************************************************************************
    skipping: [lighthouse-01]

    TASK [nginxinc.nginx : Modify systemd parameters] **********************************************************************************************************************************************************************
    skipping: [lighthouse-01]

    TASK [nginxinc.nginx : Trigger handlers if necessary] ******************************************************************************************************************************************************************

    RUNNING HANDLER [nginxinc.nginx : (Handler) Start/reload NGINX] ********************************************************************************************************************************************************
    changed: [lighthouse-01]

    RUNNING HANDLER [nginxinc.nginx : (Handler) Check NGINX] ***************************************************************************************************************************************************************
    ok: [lighthouse-01]

    RUNNING HANDLER [nginxinc.nginx : (Handler) Print NGINX error if syntax check fails] ***********************************************************************************************************************************
    skipping: [lighthouse-01]

    TASK [nginxinc.nginx : Debug NGINX output] *****************************************************************************************************************************************************************************
    skipping: [lighthouse-01]

    TASK [nginxinc.nginx : Configure logrotate for NGINX] ******************************************************************************************************************************************************************
    skipping: [lighthouse-01]

    TASK [nginxinc.nginx : Install NGINX Amplify] **************************************************************************************************************************************************************************
    skipping: [lighthouse-01]

    TASK [lighthouse-role : Create NGINX general config] *******************************************************************************************************************************************************************
    changed: [lighthouse-01]

    TASK [lighthouse-role : Lighthouse | install dependencies] *************************************************************************************************************************************************************
    changed: [lighthouse-01]

    TASK [lighthouse-role : Lighthouse | Copy from git] ********************************************************************************************************************************************************************
    changed: [lighthouse-01]

    TASK [lighthouse-role : Lighthouse | Create lighthouse config] *********************************************************************************************************************************************************
    changed: [lighthouse-01]

    RUNNING HANDLER [lighthouse-role : reload-nginx] ***********************************************************************************************************************************************************************
    changed: [lighthouse-01]

    PLAY RECAP *************************************************************************************************************************************************************************************************************
    clickhouse-01              : ok=25   changed=9    unreachable=0    failed=0    skipped=10   rescued=0    ignored=0   
    lighthouse-01              : ok=24   changed=10   unreachable=0    failed=0    skipped=22   rescued=0    ignored=0   
    vector-01                  : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ```