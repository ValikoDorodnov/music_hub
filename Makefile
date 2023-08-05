run-server-playbook:
	cd provisioning && ansible-playbook -i hosts.yml server.yml --extra-vars "@env.yml"