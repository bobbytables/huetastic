//
//  HUBridgeUserViewController.h
//  Huetastic
//
//  Created by Robert Ross on 9/28/13.
//  Copyright (c) 2013 Creative Queries. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUBridge.h"

@interface HUBridgeUserViewController : UIViewController <HUBridgeDelegate>

@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) NSTimer *bridgeTimer;
@property (nonatomic, strong) HUBridge *bridge;

@end
