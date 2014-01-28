//
//  ZBarScanner.m
//  CollectMe
//
//  Created by Michael Black on 28/01/2014.
//
//

#import "ZBarScanner.h"

@implementation ZBarScanner

// ZBAR_EAN2        =      2,  /**< GS1 2-digit add-on */
    // ZBAR_EAN5        =      5,  /**< GS1 5-digit add-on */
    // ZBAR_EAN8        =      8,  /**< EAN-8 */
    // ZBAR_UPCE        =      9,  /**< UPC-E */
    // ZBAR_ISBN10      =     10,  /**< ISBN-10 (from EAN-13). @since 0.4 */
    // ZBAR_UPCA        =     12,  /**< UPC-A */
    // ZBAR_EAN13       =     13,  /**< EAN-13 */
    // ZBAR_ISBN13      =     14,  /**< ISBN-13 (from EAN-13). @since 0.4 */
    // ZBAR_COMPOSITE   =     15,  /**< EAN/UPC composite */
    // ZBAR_I25         =     25,  /**< Interleaved 2 of 5. @since 0.4 */
    // ZBAR_DATABAR     =     34,  /**< GS1 DataBar (RSS). @since 0.11 */
    // ZBAR_DATABAR_EXP =     35,  /**< GS1 DataBar Expanded. @since 0.11 */
    // ZBAR_CODABAR     =     38,  /**< Codabar. @since 0.11 */
    // ZBAR_CODE39      =     39,  /**< Code 39. @since 0.4 */
    // ZBAR_PDF417      =     57,  /**< PDF417. @since 0.6 */
    // ZBAR_QRCODE      =     64,  /**< QR Code. @since 0.10 */
    // ZBAR_CODE93      =     93,  /**< Code 93. @since 0.11 */
    // ZBAR_CODE128

@synthesize callbackId;

- (void)scan:(CDVInvokedUrlCommand *)command {
    
    
    self.callbackId = command.callbackId;
    
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;

    // disable all symbols - useful to re-enable specific codes only
    // [reader.scanner setSymbology: 0
    //      config: ZBAR_CFG_ENABLE
    //      to: 0];

    [reader.scanner setSymbology: ZBAR_QRCODE
                config: ZBAR_CFG_ENABLE
                to: 1];

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
