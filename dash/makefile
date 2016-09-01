VERSION := $(shell git describe --abbrev=0 --tag)
NAME := Lasso\ 9
SITE := lassoguide.com
FEED := LassoGuide

all: $(FEED).tgz
	@mv -f $(FEED).* ../build/html/
	$(info Moved $(FEED).* to ../build/html/ for upload, access with dash-feed://http%3A%2F%2F$(SITE)%2F$(FEED).xml)
	

$(FEED).tgz: $(NAME).docset $(FEED).xml
	tar --exclude='.DS_Store' -czf $(FEED).tgz $(NAME).docset

%.docset:
	doc2dash -f --enable-js --online-redirect-url "http://$(SITE)/" --name "$*" --icon icon.png ../build/html/
	rm "$@"/Contents/Resources/Documents/LassoGuide*.pdf
	rm "$@"/Contents/Resources/Documents/_static/guide_cover_*

%.xml:
	echo '<entry><version>$(VERSION)</version><url>http://$(SITE)/$*.tgz</url></entry>' > $@

clean:
	rm -rf $(NAME).docset $(FEED).xml $(FEED).tgz
