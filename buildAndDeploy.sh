echo "Building and publishing"

docker build -t convee/api $GITHUB_WORKSPACE

aws lightsail push-container-image --service-name conveeapi --label pipeline --image convee/api

PIPELINE_IMAGE_TAG=$(aws lightsail get-container-images --service conveeapi | jq -r .containerImages[0].image)

aws lightsail create-container-service-deployment --service-name conveeapi --containers "{\"conveeapi\":{\"image\":\"$PIPELINE_IMAGE_TAG\",\"ports\":{\"80\":\"HTTP\"},\"environment\":{\"DATABASE_URL\":\"$1\"}}}" --public-endpoint "{\"containerName\":\"conveeapi\",\"containerPort\":80}" > /dev/null
