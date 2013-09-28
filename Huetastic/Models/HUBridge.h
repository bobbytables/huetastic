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

@optional

-(void)didFinishRetrievingBridgeIp:(HUBridge *)bridge;
-(void)didFinishRetrievingLights:(NSArray *)lights;
-(void)failedRetrievingBridgeIp:(HUBridge *)bridge;
-(void)didCreateUser:(HUBridge *)bridge username:(NSString *)username;

@end

@interface HUBridge : NSObject

@property (nonatomic, strong) NSString *bridgeIp;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) id <HUBridgeDelegate>delegate;
@property (nonatomic, strong) NSArray *lights;

-(id)initWithDelegate:(id)delegate;
-(id)initWithUsername:(NSString *)username delegate:(id)delegate;

-(void)findBridgeIp;
-(void)retrieveLights;
-(void)createUser:(NSString *)username;

@end
