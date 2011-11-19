//
//  AppDelegate.h
//  sosmessage
//
//  Created by Arnaud K. on 30/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMCategoriesViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SMCategoriesViewController *viewController;

- (int)deviceSpecificNumberOfBlocks;
- (UIFont*)deviceSpecificSOSFont;

@end
