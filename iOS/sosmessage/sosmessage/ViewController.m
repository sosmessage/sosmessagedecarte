//
//  ViewController.m
//  sosmessage
//
//  Created by Arnaud K. on 30/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "SMDetailViewController.h"

@implementation ViewController
@synthesize categories;
@synthesize messageHandler;

static char sosMessageKey;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    id iMessageHandler = [[SMMessagesHandler alloc] initWithDelegate:self];
    self.messageHandler = iMessageHandler;
    [iMessageHandler release];
    
    [self.messageHandler requestCategories];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCategories) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self becomeFirstResponder];
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark Category handling

- (void)addSOSCategory:(NSDictionary*)category inPosX:(int)posX andPosY:(int)posY {
    float blockSize = self.view.bounds.size.width / NB_BLOCKS;
    NSString* label = [category objectForKey:@"name"];
    
    float rectX = floorf(blockSize * posX);
    //float rectY = posY; //origin y will be re-calculate after views are generated
    float rectWidth = ceilf([label sizeForBlocksForView:self.view]);
    float rectHeight = 1; //arbitrary set to 1
    
    //NSLog(@"Place label (%@) at (%.2f;%.2f) with size (%.2f;%.2f)", label, rectX, rectY, rectWidth, rectHeight);
    
    UILabel* uiLabel = [[[UILabel alloc] initWithFrame:CGRectMake(rectX, posY, rectWidth, rectHeight)] autorelease];
    uiLabel.backgroundColor = [UIColor colorWithHue:label.hue saturation:0.55 brightness:0.9 alpha:1.0];
    uiLabel.text = [label capitalizedString];
    uiLabel.font = SOSFONT;
    uiLabel.textAlignment = UITextAlignmentCenter;
    uiLabel.userInteractionEnabled = YES;
    
    objc_setAssociatedObject(uiLabel, &sosMessageKey, category, 0);

    UITapGestureRecognizer *categoryTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCategoryTapping:)];
    [uiLabel addGestureRecognizer:categoryTap];
    [categoryTap release];
    
    [self.view addSubview:uiLabel];
}

- (void)fillEmptyBlocks:(int)nb fromPosX:(int)posX andPosY:(int)posY {
    float blockSize = self.view.bounds.size.width / NB_BLOCKS;
    NSLog(@"Bounds width: %.2f and Frame width: %.2f", self.view.bounds.size.width, self.view.frame.size.width);
    
    float rectX = floorf(blockSize * posX);
    //float rectY = posY; //origin y will be re-calculate after views are generated
    float rectWidth = blockSize * nb;
    float rectHeight = 1; //arbitrary set to 1
    
    //NSLog(@"Fill %d blocks at (%.2f;%.2f) with size (%.2f;%.2f)", nb, rectX, rectY, rectWidth, rectHeight);
    UILabel* emptyBlocks = [[[UILabel alloc] initWithFrame:CGRectMake(rectX, posY, rectWidth, rectHeight)] autorelease];
    
    float hue = (rand()%24) / 24.0;
    emptyBlocks.backgroundColor = [UIColor colorWithHue:hue saturation:0.2 brightness:1 alpha:1.0];
    
    [self.view addSubview:emptyBlocks];
}

- (void)refreshCategories {
    [self removeCategoriesLabel];
    
    NSMutableArray* workingCategories = [[NSMutableArray alloc] initWithArray:categories];
    
    int x = 0;
    int y = 0;
    while (workingCategories.count > 0) {
        NSDictionary* category = [workingCategories objectAtIndex:0];
        int blockSize = [[category objectForKey:@"name"] blocksCount:self.view];
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
        
        [workingCategories removeObjectAtIndex:0];
    }
    
    if (x < NB_BLOCKS && x > 0) {
        [self fillEmptyBlocks:NB_BLOCKS - x fromPosX:x andPosY:y];        
    }
    [workingCategories release];
    
    if (x == 0) {
        y -= 1;
    }
    float fitHeight =  self.view.bounds.size.height / (y + 1);
    for (UIView* subView in self.view.subviews) {
        if ([subView isKindOfClass:[UILabel class]] && subView.tag == 0) {
            subView.frame = CGRectMake(subView.frame.origin.x, subView.frame.origin.y * fitHeight, subView.frame.size.width, fitHeight);
        }
    }
}

-(void)removeCategoriesLabel {
    for (UIView* subView in self.view.subviews) {
        if ([subView isKindOfClass:[UILabel class]] && subView.tag == 0) {
            [subView removeFromSuperview];
        }
    }
}

- (void)handleCategoryTapping:(UIGestureRecognizer *)sender {
    UILabel* uilabel = (UILabel*)sender.view;
    NSDictionary* category = (NSDictionary*)objc_getAssociatedObject(uilabel, &sosMessageKey);
    
    NSLog(@"Category added: %@", category);
    
    CGFloat hue;
    [uilabel.backgroundColor getHue:&hue saturation:nil brightness:nil alpha:nil];
    
    NSLog(@"Hue color: %.3f", hue);
    SMDetailViewController* detail = [[SMDetailViewController alloc] initWithCategory:category];
    detail.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:detail animated:true];
    [detail release];
}

#pragma mark NSMessageHandlerDelegate

- (void)startActivityFromMessageHandler:(SMMessagesHandler *)messageHandler
{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    hud.labelText = @"sosmessage";
}

- (void)stopActivityFromMessageHandler:(SMMessagesHandler *)messageHandler
{
    [MBProgressHUD hideHUDForView:self.view animated:true];
}

- (void)messageHandler:(SMMessagesHandler *)messageHandler didFinishWithJSon:(id)result
{
    if ([result objectForKey:@"count"] > 0) {
        self.categories = [[[NSMutableArray alloc] initWithArray:[result objectForKey:@"items"]] autorelease];
        [self refreshCategories];
    }
}

#pragma mark Custom methods

- (void)dealloc {
    [categories release];
    [messageHandler release];
    [super dealloc];
}
@end
