//
//  Service.h
//  actives
//
//  Created by Sean Hess on 9/22/11.
//  Copyright (c) 2011 I.TV. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Domain @"http://dmeo.seanhess.net:2555"

@interface Service : NSObject

+(void)loadJSONFromBundle:(NSString*)fileName callback:(void(^)(NSArray*))callback;
+(void)loadJSONFromURL:(NSString*)url method:(NSString*)method callback:(void(^)(id))callback;
+(void)loadJSONFromURL:(NSString*)urlString method:(NSString*)method body:(NSDictionary*)body callback:(void(^)(id))callback;

@end
