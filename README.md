## Introduction
This is an example repo to practice CI/CD.

After git push, once push botton, it auto triggers `.gitlab-ci.yml` and execute the follows
+ SSH to the target machine
+ git clone / pull
+ docker compose down
+ docker compose pull
+ docker compose up


## Client setup

1. (Just do one time for each client OS) Allow private dockerhub
    + add config by `sudo vim /etc/docker/daemon.json`
        ```bash
        {“insecure-registries”: [“192.168.161.132:5000”]}
        ```
    + restart docker
        ```bash
        sudo systemctl restart docker
        ```

2. (Just do one time for each initialized project) Setup runner
    + 詳見CICD教學: `"O:\Group_IT\AI_Team\資料\0.使用說明書\cicd\20260331_CICD_new.ppt"`

    | step | place                    | action              |
    | -    | -                        | -                   |
    | 1    | 192.168.161.132          | Setup runner        |
    | 2    | (Any server &) Gitlab UI | Setup SSH key       |
    | 3    | Gitlab UI                | Setup Git clone key |
    | 4    | Local repo               | Setup deploy script |


## Server setup

詳見CI/CD教學 或 `set_server/` 中先執行pc的下載再去server部署
