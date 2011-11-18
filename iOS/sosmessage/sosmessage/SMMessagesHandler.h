//
//  SMMessagesHandler.h
//  sosmessage
//
//  Created by Arnaud K. on 14/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SOSMessageConstant.h"

@protocol SMMessageDelegate;

@interface SMMessagesHandler : NSObject

@property (assign) id <SMMessageDelegate,NSObject> delegate;

- (id)initWithDelegate:(id)delegate;
- (void)requestUrl:(NSString*)url;

- (void)requestCategories;
- (void)requestRandomMessageForCategory:(NSString*)aCategoryId;

@end

@protocol SMMessageDelegate

- (void)messageHandler:(SMMessagesHandler *)messageHandler didFinishWithJSon:(id)result;

@optional
- (void)messageHandler:(SMMessagesHandler *)messageHandler didFail:(NSError *)error;

- (void)startActivityFromMessageHandler:(SMMessagesHandler *)messageHandler;
- (void)stopActivityFromMessageHandler:(SMMessagesHandler *)messageHandler;


@end
