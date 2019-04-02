all: clean
	./build.sh

server: clean
	./build.sh server

clean:
	rm -rf public build 