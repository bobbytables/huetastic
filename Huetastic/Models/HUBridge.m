//
//  HUBridge.m
//  Huetastic
//
//  Created by Robert Ross on 9/24/13.
//  Copyright (c) 2013 Creative Queries. All rights reserved.
//

#import "HUBridge.h"
#import "HULight.h"
#import <AFNetworking/AFNetworking.h>

@implementation HUBridge

static HUBridge *sharedBridge;

//+ (void)initialize
//{
//    static BOOL initialized = NO;
//    if(!initialized)
//    {
//        initialized = YES;
//        sharedBridge = [[HUBridge alloc] init];
//    }
//}
//
//+(instancetype)sharedBridge {
//    return sharedBridge;
//}

-(id)initWithDelegate:(id)delegate {
    if(self = [self init]){
        self.delegate = delegate;
        [self findBridgeIp];
    }
    
    return self;
}

-(void)findBridgeIp {
    NSLog(@"Finding bridge IP");
    NSURL *URL = [NSURL URLWithString:@"http://www.meethue.com/api/nupnp"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                         initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *bridgeInfo = [responseObject objectAtIndex:0];
        self.bridgeIp = [bridgeInfo objectForKey:@"internalipaddress"];
        NSLog(@"%@", self.bridgeIp);
        
        [self.delegate didFinishRetrievingBridgeIp:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    [operation start];
    [operation waitUntilFinished];
}

-(NSMutableArray *)allLights {
    NSMutableArray *lights = [NSMutableArray array];
    
    NSString *formattedUrl = [NSString stringWithFormat:@"http://%@/api/bobbytables/lights", self.bridgeIp];
    NSURL *URL = [NSURL URLWithString:formattedUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                         initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Found lights: %@", responseObject);
        
        for(id key in responseObject){
            NSDictionary *lightInfo = [responseObject objectForKey:key];
            HULight *light = [[HULight alloc] init];
            light.name = [lightInfo objectForKey:@"name"];
            
            [lights addObject:light];
            
            NSString *lightString = [NSString stringWithFormat:@"http://%@/api/bobbytables/lights/%@/state", self.bridgeIp, key];
            NSURL *URL = [NSURL URLWithString:lightString];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
            [request setHTTPMethod:@"PUT"];
            
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                                 initWithRequest:request];
            
            NSDictionary *data = @{@"on": [NSNumber numberWithBool:NO]};
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                               options:NSJSONWritingPrettyPrinted
                                                                 error:nil];
            
            NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
            
            operation.responseSerializer = [AFJSONResponseSerializer serializer];
            [request setHTTPBody:jsonData];
            
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@", responseObject);
            } failure:nil];
            
            [operation start];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    [operation start];
    
    return lights;
}

@end
