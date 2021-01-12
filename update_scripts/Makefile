update_pkgs:
	./update_pkgs.sh

setup_dest:
	if [ \! \( -d "$${HOME}/.local/bin" \) ]; then \
	  mkdir "$${HOME}/.local/bin"; \
	fi

update_aws_iam_authenticator:
	./update_aws_iam_authenticator.sh

update_gcloud:
	./update_gcloud.sh

update_go:
	./update_go.sh

update_goreleaser:
	./update_goreleaser.sh

update_kfctl: update_pkgs # for jq
	./update_kfctl.sh

update_etcdctl: setup_dest
	./update_etcdctl.sh

update_kubebuilder:
	./update_kubebuilder.sh

update_kubectl:
	./update_kubectl.sh

update_kustomize:
	./update_kustomize.sh

update_lean:
	./update_lean.sh

update_master:
	./update_master.sh

update_minikube:
	./update_minikube.sh

update_ycm:
	./update_ycm.sh

update_direnv:
	./update_direnv.sh

install_configs:
	./install_git_config.sh
	./install_tmux_config.sh
	./install_configs.sh

install_docker:
	./install_docker.sh

setup_workstation: \
  update_pkgs \
  update_aws_iam_authenticator \
  update_gcloud \
  update_go \
  update_goreleaser \
  update_kfctl \
  update_kubebuilder \
  update_kubectl \
  update_kustomize \
  update_minikube \
  update_ycm \
  update_direnv \
  update_git_config \
  install_docker
	echo -e "Setup finished."
	echo -e "Run:\n  cd $${HOME}/.vim/bundle/YouCompleteMe && ./install.py --clang-completer\nfor C/C++ completion in vim"
	echo -e "Edit '$${HOME}/.gitconfig' to use 'vimdiff' instead of 'meld' for diffs"
	echo -e "Run:\n  gcloud init\nto finish setting up gcloud utilities"
	echo -e "Run:\n  sudo shutdown -r now\nto start docker daemon"
	echo -e "When you return, run:\n  gcloud components update\nfor the latest gcloud"

.PHONY: \
  setup_workstation \
  update_aws_iam_authenticator \
  update_gcloud \
  update_go \
  update_goreleaser \
  update_kfctl \
  update_kops \
  update_kubebuilder \
  update_kubectl \
  update_kustomize \
  update_lean \
  update_master \
  update_minikube \
  update_ycm \
  update_direnv
