//
//  ZBarScanner.h
//  CollectMe
//
//  Created by Michael Black on 28/01/2014.
//
//

#import <Cordova/CDVPlugin.h>

#import "ZBarReaderController.h"
#import "ZBarReaderViewController.h"

@interface ZBarScanner : CDVPlugin <ZBarReaderDelegate>

@property (nonatomic, copy) NSString *callbackId;
@property (nonatomic, retain) ZBarReaderViewController *reader;
@property (readwrite, assign) BOOL hasPendingOperation;

- (void)scan:(CDVInvokedUrlCommand*)command;
- (void)returnSuccess:(NSString*)scannedText format:(NSString*)format cancelled:(BOOL)cancelled callback:(NSString*)callback;
- (void)returnError:(NSString*)message callback:(NSString*)callback;

@end
