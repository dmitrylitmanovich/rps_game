assets-compile:
	rm public/stylesheets/* -rf
	sass app/stylesheets/main.scss > public/stylesheets/main.css
start:
	rm public/stylesheets/* -rf
	sass app/stylesheets/main.scss > public/stylesheets/main.css
	padrino start
