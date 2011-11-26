//
//  SMAboutViewController.m
//  sosmessage
//
//  Created by Arnaud K. on 26/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SMAboutViewController.h"

@interface SMAboutViewController ()
-(void)startActivity;
-(void)endActivity;
@end

@implementation SMAboutViewController
@synthesize navigationItem;
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed)];
    self.navigationItem.leftBarButtonItem = item;
    [item release];
}

-(void)doneButtonPressed {
    [self dismissModalViewControllerAnimated:true];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [self setNavigationItem:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:SM_ABOUT]]];
    
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [self endActivity];
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [webView release];
    [navigationItem release];
    [super dealloc];
}

#pragma mark UIWebViewDelegate

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self endActivity];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [self endActivity];
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    [self startActivity];
}

#pragma mark Custom Activity
-(void)startActivity {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    hud.labelText = @"a propos...";
}

-(void)endActivity {
    if (self.webView.loading) {
        [self.webView stopLoading];
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:TRUE];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
@end
