//
//  NSString+SOSMessage.h
//  sosmessage
//
//  Created by Arnaud K. on 05/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SOSMessageConstant.h"

@interface NSString (SOSMessage) {

}

@property (readonly) float hue;

-(float)sizeForBlocksForView:(UIView*)view;
-(float)blocksCount:(UIView*)view;

@end
