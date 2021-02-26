docker build -t convee/api-cd .

docker run \
       --env-file ./.env \
       -v /var/run/docker.sock:/var/run/docker.sock \
       --mount type=bind,source=/Users/marianouvalle/dev/convee/convee-api,target=/github/workspace \
       convee/api-cd
