### start command
```bash
!docker run --privileged --name nginx_ -p 5080:80 -d nginx:alpine
!docker exec -it nginx_ /bin/sh
```
浏览器:127.0.0.1:5080

### setting
/etc/nginx/nginx.conf
```
nginx -t
nginx -s reload
location = /app/index.html
location ~ /app/vedio[6-9].avi
~*:不区分大小写
^~:优先前缀,默认空格是普通前缀

//重定向
location /temp {
    return 307 /app/index.html;
}
或rewrite /temp /app/index.html;
```

### 博客挂载nginx :error not useful
1. <http://nginx.org/en/docs/beginners_guide.html>
2. /key2demo
3. autoindex on;
