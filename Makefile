.PHONY: \
	crank \
	clean \
	local \
	rsync

PWD=$(shell pwd)
BUILD=$(PWD)/build
SOURCE=$(PWD)/tt

default: crank

clean:
	rm -fr $(BUILD)

local: clean
	mkdir -p $(BUILD)/ || true > /dev/null 2>&1
	perl crank --sourcepath=$(SOURCE) --buildpath=$(BUILD) --local
	cp -R static/* $(BUILD)/

crank: clean
	mkdir -p $(BUILD)/ || true > /dev/null 2>&1
	cp -R static/* $(BUILD)/
	perl crank --sourcepath=$(SOURCE) --buildpath=$(BUILD)
	find $(BUILD) -name "*~" -exec rm -f {} \; # Remove any backup leftovers

test:
	prove t/html.t

# This is only useful for Andy
rsync: crank
	rsync -azu -e ssh --delete --verbose \
		$(BUILD)/ andy@huggy.petdance.com:/srv/bg/
