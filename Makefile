chapter_files := $(wildcard chapter*.tex)
html_files := $(patsubst %.tex,html/%.html,$(chapter_files))

all: popgen_notes.pdf

%.png : %.eps
	convert -density 300 $< -flatten $@

PHONY: clean all site

clean:
	rm -f popgen_notes.pdf
	rm -f html/chapter-*html
	latexmk -c

site: $(html_files) figures
	cp -r figures/*png html/figures
 
popgen_notes.pdf: popgen_notes.tex
	latexmk $<

html/%.html: %.tex
	(cat template.tex; cat $<; echo "\\\\end{document}") | pandoc -s --mathjax --toc --css css/style.css --smart --to html5 --from latex > $@

deploy: html/
	# this is from http://stevenclontz.com/blog/2014/05/08/git-subtree-push-for-deployment/
	git subtree push --prefix html origin gh-pages
