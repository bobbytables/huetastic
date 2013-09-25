//
//  HUMainViewController.m
//  Huetastic
//
//  Created by Robert Ross on 9/24/13.
//  Copyright (c) 2013 Creative Queries. All rights reserved.
//

#import "HUMainViewController.h"
#import "HUBridge.h"


@implementation HUMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Huetastic";
    
    HUBridge *bridge = [[HUBridge alloc] initWithDelegate:self];
}

-(void)didFinishRetrievingBridgeIp:(HUBridge *)bridge {
    NSLog(@"%@", [bridge allLights]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
