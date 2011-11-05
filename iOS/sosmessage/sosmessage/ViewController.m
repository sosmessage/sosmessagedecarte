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
@synthesize currentConnection;

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
    labels = [[NSMutableArray alloc] initWithObjects:@"Remerciements", @"Calques", nil];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self becomeFirstResponder];
    [super viewDidAppear:animated];
    
    NSMutableArray* categories = [NSMutableArray arrayWithObjects:@"Test1 Remember",@"Test2",@"Test3 Remember",@"Test4 Remember",@"Test5",@"Test6",@"Test7 Remember",@"Test8",@"Test9",@"Test10 Remember", nil];
    [self placeCategories:categories];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [labels release];
    [self.currentConnection cancel];
    [self.currentConnection release];
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

-(BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self stopActivity];
    self.messageLabel.text = error.description;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self stopActivity];
    if (messageReceiving) {
        NSError* error;
        id response = [NSJSONSerialization JSONObjectWithData:messageReceiving options:0 error:&error];
        if (response) {
            // TODO should handle other request
            NSLog(@"%@", response);
            self.messageLabel.text = [[response objectAtIndex:(random() % [response count])] objectForKey:@"label"];
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

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        [self fetchAnotherMessage];
    }
}

#pragma mark Category handling

- (void)addSOSCategory:(NSString*)label inPosX:(int)posX andPosY:(int)posY {
    float blockSize = self.view.frame.size.width / NB_BLOCKS;
    int labelHeight = 60;
    
    float rectX = floorf(blockSize * posX);
    float rectY = labelHeight * posY;
    float rectWidth = ceilf([label sizeForBlocksForView:self.view]);
    float rectHeight = labelHeight;
    
    NSLog(@"Place label (%@) at (%.2f;%.2f) with size (%.2f;%.2f)", label, rectX, rectY, rectWidth, rectHeight);
    
    UILabel* uiLabel = [[[UILabel alloc] initWithFrame:CGRectMake(rectX, rectY, rectWidth, rectHeight)] autorelease];
    float hue = (rand()%10) / 10.0;
    uiLabel.backgroundColor = [UIColor colorWithHue:hue saturation:0.4 brightness:0.9 alpha:1.0];
    uiLabel.text = label;
    uiLabel.font = SOSFONT;
    uiLabel.textAlignment = UITextAlignmentCenter;
    uiLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *categoryTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCategoryTapping:)];
    [uiLabel addGestureRecognizer:categoryTap];
    [categoryTap release];
    
    [self.view addSubview:uiLabel];
}

- (void)fillEmptyBlocks:(int)nb fromPosX:(int)posX andPosY:(int)posY {
    float blockSize = self.view.frame.size.width / NB_BLOCKS;
    int labelHeight = 60;
    
    float rectX = floorf(blockSize * posX);
    float rectY = labelHeight * posY;
    float rectWidth = blockSize * nb;
    float rectHeight = labelHeight;
    
    NSLog(@"Fill %d blocks at (%.2f;%.2f) with size (%.2f;%.2f)", nb, rectX, rectY, rectWidth, rectHeight);
    UILabel* emptyBlocks = [[[UILabel alloc] initWithFrame:CGRectMake(rectX, rectY, rectWidth, rectHeight)] autorelease];
    float hue = (rand()%10) / 10.0;
    emptyBlocks.backgroundColor = [UIColor colorWithHue:hue saturation:0.2 brightness:1 alpha:1.0];
    
    [self.view addSubview:emptyBlocks];
}

- (void)placeCategories:(NSMutableArray*)categories {
    int x = 0;
    int y = 0;
    while (categories.count > 0) {
        NSString* category = [categories objectAtIndex:0];
        int blockSize = [category blocksCount:self.view];
        if ((NB_BLOCKS - x < blockSize)) {
            [self fillEmptyBlocks:NB_BLOCKS - x fromPosX:x andPosY:y];
            x = 0;
            y += 1;
        }
        
        [self addSOSCategory:category inPosX:x andPosY:y];
        
        x += blockSize;
        if (x >= NB_BLOCKS) {
            y += 1;
            x = 0;
        }
        
        [categories removeObjectAtIndex:0];
    }
    
    if (x < NB_BLOCKS) {
        [self fillEmptyBlocks:NB_BLOCKS - x fromPosX:x andPosY:y];        
    }
}

- (void)handleCategoryTapping:(UIGestureRecognizer *)sender {
    UILabel* category = (UILabel*)sender.view;
    NSLog(@"Category is tapped! (%@)", category.text);
}

#pragma mark Custom methods

-(void)startActivity {
    [self.activityIndicator startAnimating];
}

-(void)stopActivity {
    [self.activityIndicator stopAnimating];
}

-(void)fetchAnotherMessage {
    [self startActivity];
    
    NSURL* url = [[NSURL alloc] initWithString:@"http://kervern.me/v1/categories"];
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];
    messageReceiving = nil;
    
    self.currentConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    [request release];
    [url release];
}
- (void)dealloc {
    [activityIndicator release];
    [messageLabel release];
    [super dealloc];
}
@end
