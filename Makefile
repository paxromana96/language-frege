all:
	NODE_ENV="dev" apm install
	node ./node_modules/coffee-script/bin/coffee src/frege.coffee

prelude:
	node ./node_modules/coffee-script/bin/coffee src/makeprelude.coffee
