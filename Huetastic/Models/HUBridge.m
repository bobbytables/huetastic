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

-(id)initWithDelegate:(id)delegate {
    if(self = [self init]){
        self.delegate = delegate;
        [self findBridgeIp];
    }
    
    return self;
}

-(id)initWithUsername:(NSString *)username delegate:(id)delegate {
    if(self = [super init]){
        self.username = username;
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
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
        if(responseObject.count > 0){
            NSDictionary *bridgeInfo = [responseObject objectAtIndex:0];
            self.bridgeIp = [bridgeInfo objectForKey:@"internalipaddress"];
            NSLog(@"%@", self.bridgeIp);
            
            [self.delegate didFinishRetrievingBridgeIp:self];
        } else {
            [self.delegate failedRetrievingBridgeIp:self];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    [operation start];
    [operation waitUntilFinished];
}

-(void)createUser:(NSString *)username {
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api", self.bridgeIp]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                         initWithRequest:request];
    
    NSDictionary *data = @{@"devicetype": @"huetastic", @"username": username};
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [request setHTTPBody:jsonData];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *response = responseObject[0];
        
        if([response objectForKey:@"success"]){
            [self.delegate didCreateUser:self username:username];
        }
    } failure:nil];
    
    [operation start];
}


-(void)retrieveLights {
    NSString *formattedUrl = [NSString stringWithFormat:@"http://%@/api/%@/lights", self.bridgeIp, self.username];
    NSURL *URL = [NSURL URLWithString:formattedUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                         initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSMutableArray *mutableLights = [NSMutableArray array];
        
        for(id key in responseObject){
            NSString *lightId = key;
            
            NSDictionary *lightInfo = [responseObject objectForKey:lightId];
            
            HULight *light = [[HULight alloc] initWithLightId:lightId bridge:self];
            light.name = [lightInfo objectForKey:@"name"];
            
            [mutableLights addObject:light];
        }
        self.lights = [NSArray arrayWithArray:mutableLights];
        [self.delegate didFinishRetrievingLights:self.lights];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    [operation start];
}

@end
