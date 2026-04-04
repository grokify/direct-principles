.PHONY: docs docs-serve docs-deploy presentation presentation-html clean help

# Documentation
docs:
	mkdocs build

docs-serve:
	mkdocs serve

docs-deploy:
	mkdocs gh-deploy --force

# Presentation (requires Marp CLI: npm install -g @marp-team/marp-cli)
presentation:
	marp docs/presentations/direct-overview.md -o docs/presentations/direct-overview.html

presentation-pdf:
	marp docs/presentations/direct-overview.md -o docs/presentations/direct-overview.pdf

presentation-pptx:
	marp docs/presentations/direct-overview.md -o docs/presentations/direct-overview.pptx

# Build all
all: docs presentation

# Clean generated files
clean:
	rm -rf site/
	rm -f docs/presentations/*.html
	rm -f docs/presentations/*.pdf
	rm -f docs/presentations/*.pptx

# Help
help:
	@echo "Available targets:"
	@echo "  docs           - Build MkDocs site"
	@echo "  docs-serve     - Serve docs locally (http://localhost:8000)"
	@echo "  docs-deploy    - Deploy to GitHub Pages"
	@echo "  presentation   - Build Marp presentation (HTML)"
	@echo "  presentation-pdf  - Build Marp presentation (PDF)"
	@echo "  presentation-pptx - Build Marp presentation (PowerPoint)"
	@echo "  all            - Build docs and presentation"
	@echo "  clean          - Remove generated files"
