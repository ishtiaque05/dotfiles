.PHONY: help build build-linux build-mac test test-linux test-mac shell-linux shell-mac clean install-linux install-mac

# Default target
help:
	@echo "======================================"
	@echo "  Dotfiles Docker Testing"
	@echo "======================================"
	@echo ""
	@echo "Available targets:"
	@echo ""
	@echo "  make build              - Build both Linux and Mac test images"
	@echo "  make build-linux        - Build only Linux test image"
	@echo "  make build-mac          - Build only Mac test image"
	@echo ""
	@echo "  make apply-linux-config - FIRST TIME: Install everything + open Zsh"
	@echo "  make apply-mac-config   - FIRST TIME: Install everything + open Zsh"
	@echo ""
	@echo "  make zsh-linux-shell    - Open Zsh shell (uses existing container)"
	@echo "  make zsh-mac-shell      - Open Zsh shell (uses existing container)"
	@echo ""
	@echo "  make test-linux         - Run installation + validation on Linux"
	@echo "  make test-mac           - Run installation + validation on Mac"
	@echo "  make test               - Run tests on both platforms"
	@echo ""
	@echo "  make clean              - Remove containers and images"
	@echo "  make clean-containers   - Remove containers only (keep images)"
	@echo "  make reset-linux        - Remove Linux container (run apply again)"
	@echo "  make reset-mac          - Remove Mac container (run apply again)"
	@echo ""
	@echo "======================================"
	@echo "Workflow:"
	@echo "  1. make apply-linux-config   # First time setup"
	@echo "  2. make zsh-linux-shell      # Quick access (instant!)"
	@echo "  3. make reset-linux          # Start fresh if needed"
	@echo "======================================"

# Build targets
build:
	@echo "Building both test images..."
	docker compose -f docker-tests/docker-compose.yml build

build-linux:
	@echo "Building Linux test image..."
	docker compose -f docker-tests/docker-compose.yml build linux-test

build-mac:
	@echo "Building Mac test image..."
	docker compose -f docker-tests/docker-compose.yml build mac-test

# Interactive Zsh shell targets (reuses existing container if configured)
zsh-linux-shell: build-linux
	@echo "Opening Zsh shell in Linux container..."
	@if docker ps -a --format '{{.Names}}' | grep -q '^dotfiles-linux-test$$'; then \
		echo "Using existing container..."; \
		if docker ps --format '{{.Names}}' | grep -q '^dotfiles-linux-test$$'; then \
			docker exec -it dotfiles-linux-test zsh; \
		else \
			docker start -ai dotfiles-linux-test; \
		fi \
	else \
		echo "No configured container found. Run 'make apply-linux-config' first."; \
		exit 1; \
	fi

zsh-mac-shell: build-mac
	@echo "Opening Zsh shell in Mac container..."
	@if docker ps -a --format '{{.Names}}' | grep -q '^dotfiles-mac-test$$'; then \
		echo "Using existing container..."; \
		if docker ps --format '{{.Names}}' | grep -q '^dotfiles-mac-test$$'; then \
			docker exec -it dotfiles-mac-test zsh; \
		else \
			docker start -ai dotfiles-mac-test; \
		fi \
	else \
		echo "No configured container found. Run 'make apply-mac-config' first."; \
		exit 1; \
	fi

# Apply dotfiles configuration (run Chezmoi installation + interactive shell)
# Creates a persistent container that can be reused with zsh-linux-shell
apply-linux-config: build-linux
	@echo "Applying dotfiles configuration (Linux)..."
	@echo "This will create a persistent container for reuse."
	@echo ""
	@if docker ps -a --format '{{.Names}}' | grep -q '^dotfiles-linux-test$$'; then \
		echo "Removing existing container..."; \
		docker rm -f dotfiles-linux-test; \
	fi
	docker compose -f docker-tests/docker-compose.yml run --name dotfiles-linux-test linux-test

apply-mac-config: build-mac
	@echo "Applying dotfiles configuration (macOS)..."
	@echo "This will create a persistent container for reuse."
	@echo ""
	@if docker ps -a --format '{{.Names}}' | grep -q '^dotfiles-mac-test$$'; then \
		echo "Removing existing container..."; \
		docker rm -f dotfiles-mac-test; \
	fi
	docker compose -f docker-tests/docker-compose.yml run --name dotfiles-mac-test mac-test

# Test targets (run installation + validation) - always use --rm for clean tests
test-linux: build-linux
	@echo "Testing Linux installation with Chezmoi..."
	docker compose -f docker-tests/docker-compose.yml run --rm linux-test bash -c "export PATH=\$$HOME/.local/bin:\$$PATH && \$$HOME/.local/bin/chezmoi init --apply --source=/home/testuser/dotfiles-source && echo '' && echo '=== Running validation tests ===' && bash ~/dotfiles-source/docker-tests/test-installation.sh && echo '' && echo '=== Testing aliases ===' && zsh -c 'source ~/.zshrc && type cat && alias | grep -E \"(cat=|ls=|gs=)\" | head -3'"

test-mac: build-mac
	@echo "Testing Mac installation with Chezmoi..."
	docker compose -f docker-tests/docker-compose.yml run --rm mac-test bash -c 'export PATH=\$$HOME/.local/bin:\$$PATH && eval "\$$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && \$$HOME/.local/bin/chezmoi init --apply --source=/home/testuser/dotfiles-source && echo "" && echo "=== Running validation tests ===" && bash ~/dotfiles-source/docker-tests/test-installation.sh && echo "" && echo "=== Testing aliases ===" && zsh -c "source ~/.zshrc && type cat && alias | grep -E \"(cat=|ls=|gs=)\" | head -3"'

test: test-linux test-mac
	@echo ""
	@echo "All tests complete!"

# Cleanup targets
clean:
	@echo "Cleaning up Docker containers and images..."
	docker compose -f docker-tests/docker-compose.yml down
	docker rmi -f dotfiles-test:linux dotfiles-test:mac 2>/dev/null || true
	@echo "Cleanup complete!"

clean-containers:
	@echo "Removing containers (keeps images)..."
	docker compose -f docker-tests/docker-compose.yml down
	@echo "Containers removed. Images preserved for faster rebuild."

reset-linux:
	@echo "Removing Linux container..."
	@if docker ps -a --format '{{.Names}}' | grep -q '^dotfiles-linux-test$$'; then \
		docker rm -f dotfiles-linux-test; \
		echo "Linux container removed. Run 'make apply-linux-config' to recreate."; \
	else \
		echo "No Linux container found."; \
	fi

reset-mac:
	@echo "Removing Mac container..."
	@if docker ps -a --format '{{.Names}}' | grep -q '^dotfiles-mac-test$$'; then \
		docker rm -f dotfiles-mac-test; \
		echo "Mac container removed. Run 'make apply-mac-config' to recreate."; \
	else \
		echo "No Mac container found."; \
	fi
