//
//  SOSMessageConstant.h
//  sosmessage
//
//  Created by Arnaud K. on 05/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "NSString+SOSMessage.h"

#import "SMUrlBase.h"
#import "SMMessagesHandler.h"
#import "MBProgressHUD.h"

#import "AppDelegate.h"

#define SOSFONT [(AppDelegate*)[[UIApplication sharedApplication] delegate] deviceSpecificSOSFont]
#define NB_BLOCKS [(AppDelegate*)[[UIApplication sharedApplication] delegate] deviceSpecificNumberOfBlocks]

@protocol SOSMessageConstant <NSObject>

@end
