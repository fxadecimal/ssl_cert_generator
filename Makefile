.PHONY: generate convert

all: clean generate convert

clean:
	rm -rf ./build
	mkdir -p ./build
	chmod 700 ./build

generate:
	bash generate.sh

convert:
	bash convert.sh
