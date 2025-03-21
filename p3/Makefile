#Colors

GREEN = \033[0;32m
RED = \033[0;31m
NC = \033[0m
BLUE = \033[0;34m
YELLOW = \033[0;33m
all:
	@echo "${BLUE}==================Init Environment===============${NC}"
	sh setup/1-init-env.sh
	@echo "${BLUE}==================Init ArgoCd===============${NC}"
	sh setup/2-init-argocd.sh
fclean:
	@echo "${RED}==================Clean Environment===============${NC}"
	@sudo k3d cluster delete lelhlami
	# @rm kubectl.sha256
	# @rm install.yaml*
setup-1:
	@echo "${BLUE}==================Init Environment===============${NC}"
	sh setup/1-init-env.sh
setup-2:
	@echo "${BLUE}==================Init ArgoCd===============${NC}"
	sh setup/2-init-argocd.sh
re: fclean all
.PHONY: all fclean re