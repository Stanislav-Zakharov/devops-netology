# devops-netology

Файлы, которые будут проигнорированы согласно конфигурации .\terraform\.gitignore (все шаблоны проверены с помощью "git check-ignore")

**/.terraform/* - рекурсивно до папки .terraform и далее

*.tfstate - все файлы с расширением tfstate

*.tfstate.* - все файлы с суффиксом tfstate

crash.log - одноименный файл - везде

*.tfvars - все файлы с расширением tfvars

override.tf - одноименный файл - везде

override.tf.json - одноименный файл - везде

*_override.tf - все файлы заканчивающиеся на _override.tf

*_override.tf.json - все файлы заканчивающиеся на _override.tf.json

.terraformrc - одноименный файл - везде

terraform.rc - одноименный файл - везде
