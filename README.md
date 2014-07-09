zbar-phonegap-plugin
====================

This barcode scanner plugin is using the Zbar SDK, as opposed to the commonly used PhoneGap BarcodeScanner (http://phonegap.com/blog/build/barcodescanner-plugin) which is based on ZXing.

The main difference is that ZBar seems performance seems to be better, handle error-correction better, and also supports ITF barcodes.

[ ! ] Note:
This plugin is for iOS only.

Usage Example:

```
if (cordova.plugins.zbarScanner && navigator.userAgent.match(/iPhone|iPad|iPod/i)) { // We must make sure it's triggered ONLY for iOS
	scanner = {};
	scanner.scan = function (callback) {
		cordova.plugins.zbarScanner.scan(
			function (result) {
				if (!result.cancelled) {
					// alert(result.text);
					callback(result.text);
				}
			},
			function (error) {
				alert("Failed: " + error);
			}
		);
	}
}
```

Since this plugin only works on iOS, we suggest to use both plugins in parallel (zbar + the default barcodescanner).
In the Javascript, in order to use both - you can simply do this:

```
if (!window.plugins) {
	window.plugins = {};
}
if (cordova.plugins.zbarScanner && navigator.userAgent.match(/iPhone|iPad|iPod/i)) { // We must make sure it's triggered ONLY for iOS
	// If ZBar scanner is installed - we use it
	window.plugins.barcodeScanner = cordova.plugins.zbarScanner;
} else if (cordova.plugins && cordova.plugins.barcodeScanner) {
	// BarcodeScanner is already loaded into cordova.plugins
	// This is as-of Cordova v3.4.
	window.plugins.barcodeScanner = cordova.plugins.barcodeScanner;
} else if (!window.plugins.barcodeScanner) {
	// Legacy support
	window.plugins.barcodeScanner = cordova.require('cordova/plugin/BarcodeScanner');
}
if (window.plugins.barcodeScanner) {
	scanner = {};
	scanner.scan = function (callback) {
		window.plugins.barcodeScanner.scan(
			function (result) {
				if (!result.cancelled) {
					// alert(result.text);
					callback(result.text);
				}
			},
			function (error) {
				alert("Failed: " + error);
			}
		);
	}
}
```

