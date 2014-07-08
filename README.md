zbar-phonegap-plugin
====================

This plugin is for iOS only.

Usage:
```
if (cordova.plugins.zbarScanner) {
	scanner = {};
	scanner.scan = function (callback) {
		cordova.plugins.zbarScanner.scan(
			function (result) {
				if (!result.cancelled) {
					callback(result.text);
				}
			}
		);
	}
}
```
