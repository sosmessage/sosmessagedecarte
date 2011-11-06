//
//  SMDetailViewController.m
//  sosmessage
//
//  Created by Arnaud K. on 06/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SMDetailViewController.h"

@implementation SMDetailViewController

float baseHue;

- (id)initWithHue:(float)hue category:(NSString*)category {
    self = [super initWithNibName:@"SMDetailViewController" bundle:nil];
    if (self) {
        NSLog(@"Hue parameter: %.3f", hue);
        baseHue = hue;
        self.view.backgroundColor = [UIColor colorWithHue:hue saturation:0.15 brightness:0.9 alpha:1];
    }
    return self;
}

- (IBAction)dismissButtonPressed:(id)sender {
    [self dismissModalViewControllerAnimated:true];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
