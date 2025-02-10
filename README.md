# Настройка проекта:
1) `terraform init`

2) `terraform apply`

3) После выполнения деплоя Nextcloud будет доступен по адресу: `<SERVER_IP_ADDRESS>/nextcloud/index.php`, где `SERVER_IP_ADDRESS` - IP-адрес сервера, который можно получить, выполнив команду `terraform output`

4) `terraform destroy`

# Примечание:
Возможно, скрипту не удастся добавить сервер в `known_hosts` за отведенное количество попыток (у меня не воспроизводилось, но такая вероятность все равно есть). 
- Второе применение команды `terraform apply` должно помочь. 
- Либо, можно вручную запустить команду `ansible-playbook --become --become-user root --become-method sudo -i ../ansible/inventory ../ansible/nextcloud.yml`