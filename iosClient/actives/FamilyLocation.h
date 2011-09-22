//
//  FamilyLocation.h
//  actives
//
//  Created by Sean Hess on 9/22/11.
//  Copyright (c) 2011 I.TV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Family.h"

@interface FamilyLocation : NSObject <MKAnnotation>

@property (strong, nonatomic) NSDictionary * family;

-(id)initWithFamily:(NSDictionary*)family;

@end
