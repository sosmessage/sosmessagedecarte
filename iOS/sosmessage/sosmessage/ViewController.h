//
//  ViewController.h
//  sosmessage
//
//  Created by Arnaud K. on 30/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SOSMessageConstant.h"

@interface ViewController : UIViewController <NSURLConnectionDelegate> {
    @private
    NSMutableData* messageReceiving;
    NSMutableArray* labels;
}
@property (retain, nonatomic) IBOutlet UILabel *messageLabel;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) NSURLConnection* currentConnection;

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;

- (void)fetchAnotherMessage;
- (void)stopActivity;
- (void)startActivity;

- (void)addSOSCategory:(NSString*)label inPosX:(int)posX andPosY:(int)posY;
- (void)fillEmptyBlocks:(int)nb fromPosX:(int)posX andPosY:(int)posY;
- (void)placeCategories:(NSMutableArray*)categories;
- (void)handleCategoryTapping:(UIGestureRecognizer *)sender;

@end
