//
//  HULight.m
//  Huetastic
//
//  Created by Robert Ross on 9/24/13.
//  Copyright (c) 2013 Creative Queries. All rights reserved.
//

#import "HULight.h"
#import <AFNetworking/AFNetworking.h>

@implementation HULight

- (id)initWithLightId:(NSString *)lightId bridge:(HUBridge *)bridge {
    if(self = [self init]){
        self.bridge = bridge;
        self.lightId = lightId;
    }
    
    [self retrieveLightState];
    
    return self;
}

-(void)retrieveLightState {
    NSString *lightStateUrl = [NSString stringWithFormat:@"http://%@/api/%@/lights/%@",
                               self.bridge.bridgeIp, self.bridge.username, self.lightId];
    
    NSURL *URL = [NSURL URLWithString:lightStateUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                         initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, NSMutableDictionary *responseObject) {
        NSLog(@"Retrieved state for light #%@", self.lightId);
        
        self.state = [NSMutableDictionary dictionaryWithDictionary:[responseObject objectForKey:@"state"]];
        [self.delegate didLoadingState:self];
    } failure:nil];
    
    [operation start];
}

-(void)toggleOnOff {
    BOOL currentSwitch = [(NSNumber *)[self.state objectForKey:@"on"] boolValue];
    BOOL nextSwitch = currentSwitch ? NO : YES;
    
    [self setPower:nextSwitch];
}

-(void)setPower:(BOOL)on {
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/%@/lights/%@/state",
                                       self.bridge.bridgeIp, self.bridge.username, self.lightId]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"PUT"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                         initWithRequest:request];
    
    
    NSDictionary *data = @{@"on": [NSNumber numberWithBool:on]};
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [request setHTTPBody:jsonData];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.state setObject:[NSNumber numberWithBool:on] forKey:@"on"];
    } failure:nil];
    
    [operation start];
}

@end
