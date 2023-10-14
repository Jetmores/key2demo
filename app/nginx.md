### start command
```bash
!docker run --privileged --name nginx_ -p 5080:80 -d nginx:alpine
!docker exec -it nginx_ /bin/sh
```
浏览器:127.0.0.1:5080

### setting
/etc/nginx/nginx.conf
