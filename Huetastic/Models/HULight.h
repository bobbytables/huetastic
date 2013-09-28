//
//  HULight.h
//  Huetastic
//
//  Created by Robert Ross on 9/24/13.
//  Copyright (c) 2013 Creative Queries. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HUBridge.h"

@class HULight;

@protocol HULightProtocol <NSObject>

-(void)didLoadingState:(HULight *)light;

@end

@interface HULight : NSObject

@property (nonatomic, strong) NSMutableDictionary *state;
@property (nonatomic, strong) HUBridge *bridge;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *lightId;
@property (nonatomic) id <HULightProtocol>delegate;

-(id)initWithLightId:(id)lightId bridge:(HUBridge *)bridge;
-(void)retrieveLightState;
-(void)toggleOnOff;
-(void)setPower:(BOOL)on;

@end
