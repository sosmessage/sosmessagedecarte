//
//  SMDetailViewController.m
//  sosmessage
//
//  Created by Arnaud K. on 06/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SMDetailViewController.h"
#import <CoreText/CoreText.h>

@implementation SMDetailViewController
@synthesize titleImage;
@synthesize messageImage;

float baseHue;
NSString* tmpMessage = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque commodo aliquam semper. Donec volutpat, metus in vulputate mattis, massa massa porttitor nisl, non aliquam nibh elit a enim. Duis ac enim turpis, ut blandit leo. Quisque vulputate blandit dapibus. Suspendisse pretium, felis vel aliquam vestibulum, magna elit eleifend dolor, molestie fermentum lectus massa ut elit. Cras eget neque mauris, ut consequat augue. Donec vel facilisis eros.";

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

-(void)viewWillAppear:(BOOL)animated 
{
    [self renderTitle];
    [self fetchAMessage];
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setTitleImage:nil];
    [self setMessageImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)dealloc {
    [titleImage release];
    [messageImage release];
    [super dealloc];
}

#pragma mark Custom methods

- (void)renderTitle {
    UIGraphicsBeginImageContext(self.titleImage.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGAffineTransform flipTransform = CGAffineTransformMake( 1, 0, 0, -1, 0, self.titleImage.frame.size.height);
    CGContextConcatCTM(context, flipTransform);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.titleImage.bounds);
    
    NSString *header = @"sosmessagedecarte\ndevisite";
    NSInteger _stringLength=[header length];
    
    CFStringRef string =  (CFStringRef) header;
    CFMutableAttributedStringRef attrString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
    CFAttributedStringReplaceString (attrString,CFRangeMake(0, 0), string);
    
    CGColorRef _black=[UIColor blackColor].CGColor;
    CGColorRef _hue=[UIColor colorWithHue:baseHue saturation:0.9 brightness:0.7 alpha:1].CGColor;
    
    CFAttributedStringSetAttribute(attrString, CFRangeMake(0, 3),kCTForegroundColorAttributeName, _black);
    CFAttributedStringSetAttribute(attrString, CFRangeMake(3, 7),kCTForegroundColorAttributeName, _hue);
    CFAttributedStringSetAttribute(attrString, CFRangeMake(10, 2),kCTForegroundColorAttributeName, _black);
    CFAttributedStringSetAttribute(attrString, CFRangeMake(12, 5),kCTForegroundColorAttributeName, _hue);
    CFAttributedStringSetAttribute(attrString, CFRangeMake(18, 2),kCTForegroundColorAttributeName, _black);
    CFAttributedStringSetAttribute(attrString, CFRangeMake(20, 6),kCTForegroundColorAttributeName, _hue);
    
    CTFontRef font = CTFontCreateWithName((CFStringRef)@"Helvetica", 20, nil);
    CFAttributedStringSetAttribute(attrString,CFRangeMake(0, _stringLength),kCTFontAttributeName,font);
    
    CTTextAlignment alignement = kCTRightTextAlignment;
    CTParagraphStyleSetting settings[] = {kCTParagraphStyleSpecifierAlignment, sizeof(alignement), &alignement};
    CTParagraphStyleRef paragraph = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));
    CFAttributedStringSetAttribute(attrString, CFRangeMake(0, _stringLength), kCTParagraphStyleAttributeName, paragraph);
    CFRelease(paragraph);
    
    // Create the framesetter with the attributed string.
    CTFramesetterRef framesetter =
    CTFramesetterCreateWithAttributedString(attrString);
    CFRelease(attrString);
    
    // Create the frame and draw it into the graphics context
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(framesetter);
    CTFrameDraw(frame, context);
    CFRelease(frame);
    CFRelease(path);
    
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.titleImage.image = result;
}

- (void)renderMessage {
    UIGraphicsBeginImageContext(self.messageImage.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGAffineTransform flipTransform = CGAffineTransformMake( 1, 0, 0, -1, 0, self.messageImage.frame.size.height);
    CGContextConcatCTM(context, flipTransform);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.messageImage.bounds);
    NSInteger _stringLength=[tmpMessage length];
    
    CFMutableAttributedStringRef attrString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
    CFAttributedStringReplaceString (attrString,CFRangeMake(0, 0), (CFStringRef)tmpMessage);
    
    CGColorRef _hue=[UIColor colorWithHue:baseHue saturation:0.9 brightness:0.7 alpha:1].CGColor;
    CFAttributedStringSetAttribute(attrString, CFRangeMake(0, 1),kCTForegroundColorAttributeName, _hue);
    
    CTFontRef font = CTFontCreateWithName((CFStringRef)@"Helvetica", 16, nil);
    CFAttributedStringSetAttribute(attrString,CFRangeMake(0, _stringLength),kCTFontAttributeName,font);
    
    /** TODO find a way to reduce the leading
     font = CTFontCreateWithName((CFStringRef)@"Helvetica", 35, nil);
     CFAttributedStringSetAttribute(attrString,CFRangeMake(0, 1),kCTFontAttributeName,font);
     */
    
    CGFloat indent = 25.0f;
    CTTextAlignment alignement = kCTJustifiedTextAlignment;
    CTParagraphStyleSetting settings[] = {kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(indent), &indent, kCTParagraphStyleSpecifierAlignment, sizeof(alignement), &alignement};
    CTParagraphStyleRef paragraph = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));
    CFAttributedStringSetAttribute(attrString, CFRangeMake(0, _stringLength), kCTParagraphStyleAttributeName, paragraph);
    CFRelease(paragraph);
    
    // Create the framesetter with the attributed string.
    CTFramesetterRef framesetter =
    CTFramesetterCreateWithAttributedString(attrString);
    CFRelease(attrString);
    
    // Create the frame and draw it into the graphics context
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(framesetter);
    CTFrameDraw(frame, context);
    CFRelease(frame);
    CFRelease(path);
    
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.messageImage.image = result;
}

-(void)fetchAMessage {
    [self renderMessage];
}

@end
