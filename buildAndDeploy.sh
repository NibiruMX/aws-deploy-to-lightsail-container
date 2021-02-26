echo "Building and publishing"

docker build -t convee/api $GITHUB_WORKSPACE

echo "Done building"

aws lightsail push-container-image --service-name conveeapi --label pipeline --image convee/api

echo "Done pushing container"

PIPELINE_IMAGE_TAG=$(aws lightsail get-container-images --service conveeapi | jq -r .containerImages[0].image)

echo "Using image $PIPELINE_IMAGE_TAG"

aws lightsail create-container-service-deployment --service-name conveeapi --containers "{\"conveeapi\":{\"image\":\"$PIPELINE_IMAGE_TAG\",\"ports\":{\"80\":\"HTTP\"},\"environment\":{\"DATABASE_URL\":\"$1\"}}}" --public-endpoint "{\"containerName\":\"conveeapi\",\"containerPort\":80}" > /dev/null

echo "Done creating deployment"
