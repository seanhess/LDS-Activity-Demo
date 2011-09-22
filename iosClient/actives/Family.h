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
+(NSString*)uid:(NSDictionary*)family;
+(NSString*)name:(NSDictionary*)family;
+(BOOL)isActive:(NSDictionary*)family;
+(NSString*)status:(NSDictionary*)family;
+(NSString*)fullAddress:(NSDictionary*)family;
+(NSArray*)people:(NSDictionary*)family;
+(NSArray*)notes:(NSDictionary*)family;
+(CLLocationCoordinate2D)coordinate:(NSDictionary*)family;

+(MKCoordinateRegion)centerRegionForFamilies:(NSArray*)families;


+(void)addNote:(NSString*)note family:(NSMutableDictionary*)family;



+(NSString*)fullName:(NSDictionary*)person;
+(NSString*)birthDate:(NSDictionary*)person;
+(NSString*)gender:(NSDictionary*)person;

@end
