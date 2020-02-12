# How to test this app:

```
docker pull docker.pkg.github.com/gregov/arctiq-ext-mission/stateful-test-app:16
docker volume create my-vol
docker  run -d  -p 8080:80 --mount source=myvol2,target=/data docker.pkg.github.com/gregov/arctiq-ext-mission/stateful-test-app:16
```

http://localhost:8080