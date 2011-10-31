//
//  ViewController.m
//  sosmessage
//
//  Created by Arnaud K. on 30/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize messageLabel;
@synthesize activityIndicator;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setActivityIndicator:nil];
    [self setMessageLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
    
    /*
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }*/
}

#pragma mark NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.activityIndicator stopAnimating];
    self.messageLabel.text = error.description;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.activityIndicator stopAnimating];
    if (messageReceiving) {
        NSError* error;
        id message = [NSJSONSerialization JSONObjectWithData:messageReceiving options:0 error:&error];
        if (message) {
            NSLog(@"%@", message);
            self.messageLabel.text = [message objectForKey:@"message"];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (messageReceiving) {
        [messageReceiving appendData:data];
    } else {
        messageReceiving = [[NSMutableData alloc] initWithData:data];
    }
}


#pragma mark Custom methods

- (IBAction)generateButtonPressed:(id)sender {
    [self fetchAnotherMessage];
}

-(void)fetchAnotherMessage {
    [self.activityIndicator startAnimating];
    
    NSURL* url = [[NSURL alloc] initWithString:@"http://localhost:9393/v1/messages"];
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];
    messageReceiving = nil;
    
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    [request release];
    [url release];
}
- (void)dealloc {
    [activityIndicator release];
    [messageLabel release];
    [super dealloc];
}
@end
