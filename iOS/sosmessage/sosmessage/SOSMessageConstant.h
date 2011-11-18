//
//  SOSMessageConstant.h
//  sosmessage
//
//  Created by Arnaud K. on 05/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#pragma mark CATEGORIES

#import "NSString+SOSMessage.h"

#pragma mark HEADERS

#import "SMUrlBase.h"
#import "SMMessagesHandler.h"
#import "MBProgressHUD.h"

#import "AppDelegate.h"

#pragma mark CODE REPLACE

#define SOSFONT [(AppDelegate*)[[UIApplication sharedApplication] delegate] deviceSpecificSOSFont]
#define NB_BLOCKS [(AppDelegate*)[[UIApplication sharedApplication] delegate] deviceSpecificNumberOfBlocks]

#pragma mark DICTIONNARY KEYS

#define CATEGORIES_COUNT    @"count"
#define CATEGORIES_ITEMS    @"items"

#define CATEGORY_ID         @"id"
#define CATEGORY_NAME       @"name"

#define MESSAGE_TEXT        @"text"

@protocol SOSMessageConstant <NSObject>

@end
