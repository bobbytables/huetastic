//
//  HUMainViewController.m
//  Huetastic
//
//  Created by Robert Ross on 9/24/13.
//  Copyright (c) 2013 Creative Queries. All rights reserved.
//

#import "HUMainViewController.h"
#import "HUBridge.h"
#import "HULight.h"

@implementation HUMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Huetastic";
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"bridgeUsername"];
    
    self.bridge = [[HUBridge alloc] initWithUsername:username delegate:self];
    self.lights = [NSArray array];
    
    [self setupNavigationBar];
}

-(void)setupNavigationBar {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"All Off"
                                                                              style:UIBarButtonSystemItemAction
                                                                             target:self
                                                                             action:@selector(turnAllLightsOff)];
}

-(void)turnAllLightsOff {
    for(HULight *light in self.lights){
        [light setPower:NO];
    }
}

-(void)didFinishRetrievingBridgeIp:(HUBridge *)bridge {
    [bridge retrieveLights];
}

-(void)didFinishRetrievingLights:(NSArray *)lights {
    self.lights = lights;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.lights count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LightCell"];
    
    HULight *light = [self.lights objectAtIndex:indexPath.row];
    cell.textLabel.text = light.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HULight *light = [self.lights objectAtIndex:indexPath.row];
    [light toggleOnOff];
}

@end
