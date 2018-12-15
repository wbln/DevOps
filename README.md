DevOps

Скрипты для автоматического развертывания бесплатных версий Hub YouTrack Upsource TeamCity+3 Build Агента в докер контейнерах
Так же в сборку влючен portainer для управления контейнерами.

***ВАЖНО***
в файле run-docker.sh
```ssh
68:        -e SERVER_URL="<host_ip>:8840" \
```
указать url/ip хост машины


**Запуск**

из папки с Vagrantfile
```ssh
vagtant up
```
по завершению в консоли выведутся токены для авторизации приложений

```ssh
 "======== Hub token ========="
 "=== символы авторизации  ==="
 "============================"

 "====== YouTrack token ======"
 "=== символы авторизации  ==="
 "============================"

 "====== UpSource token ======"
 "=== символы авторизации  ==="
 "============================"
```

portainer не всегда запускается сразу, иногда приходится запускать в ручную, пока не победил
```ssh
[vagrant@jb ~]$ sudo docker ps -a
CONTAINER ID        IMAGE                             COMMAND               CREATED             STATUS              PORTS                    NAMES
64d64edb0758        jetbrains/teamcity-agent          "/run-services.sh"    12 minutes ago      Up 12 minutes       9090/tcp                 prod-agent
dc632060df03        jetbrains/teamcity-agent          "/run-services.sh"    12 minutes ago      Up 12 minutes       9090/tcp                 dev-agent
784bca717117        jetbrains/teamcity-agent          "/run-services.sh"    13 minutes ago      Up 13 minutes       9090/tcp                 test-agent
f916dcaec23a  <==   portainer/portainer               "/portainer"          About an hour ago   Up 32 minutes       0.0.0.0:8090->9000/tcp   portainer-server
4df62ac3505d        jetbrains/teamcity-server         "/run-services.sh"    About an hour ago   Up About an hour    0.0.0.0:8084->8111/tcp   teamcity-server
91ecc31db99c        jetbrains/upsource:2018.2.1013    "/bin/bash /run.sh"   About an hour ago   Up About an hour    0.0.0.0:8083->8080/tcp   upsource-server
1fe990ea985d        jetbrains/youtrack:2018.3.47965   "/bin/bash /run.sh"   About an hour ago   Up About an hour    0.0.0.0:8082->8080/tcp   youtrack-server
608caf376e07        jetbrains/hub:2018.3.11035        "/bin/bash /run.sh"   About an hour ago   Up About an hour    0.0.0.0:8081->8080/tcp   hub-server
[vagrant@jb ~]$ sudo docker start f91
```

доступ к приложениям:
```ssh
<host_ip>:8810 - Hub
<host_ip>:8820 - Youtrack
<host_ip>:8830 - Upsource
<host_ip>:8840 - Teamcity
<host_ip>:8890 - Portainer
```