all: wesanderson.js wesanderson.css test/test_wesanderson.js

# R options (--vanilla, but without --no-environ)
R_OPTS=--no-save --no-restore --no-init-file --no-site-file

wesanderson.js: src/wes_palettes.js src/wes_palette.js
	cat $^ > $@

src/wes_palettes.js: src/create_wesandersonJS.R
	cd $(<D);R CMD BATCH $(R_OPTS) $(<F)

wesanderson.css: src/create_wesandersonCSS.R
	cd $(<D);R CMD BATCH $(R_OPTS) $(<F)

test/test_wesanderson.js: test/test_wesanderson.coffee
	cd $(<D);coffee -bc $(<F)
