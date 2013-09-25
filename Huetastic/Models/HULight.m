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

- (void)initWithLightId:(id)lightId {
    NSURL *URL = [NSURL URLWithString:@"http://192.168.1.148/api/bobbytables/lights/1/state"];
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

}

@end
