//
//  NSString+SOSMessage.m
//  sosmessage
//
//  Created by Arnaud K. on 05/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NSString+SOSMessage.h"

@implementation NSString (SOSMessage)
float sizeInBlocks;

-(float)sizeForBlocksForView:(UIView*)view {
    float blockSize = view.frame.size.width / NB_BLOCKS;
    return [self blocksCount:view] * blockSize;
}

-(float)blocksCount:(UIView*)view {
    float widthWithFont = [self sizeWithFont:SOSFONT].width;
    NSLog(@"Width with font for %@ : %.2f", self, widthWithFont);
    float blockSize = view.frame.size.width / NB_BLOCKS;
    NSLog(@"Frame width: %.2f and a block: %.2f", view.frame.size.width, blockSize);
    return ceilf(widthWithFont / blockSize);    
}
@end
