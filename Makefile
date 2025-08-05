# Variables
IVERILOG = iverilog
VVP = vvp
PYTHON = python3

# Par défaut, lance les tests
all: test

# Lance tous les tests
test:
	@$(PYTHON) scripts/test_runner.py

# Génère un template de test
generate:
	@echo "Usage: make generate MODULE=<module_name>"
	@$(PYTHON) scripts/test_runner.py generate $(MODULE)

# Compile pour la Go Board
build:
	@bash scripts/build_fpga.sh

# Nettoie les fichiers temporaires
clean:
	@rm -rf temp/
	@rm -f *.vcd
	@rm -f *.out

# Watch mode - relance les tests à chaque modification
watch:
	@echo "Watching for changes..."
	@fswatch -o src/ test/ | xargs -n1 -I{} make test

.PHONY: all test generate build clean watch