install-external-dns:
	kubectl --context=arctiq-ext-mission-aws apply -f ../secrets/external-dns-aws.yml
	kubectl --context=arctiq-ext-mission-azure apply -f ../secrets/external-dns-azure.yml
	kubectl --context=arctiq-ext-mission-gcp apply -f ../secrets/external-dns-gcp.yml

remove-external-dns:
	kubectl --context=arctiq-ext-mission-aws delete -f ../secrets/external-dns-aws.yml
	kubectl --context=arctiq-ext-mission-azure delete -f ../secrets/external-dns-azure.yml
	kubectl --context=arctiq-ext-mission-gcp delete -f ../secrets/external-dns-gcp.yml