//
//  ZBarScanner.m
//  CollectMe
//
//  Created by Michael Black on 28/01/2014.
//
//

#import "ZBarScanner.h"

@implementation ZBarScanner

@synthesize callbackId;

- (void)scan:(CDVInvokedUrlCommand *)command {
    
    
    self.callbackId = command.callbackId;
    
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    [self.viewController presentModalViewController: reader
                            animated: YES];
    
    // queue [processor scanBarcode] to run on the event loop
//    [processor performSelector:@selector(scanBarcode) withObject:nil afterDelay:0];
}

//--------------------------------------------------------------------------
- (void)returnSuccess:(NSString*)scannedText format:(NSString*)format cancelled:(BOOL)cancelled callback:(NSString*)callback {
    NSNumber* cancelledNumber = [NSNumber numberWithInt:(cancelled?1:0)];

    NSMutableDictionary* resultDict = [[NSMutableDictionary alloc] init];
    [resultDict setObject:scannedText     forKey:@"text"];
    [resultDict setObject:format          forKey:@"format"];
    [resultDict setObject:cancelledNumber forKey:@"cancelled"];

    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus: CDVCommandStatus_OK
                               messageAsDictionary: resultDict
                               ];

    NSString* js = [result toSuccessCallbackString:callback];

    [self writeJavascript:js];
}

//--------------------------------------------------------------------------
- (void)returnError:(NSString*)message callback:(NSString*)callback {
//    CDVPluginResult* result = [CDVPluginResult
//                               resultWithStatus: CDVCommandStatus_OK
//                               messageAsString: message
//                               ];
//    
//    NSString* js = [result toErrorCallbackString:callback];
//    
//    [self writeJavascript:js];
}

#pragma mark -
#pragma mark ZBarReaderDelegate
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    id <NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *sym = nil;
    for(sym in results)
        break;
    assert(sym);

    if(!sym)
        return;
    
    // do something with results
//    barcode.symbol = sym;
//    barcode.type = [NSNumber numberWithInteger: sym.type];
//    barcode.data = sym.data;
    
    [picker dismissModalViewControllerAnimated: YES];
    
    [self returnSuccess:sym.data format:sym.typeName cancelled:FALSE callback:self.callbackId];
}

@end
