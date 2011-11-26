//
//  SMAboutViewController.h
//  sosmessage
//
//  Created by Arnaud K. on 26/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SOSMessageConstant.h"

@interface SMAboutViewController : UIViewController<UIWebViewDelegate>
@property (retain, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (retain, nonatomic) IBOutlet UIWebView *webView;

@end
