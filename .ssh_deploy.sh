# ENV setup
set -e
set -x
PROJ_NAME=__PROJ_NAME__
USER_NAME=__USER_NAME__
CI_DEPLOY_TOKEN=__CI_DEPLOY_TOKEN__
CI_DEPLOY_DIR=__CI_DEPLOY_DIR__

# Deploy
mkdir -p $CI_DEPLOY_DIR
cd $CI_DEPLOY_DIR
if [ ! -d $PROJ_NAME ]; then
    git clone http://$USER_NAME:$CI_DEPLOY_TOKEN@192.168.161.132:8010/emc/$PROJ_NAME.git;
fi
cd $PROJ_NAME
git fetch --all
git reset --hard origin/main
docker compose -f docker-compose-prod.yaml down --remove-orphans
docker compose -f docker-compose-prod.yaml pull
docker compose -f docker-compose-prod.yaml up -d
