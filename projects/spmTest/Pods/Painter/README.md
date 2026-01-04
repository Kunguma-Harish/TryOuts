![Swiftformat Version 0.48.18](https://img.shields.io/badge/SwiftFormat-0.48.18-orange)

2D Drawing Framework for macOS, iOS, tvOS and watchOS

Go through this checklist whenever changes are made:

- [ ] Make sure that the changes you make for one app does not affect the other(Show\Nila) or if you are fixing a issue, make sure the issue is fixed in both the apps.
- [ ] Rendering should look identical in all platforms. Some CoreGraphics APIs behave differently in different platforms.
- [ ] If the rendering is changed, inform web team about the new behaviour.
- [ ] SVG Export in Nila should be taken care of based on any new rendering changes.
