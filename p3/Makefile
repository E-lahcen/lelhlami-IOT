all:
	sh setup/1-init-env.sh
	sh setup/2-init-argocd.sh
fclean:
	rm kubectl.sha256
	rm install.yaml*
	@sudo k3d cluster delete lelhlami
re: fclean all
.PHONY: all fclean re