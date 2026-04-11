## 🐳 Docker Basics

### Check Docker

```bash
docker --version
docker info
```

### Help

```bash
docker help
docker <command> --help
```

---

## 📦 Images

### List images

```bash
docker images
```

### Pull image

```bash
docker pull ubuntu
docker pull nginx:latest
```

### Remove image

```bash
docker rmi IMAGE_ID
docker rmi -f IMAGE_ID
```

### Build image

```bash
docker build -t myimage .
docker build -t myimage:1.0 .
```

---

## 📦 Containers

### List containers

```bash
docker ps        # running
docker ps -a     # all
```

### Run container

```bash
docker run ubuntu
docker run -it ubuntu /bin/bash
docker run -d nginx
```

### Run with name & port

```bash
docker run -d --name web -p 8080:80 nginx
```

### Run with volume

```bash
docker run -v /host/data:/container/data ubuntu
```

### Stop / Start / Restart

```bash
docker stop CONTAINER_ID
docker start CONTAINER_ID
docker restart CONTAINER_ID
```

### Remove container

```bash
docker rm CONTAINER_ID
docker rm -f CONTAINER_ID
```

---

## 🧠 Exec & Logs

### Exec into container

```bash
docker exec -it CONTAINER_ID /bin/bash
docker exec -it CONTAINER_ID sh
```

### View logs

```bash
docker logs CONTAINER_ID
docker logs -f CONTAINER_ID
```

---

## 📁 Volumes

### List volumes

```bash
docker volume ls
```

### Create volume

```bash
docker volume create myvol
```

### Use volume

```bash
docker run -v myvol:/data ubuntu
```

### Remove volume

```bash
docker volume rm myvol
```

---

## 🌐 Networks

### List networks

```bash
docker network ls
```

### Create network

```bash
docker network create mynet
```

### Run container on network

```bash
docker run --network mynet nginx
```

### Inspect network

```bash
docker network inspect mynet
```

---

## 🧹 Cleanup

### Remove unused containers

```bash
docker container prune
```

### Remove unused images

```bash
docker image prune
```

### Remove everything unused

```bash
docker system prune
docker system prune -a
```

---

# 🛠️ Utility Commands 
## 📁 docker cp (Copy files between host & container)

### Host ➜ Container

```
docker cp file.txt CONTAINER_ID:/path/file.txt
docker cp ./folder CONTAINER_ID:/app/
```

### Container ➜ Host

```
docker cp CONTAINER_ID:/var/log/nginx/access.log .
docker cp CONTAINER_ID:/app ./app_backup
```

---

## 🧪 docker exec (Run commands inside container)

```
docker exec -it CONTAINER_ID bash
docker exec -it CONTAINER_ID sh
docker exec CONTAINER_ID ls /app
```

### Run as root

```
docker exec -u root -it CONTAINER_ID bash
```

---

## 📦 docker commit (Save container state → image)

```
docker commit CONTAINER_ID myimage:modified
```

⚠️ Useful for quick experiments, not best practice for prod.

---

## 🧾 docker diff (What changed in a container)

```
docker diff CONTAINER_ID
```

**Output meanings:**

- `A` – Added
- `C` – Changed
- `D` – Deleted
    

---

## 🔍 docker inspect (Full container / image details)

```
docker inspect CONTAINER_ID
docker inspect IMAGE_ID
```

### Extract specific values

```
docker inspect -f '{{.NetworkSettings.IPAddress}}' CONTAINER_ID
```

---

## 📊 docker stats (Live resource usage)

```
docker stats
docker stats CONTAINER_ID
```

---

## 🧱 docker attach (Attach to running process)

```
docker attach CONTAINER_ID
```

### Detach safely

```
CTRL + P, CTRL + Q
```

⚠️ `CTRL+C` can stop the container

---

## ⏸️ Pause / Unpause containers

```
docker pause CONTAINER_ID
docker unpause CONTAINER_ID
```

---

## 🗃️ Export / Import Containers

### Export container filesystem

```
docker export CONTAINER_ID > container.tar
```

### Import as image

```
docker import container.tar myimage:latest
```

---

## 💾 Save / Load Images

### Save image

```
docker save -o image.tar myimage:latest
```

### Load image

```
docker load -i image.tar
```

---

## 🧼 Rename Container

```
docker rename old_name new_name
```

---

## 🔄 Update container resources