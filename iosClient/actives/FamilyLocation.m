//
//  FamilyLocation.m
//  actives
//
//  Created by Sean Hess on 9/22/11.
//  Copyright (c) 2011 I.TV. All rights reserved.
//

#import "FamilyLocation.h"
#import "Family.h"

@implementation FamilyLocation

@synthesize family;

-(id)initWithFamily:(NSDictionary*)fam {
    if ((self = [super init])) {
        self.family = fam;
    }
    return self;
}

-(NSString*)title {
    return [Family name:self.family];
}

-(NSString*)subtitle {
    return @"Nothing Yet";
}

-(CLLocationCoordinate2D)coordinate {
    return [Family coordinate:self.family];
}

@end
