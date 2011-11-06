//
//  SMDetailViewController.h
//  sosmessage
//
//  Created by Arnaud K. on 06/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMDetailViewController : UIViewController {
    
}
@property (retain, nonatomic) IBOutlet UIImageView *messageImage;

- (id)initWithHue:(float)hue category:(NSString*)category;
- (IBAction)dismissButtonPressed:(id)sender;

@end
