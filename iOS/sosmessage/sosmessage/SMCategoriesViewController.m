//
//  ViewController.m
//  sosmessage
//
//  Created by Arnaud K. on 30/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SMCategoriesViewController.h"
#import "SMMessageViewController.h"
#import "SMAboutViewController.h"

@interface SMCategoriesViewController () {
    
}
-(BOOL)isSubViewCategoryPart:(UIView*) view;
-(void)addMailPropositionBlockinPosY:(int)posY;

- (void)handleCategoryTapping:(UIGestureRecognizer *)sender;
- (void)handleMailPropositionTapping:(UIGestureRecognizer *)sender;
@end

@implementation SMCategoriesViewController
@synthesize infoButton;
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
    [self setInfoButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCategories) name:UIDeviceOrientationDidChangeNotification object:nil];
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
    return NO;
}

#pragma mark Category handling

-(UILabel*)buildUILabelForBlock:(int)nbBlocks inPosX:(int)posX andPosY:(int)posY {
    float blockSize = self.view.bounds.size.width / NB_BLOCKS;

    float rectX = floorf(blockSize * posX);
    //float rectY = posY; //origin y will be re-calculate after views are generated
    float rectWidth = ceilf(blockSize * nbBlocks);
    float rectHeight = 1; //arbitrary set to 1
    
    //NSLog(@"Place label (%@) at (%.2f;%.2f) with size (%.2f;%.2f)", label, rectX, rectY, rectWidth, rectHeight);
    
    UILabel* uiLabel = [[UILabel alloc] initWithFrame:CGRectMake(rectX, posY, rectWidth, rectHeight)];
    return [uiLabel autorelease];
}

- (void)addSOSCategory:(NSDictionary*)category inPosX:(int)posX andPosY:(int)posY {
    NSString* label = [category objectForKey:CATEGORY_NAME];
    
    UILabel* uiLabel = [self buildUILabelForBlock:[label blocksCount:self.view] inPosX:posX andPosY:posY];
                        
    uiLabel.backgroundColor = [UIColor colorWithHue:label.hue saturation:0.55 brightness:0.9 alpha:1.0];
    uiLabel.text = [label capitalizedString];
    uiLabel.font = SOSFONT;
    uiLabel.textColor = [UIColor colorWithHue:label.hue saturation:1.0 brightness:0.3 alpha:1.0];
    uiLabel.textAlignment = UITextAlignmentCenter;
    uiLabel.userInteractionEnabled = YES;
    uiLabel.alpha = 0.90;
    
    objc_setAssociatedObject(uiLabel, &sosMessageKey, category, 0);

    UITapGestureRecognizer *categoryTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCategoryTapping:)];
    [uiLabel addGestureRecognizer:categoryTap];
    [categoryTap release];
    
    [self.view insertSubview:uiLabel belowSubview:self.infoButton];
    
    
    UIImageView* enveloppe = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"enveloppe.png"]];
    enveloppe.frame = uiLabel.frame;
    [self.view insertSubview:enveloppe belowSubview:uiLabel];
    [enveloppe release];
}

- (void)fillEmptyBlocks:(int)nb fromPosX:(int)posX andPosY:(int)posY {
    NSLog(@"Bounds width: %.2f and Frame width: %.2f", self.view.bounds.size.width, self.view.frame.size.width);
    UILabel* emptyBlocks = [self buildUILabelForBlock:nb inPosX:posX andPosY:posY];
    
    float hue = (rand()%24) / 24.0;
    emptyBlocks.backgroundColor = [UIColor colorWithHue:hue saturation:0.05 brightness:0.9 alpha:1.0];
    
    [self.view insertSubview:emptyBlocks belowSubview:self.infoButton];
}

-(void)addMailPropositionBlockinPosY:(int)posY {
    NSString* label = @"Proposez vos messages";
    UILabel* uiLabel = [self buildUILabelForBlock:[label blocksCount:self.view] inPosX:0 andPosY:posY];
    uiLabel.backgroundColor = [UIColor colorWithHue:label.hue saturation:0.55 brightness:0.9 alpha:1.0];
    uiLabel.text = [label capitalizedString];
    uiLabel.font = SOSFONT;
    uiLabel.textColor = [UIColor colorWithHue:label.hue saturation:1.0 brightness:0.3 alpha:1.0];
    uiLabel.textAlignment = UITextAlignmentCenter;
    uiLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *categoryTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleMailPropositionTapping:)];
    [uiLabel addGestureRecognizer:categoryTap];
    [categoryTap release];
    
    [self.view insertSubview:uiLabel belowSubview:self.infoButton];
}

- (void)refreshCategories {
    NSLog(@"Categories refreshed");
    [self removeCategoriesLabel];
    
    NSMutableArray* workingCategories = [[NSMutableArray alloc] initWithArray:categories];
    
    int x = 0;
    int y = 0;
    while (workingCategories.count > 0) {
        NSDictionary* category = [workingCategories objectAtIndex:0];
        int blockSize = [[category objectForKey:CATEGORY_NAME] blocksCount:self.view];
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
        y++;
    }
    [workingCategories release];
    
    if ([MFMailComposeViewController canSendMail]) {
        [self addMailPropositionBlockinPosY:y];
    }
    else {
        /* To be re-enabled by default when the propositions btn will be better handled */
        if (x == 0) {
            y -= 1;
        }
    }
    float fitHeight =  ceilf(self.view.bounds.size.height / (y + 1));
    for (UIView* subView in self.view.subviews) {
        if (subView.tag != 0) {
            continue;
        }
        
        if ([subView isKindOfClass:[UILabel class]]) {
            subView.frame = CGRectMake(subView.frame.origin.x, floorf(subView.frame.origin.y * fitHeight), subView.frame.size.width, fitHeight);
        } else if ([subView isKindOfClass:[UIImageView class]]) {
            UIImage* img = [(UIImageView*)subView image];
            float imgRation = img.size.height / img.size.width;
            subView.frame = CGRectMake(subView.frame.origin.x, floorf(subView.frame.origin.y * fitHeight), subView.frame.size.width, imgRation * subView.frame.size.width);
        }
    }
}

-(BOOL)isSubViewCategoryPart:(UIView*) view {
    return ([view isKindOfClass:[UILabel class]] || [view isKindOfClass:[UILabel class]]) && view.tag == 0;
}

-(void)removeCategoriesLabel {
    for (UIView* subView in self.view.subviews) {
        if ([self isSubViewCategoryPart:subView]) {
            [subView removeFromSuperview];
        }
    }
}

- (void)handleMailPropositionTapping:(UIGestureRecognizer *)sender {
    MFMailComposeViewController* mailer = [[MFMailComposeViewController alloc] init];
    [mailer setSubject:@"[sosmessage] Proposition de message"];
    NSArray *toRecipients = [NSArray arrayWithObjects:SM_EMAIL, nil];
    [mailer setToRecipients:toRecipients];
    
    mailer.mailComposeDelegate = self;
    [self presentModalViewController:mailer animated:true];
    
    [mailer release];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissModalViewControllerAnimated:true];
}

- (void)handleCategoryTapping:(UIGestureRecognizer *)sender {
    UILabel* uilabel = (UILabel*)sender.view;
    NSDictionary* category = (NSDictionary*)objc_getAssociatedObject(uilabel, &sosMessageKey);
    
    NSLog(@"Category added: %@", category);
    
    CGFloat hue;
    [uilabel.backgroundColor getHue:&hue saturation:nil brightness:nil alpha:nil];
    
    NSLog(@"Hue color: %.3f", hue);
    SMMessageViewController* detail = [[SMMessageViewController alloc] initWithCategory:category];
    detail.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:detail animated:true];
    [detail release];
}

- (IBAction)aboutPressed:(id)sender {
    SMAboutViewController* about = [[SMAboutViewController alloc] initWithNibName:@"SMAboutViewController" bundle:nil];
    about.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:about animated:true];
    [about release];
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
    if ([result objectForKey:CATEGORIES_COUNT] > 0) {
        self.categories = [[[NSMutableArray alloc] initWithArray:[result objectForKey:CATEGORIES_ITEMS]] autorelease];
        [self refreshCategories];
    }
}

#pragma mark Custom methods

- (void)dealloc {
    [categories release];
    [messageHandler release];
    [infoButton release];
    [super dealloc];
}
@end
