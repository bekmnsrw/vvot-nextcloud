# Настройка проекта:
1) `terraform init`

2) `terraform apply`

3) После выполнения деплоя Nextcloud будет доступен по адресу: `<SERVER_IP_ADDRESS>/nextcloud/index.php`, где `SERVER_IP_ADDRESS` - IP-адрес сервера, который можно получить, выполнив команду `terraform output`

4) `terraform destroy`