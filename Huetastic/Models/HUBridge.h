//
//  HUBridge.h
//  Huetastic
//
//  Created by Robert Ross on 9/24/13.
//  Copyright (c) 2013 Creative Queries. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HUBridge;

@protocol HUBridgeDelegate <NSObject>

-(void)didFinishRetrievingBridgeIp:(HUBridge *)bridge;

@end

@interface HUBridge : NSObject

@property (nonatomic, strong) NSString *bridgeIp;
@property (nonatomic, strong) id <HUBridgeDelegate>delegate;

-(void)findBridgeIp;
-(NSMutableArray *)allLights;
-(id)initWithDelegate:(id)delegate;

@end
