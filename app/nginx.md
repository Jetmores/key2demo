### start command
```bash
!docker run --privileged --name nginx_ -p 5080:80 -d nginx:alpine
!docker exec -it nginx_ /bin/sh
```
浏览器:127.0.0.1:5080

### setting
/etc/nginx/nginx.conf

### 博客挂载nginx :error not useful
1. <http://nginx.org/en/docs/beginners_guide.html>
2. /key2demo
3. autoindex on;
