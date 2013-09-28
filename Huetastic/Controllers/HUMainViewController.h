//
//  HUMainViewController.h
//  Huetastic
//
//  Created by Robert Ross on 9/24/13.
//  Copyright (c) 2013 Creative Queries. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUBridge.h"

@interface HUMainViewController : UITableViewController <HUBridgeDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *lights;
@property (nonatomic, strong) HUBridge *bridge;

@end
