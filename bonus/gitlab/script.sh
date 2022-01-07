docker rm -f $(docker ps -a -q)
pwd=$(pwd)
host=$(hostname)
docker run --detach \
  --hostname $host \
  --env GITLAB_OMNIBUS_CONFIG="external_url 'http://$host'" \
  --publish 443:443 --publish 80:80 --publish 21:22 \
  --restart always \
  --volume $pwd/gitlabFiles/config:/etc/gitlab \
  --volume $pwd/gitlabFiles/logs:/var/log/gitlab \
  --volume $pwd/gitlabFiles/data:/var/opt/gitlab \
  --shm-size 256m \
  gitlab/gitlab-ee:latest