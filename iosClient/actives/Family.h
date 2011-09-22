//
//  Family.h
//  actives
//
//  Created by Sean Hess on 9/22/11.
//  Copyright (c) 2011 I.TV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Family : NSObject

+(double)lat:(NSDictionary*)family;
+(double)lon:(NSDictionary*)family;
+(NSString*)name:(NSDictionary*)family;
+(CLLocationCoordinate2D)coordinate:(NSDictionary*)family;

+(MKCoordinateRegion)centerRegionForFamilies:(NSArray*)families;

@end