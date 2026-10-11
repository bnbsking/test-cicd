# deploy private dockerhub
docker load -i /home/git/projects/docker/registry_3_arm64.tar
docker run -d -p 5000:5000 \
    --name registry \
    -v /home/git/projects/gitlab_utils/private_dockerhub:/var/lib/registry \
    registry:3_arm64


# deploy gitlab runner
docker load -i /home/git/projects/docker/gitlab_runner_latest_arm64.tar
docker run -d --name gitlab-runner --restart always \
  -v /srv/gitlab-runner/config:/etc/gitlab-runner \
  -v /var/run/docker.sock:/var/run/docker.sock \
  gitlab/gitlab-runner:latest_arm64


# allow private dockerhub
docker load -i /home/git/projects/docker/python_312_client_arm64_v0.tar
docker run --privileged --pid=host -it python_312_client_arm64:v0 nsenter -t 1 -m -u -i -n bash
vim /etc/docker/daemon.json
## add config: {"insecure-registries": ["192.168.161.132:5000"]}
systemctl restart docker
## try using private docker hub
docker tag python_312_client_arm64:v0 192.168.161.132:5000/python_312_client_arm64:v0
docker push 192.168.161.132:5000/python_312_client_arm64:v0
docker pull 192.168.161.132:5000/python_312_client_arm64:v0
docker rmi 192.168.161.132:5000/python_312_client_arm64:v0


# setup ssh for auto deployment
ssh-keygen -t rsa -b 4096 -C "gitlab-ci"
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
cat ~/.ssh/id_rsa
