//
//  ViewController.h
//  sosmessage
//
//  Created by Arnaud K. on 30/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SOSMessageConstant.h"
#import <MessageUI/MessageUI.h>

@interface SMCategoriesViewController : UIViewController<SMMessageDelegate, MFMailComposeViewControllerDelegate>

@property (retain, nonatomic) IBOutlet UIButton *infoButton;

@property (retain, nonatomic) NSMutableArray* categories;
@property (retain, nonatomic) SMMessagesHandler* messageHandler;

- (void)addSOSCategory:(NSDictionary*)category inPosX:(int)posX andPosY:(int)posY;
- (void)fillEmptyBlocks:(int)nb fromPosX:(int)posX andPosY:(int)posY;
- (UILabel*)buildUILabelForBlock:(int)nbBlocks inPosX:(int)posX andPosY:(int)posY;

- (void)refreshCategories;
- (void)removeCategoriesLabel;

- (IBAction)aboutPressed:(id)sender;

@end
