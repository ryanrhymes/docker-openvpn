
.PHONY: all
all: build

.PHONY: dist
dist: submodule
	if [ ! -d "node_modules" ]; then npm install; fi
	if [ ! -f ".flowconfig" ]; then npm run flow init; fi
	npm run webpack

.PHONY: build
build: submodule
	if [ ! -d "node_modules" ]; then npm install; fi
	if [ ! -f ".flowconfig" ]; then npm run flow init; fi
	npm run flow && npm run build

.PHONY: local
local:
	if [ ! -d "node_modules" ]; then npm install; fi
	if [ ! -f ".flowconfig" ]; then npm run flow init; fi
	npm run flow && npm run build

.PHONY: start
start: build
	npm run start

.PHONY: clean
clean:
	$(RM) -r build dist

.PHONY: cleanall
cleanall: clean
	$(RM) -r node_modules

.PHONY: push
push:
	git commit -am "coding ..." && \
	git push origin master
