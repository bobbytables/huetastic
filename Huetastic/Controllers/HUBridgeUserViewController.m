//
//  HUBridgeUserViewController.m
//  Huetastic
//
//  Created by Robert Ross on 9/28/13.
//  Copyright (c) 2013 Creative Queries. All rights reserved.
//

#import "HUBridgeUserViewController.h"

@implementation HUBridgeUserViewController

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
    [self setupViews];
    
    self.bridge = [[HUBridge alloc] initWithDelegate:self];
}

-(void)failedRetrievingBridgeIp:(HUBridge *)bridge {
    self.infoLabel.text = @"Could not find bridge on your network. Are you connected to the WiFi network the bridge is on?";
    [self.infoLabel sizeToFit];
}

-(void)didFinishRetrievingBridgeIp:(HUBridge *)bridge {
    self.infoLabel.text = @"Please press the button on your Hue bridge to continue...";
    [self.infoLabel sizeToFit];
    
    self.bridgeTimer = [NSTimer scheduledTimerWithTimeInterval:3
                                                        target:self
                                                      selector:@selector(createUser)
                                                      userInfo:nil
                                                       repeats:YES];
}

-(void)createUser {
    NSLog(@"Attempting to create a user");
    [self.bridge createUser:[self randomUsername]];
}

-(void)didCreateUser:(HUBridge *)bridge username:(NSString *)username {
    [self.bridgeTimer invalidate];
    
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"bridgeUsername"];
    
    self.infoLabel.text = @"Created user!";
    [self.infoLabel sizeToFit];
}

-(void)setupViews {
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 300, 100)];
    self.infoLabel.numberOfLines = 0;
    
    [self.view addSubview:self.infoLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Random string generation for users

-(NSString *)randomUsername {
    NSString *alphabet = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    
    NSMutableString *s = [NSMutableString stringWithCapacity:8];
    for (NSUInteger i = 0U; i < 8; i++) {
        u_int32_t r = arc4random() % [alphabet length];
        unichar c = [alphabet characterAtIndex:r];
        [s appendFormat:@"%C", c];
    }
    
    return [NSString stringWithString:s];
}

@end
