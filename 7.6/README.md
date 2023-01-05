## Домашнее задание к занятию "7.6. Написание собственных провайдеров для Terraform."
Задача 1.
1. Найдите, где перечислены все доступные resource и data_source, приложите ссылку на эти строки в коде на гитхабе.
    > `ResourcesMap` и `DataSourcesMap` перечислены в структуре описателя параметров Provider'а:  
    > * [ResourcesMap](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/provider/provider.go#L943)
    > * [DataSourcesMap](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/provider/provider.go#L419)
2. Для создания очереди сообщений SQS используется ресурс aws_sqs_queue у которого есть параметр name.
    * С каким другим параметром конфликтует name? Приложите строчку кода, в которой это указано.
        - `name_prefix` - [source link](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L88)
    * Какая максимальная длина имени?
        - 80 символов, согласно проверке соответствия регулярного выражения [source link](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L430-L434)
    * Какому регулярному выражению должно подчиняться имя?
        - Имя очереди типа `fifo` - `^[a-zA-Z0-9_-]{1,75}\.fifo$`
        - Имя очереди обычного типа - `^[a-zA-Z0-9_-]{1,80}$`