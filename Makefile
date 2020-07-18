all:
	elm make src/Main.elm --output game.html
	cp -r static build/static
	cp index.html build/index.html