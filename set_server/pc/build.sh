# build private dockerhub docker images
docker buildx build \
    -f Dockerfile.registry \
    --platform linux/arm64 \
    -t registry:3_arm64 \
    --load .
docker save -o registry_3_arm64.tar registry:3_arm64
scp registry_3_arm64.tar git@192.168.161.132:/home/git/projects/docker


# build gitlab runner docker image
docker buildx build \
    -f Dockerfile.runner \
    --platform linux/arm64 \
    -t gitlab/gitlab-runner:latest_arm64 \
    --load .
docker save -o gitlab_runner_latest_arm64.tar gitlab/gitlab-runner:latest_arm64
scp gitlab_runner_latest_arm64.tar git@192.168.161.132:/home/git/projects/docker


# build example docker image
docker buildx build --platform linux/arm64 -t python_312_client_arm64:v0 --load .
docker save -o python_312_client_arm64_v0.tar python_312_client_arm64:v0
scp python_312_client_arm64_v0.tar git@192.168.161.132:/home/git/projects/docker


# then go to server and deploy `private dockerhub docker images` and `gitlab runner docker image`
# Detail of private dockerhub
: <<'COMMENT'
    # after private dockerhub be setup, client need to set "insecure-registries ip"
        ```bash
        sudo vim /etc/docker/daemon.json
        # add config: {“insecure-registries”: [“192.168.161.132:5000”]}
        sudo systemctl restart docker
        
    # push 
        ```bash
        docker tag my-app 192.168.161.132:5000/my-app
        docker push 192.168.161.132:5000/my-app
        ```
    
    # pull
        ```bash
        docker pull 192.168.161.132:5000/my-app
        ```
    
    # list images / tags
        ```bash
        curl http://192.168.161.132:5000/v2/_catalog
        curl http://192.168.161.132:5000/v2/my-app/tags/list
        ```
COMMENT


# after ssh to the server, register your project to gitlab runner
# Detail of gitlab runner
: <<'COMMENT'
    # register runner
        ```bash
        docker exec -it gitlab-runner gitlab-runner register
        # set token from gitlab project
        # set tag as project name
        # use shell executor
        ```
    
    # list and remove runner
        ```bash
        docker exec -it gitlab-runner gitlab-runner list
        docker exec -it gitlab-runner gitlab-runner unregister --name "..."
        ```
        + the config can be found in gitlab ui or /etc/gitlab-runner/config.toml
COMMENT
