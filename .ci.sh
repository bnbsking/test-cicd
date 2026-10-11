# 因Server上無網路, CI只能自主做, 這裡提供範例, 並準備docker image讓後續CD可自動化
set -e


# ======== unit test ========
docker run --rm -v $(pwd):/app \
    -w /app python:3.12-slim \
    bash -c "pip install pytest && cd /app/tests/unit_test && pytest"


# ======== (optional) integration test (activate only when big change happen) ========
# docker build -t python_312_client:v0 .
# docker run --rm -v $(pwd):/app \
#     -w /app python:3.12-slim \
#     bash -c "pip install pytest && cd /app/tests/integration_test && pytest"


# ======== build prod docker for deployment (trade off: use mount can skip rebuild as long as dependencies don't change,
# but break the isolation of docker) ========
docker buildx build --platform linux/arm64 -t python_312_client_arm64:v0 --load .
docker tag python_312_client_arm64:v0 192.168.161.132:5000/python_312_client_arm64:v0
docker push 192.168.161.132:5000/python_312_client_arm64:v0


# === CD-flow (you can update version and use git tag as well) ===
git add .
git commit -m "update test-new"
git push
# then go to gitlab and push run pipeline button to trigger deployment
