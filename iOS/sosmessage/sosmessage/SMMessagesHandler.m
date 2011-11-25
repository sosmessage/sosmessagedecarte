//
//  SMMessagesHandler.m
//  sosmessage
//
//  Created by Arnaud K. on 14/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SMMessagesHandler.h"

@interface SMMessagesHandler () <NSURLConnectionDelegate> {
    @private
    id delegate;
}

+ (void)showUIAlert;

- (void)resetData;
- (void)startWorking;
- (void)stopWorking;

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
@end

@implementation SMMessagesHandler
@synthesize delegate;

NSMutableData* data;
NSURLConnection* currentConnection;

bool receiving = false;

#pragma mark Constructor
- (id)init {
    self = [super init];
    return self;
}

- (id)initWithDelegate:(id<SMMessageDelegate,NSObject>)pDelegate {
    self = [self init];
    if (self) {
        self.delegate = pDelegate;
    }
    return self;
}

#pragma mark Custom Methods
-(void)startWorking {
    [self resetData];
    receiving = true;
    [self.delegate startActivityFromMessageHandler:self];
}

-(void)stopWorking {
    if (receiving) {
        receiving = false;
        [self.delegate stopActivityFromMessageHandler:self];
    }
}

-(void)resetData {
    if (data) {
        data = nil;
    }
}

#pragma mark Requesting ....

- (void)requestUrl:(NSString*)url {
    if (receiving && currentConnection) {
        [currentConnection cancel];
        [currentConnection release];
    }
    
    NSURL* nsUrl = [[NSURL alloc] initWithString:url];
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:nsUrl];
    
    [self startWorking];
    currentConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    [request release];
    [nsUrl release];
}

- (void)requestCategories {
    [self requestUrl:[NSString stringWithFormat:@"%@/api/v1/categories", SM_URL]];
}

- (void)requestRandomMessageForCategory:(NSString*)aCategoryId {
    [self requestUrl:[NSString stringWithFormat:@"%@/api/v1/category/%@/message", SM_URL, aCategoryId]];
}

+(void)showUIAlert {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Erreur de connexion" message:@"Un probleme est survenu lors de la connexion au serveur de sosmessage" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [alert release];    
}

#pragma mark -
#pragma mark NSURLConnection methods
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self resetData];
    NSLog(@"%@", error);
    
    if ([self.delegate respondsToSelector:@selector(messageHandler:didFail:)]) {
        [self.delegate messageHandler:self didFail:error];
    } else {
        [SMMessagesHandler showUIAlert];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)dataChunk {
    if (!data) {
        data = [[NSMutableData alloc] initWithData:dataChunk];
    } else {
        [data appendData:dataChunk];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self stopWorking];
    
    if (!data) {
        [SMMessagesHandler showUIAlert];
        NSLog(@"Unable to fetch data ...");
        return;
    }
    
    NSError* error;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (!json) {
        NSLog(@"Error while parsing json object: %@", error);
    } 
    else if ([self.delegate respondsToSelector:@selector(messageHandler:didFinishWithJSon:)]) {
        [self.delegate messageHandler:self didFinishWithJSon:json];
    }
    [self resetData];
}

-(void)dealloc {
    [self stopWorking];
    [data release];
    currentConnection = nil;
    [super dealloc];
}
@end
