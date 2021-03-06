//
//  PeopleService.h
//  actives
//
//  Created by Sean Hess on 9/20/11.
//  Copyright (c) 2011 I.TV. All rights reserved.
//

// http://blog.cloudmade.com/2009/06/12/how-to-get-forward-geocoding-in-iphone-mapkit/
// http://www.raywenderlich.com/2847/introduction-to-mapkit-on-ios-tutorial

#import <Foundation/Foundation.h>
#import "Service.h"

@interface PeopleService : Service

+(void)loadPeople:(void(^)(NSArray*))callback;
+(void)loadFamilies:(void(^)(NSArray*))callback;
+(void)loadFamily:(NSDictionary*)family callback:(void(^)(NSMutableDictionary*))callback;

+(void)saveNote:(NSString*)note family:(NSDictionary*)family callback:(void(^)(NSObject*))callback;

@end
