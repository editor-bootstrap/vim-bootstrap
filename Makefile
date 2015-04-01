deploy:
	appcfg.py update .

run:
	dev_appserver.py app.yaml

.PHONY: deploy run
