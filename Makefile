#!/usr/bin/make

include .env
export

run-server-playbook:
	cd provisioning && ansible-playbook -i hosts.yml server.yml --extra-vars "@env.yml"

deploy:
	ssh ${REMOTE_USER}@${REMOTE_HOST} -p ${SSH_PORT} 'sudo mkdir -p /sys/fs/cgroup/systemd'
	ssh ${REMOTE_USER}@${REMOTE_HOST} -p ${SSH_PORT} 'sudo mountpoint -q /sys/fs/cgroup/systemd || sudo mount -t cgroup -o none,name=systemd cgroup /sys/fs/cgroup/systemd'
	ssh ${REMOTE_USER}@${REMOTE_HOST} -p ${SSH_PORT} 'mkdir -p mstream'
	ssh ${REMOTE_USER}@${REMOTE_HOST} -p ${SSH_PORT} 'mkdir -p mstream/logs'
	ssh ${REMOTE_USER}@${REMOTE_HOST} -p ${SSH_PORT} 'mkdir -p mstream/uploads'
	scp -P ${SSH_PORT} mstream/docker-compose.yml ${REMOTE_USER}@${REMOTE_HOST}:mstream/docker-compose.yml
	scp -P ${SSH_PORT} mstream/config.json ${REMOTE_USER}@${REMOTE_HOST}:mstream/config.json
	scp -P ${SSH_PORT} -r mstream/uploads ${REMOTE_USER}@${REMOTE_HOST}:mstream/uploads
	ssh ${REMOTE_USER}@${REMOTE_HOST} -p ${SSH_PORT} 'cd mstream && docker-compose down && docker-compose up -d --build'



