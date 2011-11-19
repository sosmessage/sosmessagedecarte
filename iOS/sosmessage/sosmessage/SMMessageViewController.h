//
//  SMDetailViewController.h
//  sosmessage
//
//  Created by Arnaud K. on 06/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SOSMessageConstant.h"

@interface SMMessageViewController : UIViewController {
    
}

@property (retain, nonatomic) IBOutlet UIImageView *titleImage;
@property (retain, nonatomic) IBOutlet UITextView *messageText;

- (id)initWithCategory:(NSDictionary*)aCategory;
- (IBAction)dismissButtonPressed:(id)sender;
- (void)fetchAMessage;
- (void)renderTitle;
- (void)refreshRenders;

@end
