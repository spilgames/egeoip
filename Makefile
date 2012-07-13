REBAR ?= $(shell which rebar 2>/dev/null || which ./rebar)
REBAR_FLAGS ?=

all: compile

compile:
	$(REBAR) compile $(REBAR_FLAGS)

doc:
	$(REBAR) doc $(REBAR_FLAGS)

test: compile
	$(REBAR) eunit $(REBAR_FLAGS)

clean:
	$(REBAR) clean $(REBAR_FLAGS)

clean_plt:
	@rm -f _test/dialyzer_plt

build_plt: build-plt

build-plt:
	@ [ -d _test ] || mkdir _test
	$(REBAR) build-plt $(REBAR_FLAGS)

dialyzer:
	$(REBAR) dialyze $(REBAR_FLAGS)

tag:
	@echo "Current version: $(TAG)" > DOC/CHANGELOG
	@git log --decorate  |\
         grep -E '(^ +(DOC|FIX|OPT|CHANGE|NEW|SEC|CHANGE|PERF))|tag:' |\
         sed 's/commit [0-9a-f]* (.*tag: \([0-9.]*\).*).*/\ntag: \1/'\
         >> DOC/CHANGELOG
	@git add DOC/CHANGELOG
	@git commit -m "--" DOC/CHANGELOG
	@git tag $(TAG)