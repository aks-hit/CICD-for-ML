# install:
# 	pip install --upgrade pip &&\
# 	pip install -r requirements.txt

# format:	
# 	black *.py 

# train:
# 	python train.py

# eval:
# 	echo "## Model Metrics" > report.md
# 	cat ./Results/metrics.txt >> report.md
	
# 	echo '\n## Confusion Matrix Plot' >> report.md
# 	echo '![Confusion Matrix](./Results/model_results.png)' >> report.md
	
# 	cml comment create report.md
		
# update-branch:
# 	git config --global user.name $(USER_NAME)
# 	git config --global user.email $(USER_EMAIL)
# 	git commit -am "Update with new results"
# 	git push --force origin HEAD:update

# hf-login: 
# 	pip install -U "huggingface_hub[cli]"
# 	git pull origin update
# 	git switch update
# 	huggingface-cli login --token $(HF) --add-to-git-credential

# push-hub: 
# 	huggingface-cli upload AkshitSingh/Drug_Classification ./App /App --repo-type=space --commit-message="Sync App files"
# 	huggingface-cli upload AkshitSingh/Drug_Classification ./Model /Model --repo-type=space --commit-message="Sync Model"
# 	huggingface-cli upload AkshitSingh/Drug_Classification ./Results /Metrics --repo-type=space --commit-message="Sync Model"

# deploy: hf-login push-hub

# all: install format train eval update-branch deploy
install:
	pip install --upgrade pip && \
	pip install -r requirements.txt

format:	
	black *.py 

train:
	python train.py

eval:
	echo "## Model Metrics" > report.md
	cat ./Results/metrics.txt >> report.md
	
	echo '\n## Confusion Matrix Plot' >> report.md
	echo '![Confusion Matrix](./Results/model_results.png)' >> report.md
	
	cml comment create report.md

update-branch:
	git config --global user.name "$(USER_NAME)"
	git config --global user.email "$(USER_EMAIL)"
	git commit -am "Update with new results"
	git push --force origin HEAD:update

hf-login: 
	pip install -U "huggingface_hub[cli]"
	git pull origin update
	git switch update
	huggingface-cli login --token $(HF) --add-to-git-credential

push-hub: 
	pip install -U "huggingface_hub[cli]"
	# Retry logic for upload using huggingface-cli
	retry=0; max_retries=3; \
	while [ $$retry -lt $$max_retries ]; do \
	    huggingface-cli upload AkshitSingh/Drug_Classification ./App --repo-type=space --commit-message="Sync App files" && break; \
	    retry=$$((retry+1)); \
	    echo "Retrying App upload... ($$retry/$$max_retries)"; \
	    sleep 10; \
	done
	
	retry=0; \
	while [ $$retry -lt $$max_retries ]; do \
	    huggingface-cli upload AkshitSingh/Drug_Classification ./Model --repo-type=space --commit-message="Sync Model" && break; \
	    retry=$$((retry+1)); \
	    echo "Retrying Model upload... ($$retry/$$max_retries)"; \
	    sleep 10; \
	done
	
	retry=0; \
	while [ $$retry -lt $$max_retries ]; do \
	    huggingface-cli upload AkshitSingh/Drug_Classification ./Results --repo-type=space --commit-message="Sync Results" && break; \
	    retry=$$((retry+1)); \
	    echo "Retrying Results upload... ($$retry/$$max_retries)"; \
	    sleep 10; \
	done

deploy: hf-login push-hub

all: install format train eval update-branch deploy

