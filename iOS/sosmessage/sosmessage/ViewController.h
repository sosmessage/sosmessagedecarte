//
//  ViewController.h
//  sosmessage
//
//  Created by Arnaud K. on 30/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ViewController : UIViewController <NSURLConnectionDelegate> {
    @private
    NSMutableData* messageReceiving;
}
@property (retain, nonatomic) IBOutlet UIButton *generateButton;
@property (retain, nonatomic) IBOutlet UIButton *categoryButton;
@property (retain, nonatomic) IBOutlet UILabel *messageLabel;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) NSURLConnection* currentConnection;

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;

- (IBAction)generateButtonPressed:(id)sender;
- (IBAction)categoryBurronPressed:(id)sender;
- (IBAction)categoryButtonPressed:(id)sender;
- (void)fetchAnotherMessage;
- (void)stopActivity;
- (void)startActivity;

@end
