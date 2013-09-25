//
//  HULight.h
//  Huetastic
//
//  Created by Robert Ross on 9/24/13.
//  Copyright (c) 2013 Creative Queries. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HULight : NSObject

@property (nonatomic, strong) NSMutableDictionary *dictionary;
@property (nonatomic, strong) NSString *name;

-(void)initWithLightId:(NSString *)lightId;

@end
