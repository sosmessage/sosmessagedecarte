//
//  ViewController.h
//  sosmessage
//
//  Created by Arnaud K. on 30/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SOSMessageConstant.h"

@interface ViewController : UIViewController<SMMessageDelegate>

@property (retain, nonatomic) NSMutableArray* categories;
@property (retain, nonatomic) SMMessagesHandler* messageHandler;

- (void)addSOSCategory:(NSDictionary*)category inPosX:(int)posX andPosY:(int)posY;
- (void)fillEmptyBlocks:(int)nb fromPosX:(int)posX andPosY:(int)posY;
- (UILabel*)buildUILabelForBlock:(int)nbBlocks inPosX:(int)posX andPosY:(int)posY;

- (void)refreshCategories;
- (void)removeCategoriesLabel;
- (void)handleCategoryTapping:(UIGestureRecognizer *)sender;

@end
