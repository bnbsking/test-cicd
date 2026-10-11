# Introduction

Install K8s to a internet-isolated server.
Then launch an API server and send request.


# Setup server

1. Prerequistes
    + server must installed docker engine
    + private docker hub is reachable from server

2. download packages at PC tp setup
    ```text
    setup/
    |_calico/
    |   |_calicao.yaml
    |_deb/
    |   |_*.deb
    |_images/
        |_calico-v3.32.2.tar
        |_k8s-v1.32.11.tar
    ```

3. Login server and install
    + Very complicated


# Usage

1. at local pc

    ```bash
    cd example/
    docker compose build
    docker compose push
    ```

2. (Optional) Verify locally
    
    ```bash
    docker compose up -d
    docker exec -it example_client bash
    python client_docker.py  # You shoud see "Hello, James!"
    ```

3. at server

    ```bash
    kubectl apply -f example/pods.yaml
    kubectl exec -it example_client -n example -- bash
    python client_k8s.py  # You shoud see "Hello, James!"
    ```