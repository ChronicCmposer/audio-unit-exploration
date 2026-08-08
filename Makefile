PROJECT     := audio-unit-exploration.xcodeproj
SCHEME      := audio-unit-exploration
DESTINATION := platform=macOS
SIM_NAME    := iPhone 17 Pro

# Extra settings passed through to xcodebuild. Empty by default; override to work
# around signing problems, e.g.:
#   make build XCFLAGS='CODE_SIGN_ENTITLEMENTS="" CODE_SIGN_IDENTITY="-" CODE_SIGN_STYLE=Manual DEVELOPMENT_TEAM=""'
XCFLAGS :=

# Audio Unit identity, as declared in the extension's AudioComponents Info.plist.
AU_TYPE         := aufx
AU_SUBTYPE      := test
AU_MANUFACTURER := CCmp

XCODEBUILD := xcodebuild -project $(PROJECT) -scheme $(SCHEME)

# Resolved from the build settings so this tracks Xcode's DerivedData location.
built_products = $(shell $(XCODEBUILD) -showBuildSettings -destination '$(DESTINATION)' 2>/dev/null \
	| awk -F' = ' '/ BUILT_PRODUCTS_DIR = /{print $$2; exit}')

.PHONY: build release clean test build-ios pretty register validate list-au help

## build: debug build for macOS
build:
	$(XCODEBUILD) -destination '$(DESTINATION)' $(XCFLAGS) build

## release: release build for macOS
release:
	$(XCODEBUILD) -configuration Release -destination '$(DESTINATION)' $(XCFLAGS) build

## clean: remove build intermediates and products
clean:
	$(XCODEBUILD) clean

## test: run the test targets on macOS
test:
	$(XCODEBUILD) -destination '$(DESTINATION)' $(XCFLAGS) test

## build-ios: debug build for the iOS Simulator
build-ios:
	$(XCODEBUILD) -destination 'platform=iOS Simulator,name=$(SIM_NAME)' $(XCFLAGS) build

## pretty: debug build for macOS, piped through xcbeautify
pretty:
	set -o pipefail; $(XCODEBUILD) -destination '$(DESTINATION)' $(XCFLAGS) build | xcbeautify

## register: launch the host app so macOS registers the bundled Audio Unit
register: build
	@app="$(built_products)/$(SCHEME).app"; \
	test -d "$$app" || { echo "error: $$app not found"; exit 1; }; \
	echo "opening $$app"; \
	open "$$app"

## validate: run the auval conformance suite against the plugin
validate:
	auval -v $(AU_TYPE) $(AU_SUBTYPE) $(AU_MANUFACTURER)

## list-au: show this plugin's entry among the registered Audio Units
list-au:
	@auval -a 2>/dev/null | grep -- '$(AU_MANUFACTURER)' || echo "not registered yet - run 'make register' first"

## help: list available targets
help:
	@grep -E '^## ' $(MAKEFILE_LIST) | sed 's/^## /  /'
