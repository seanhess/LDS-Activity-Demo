//
//  PeopleService.m
//  actives
//
//  Created by Sean Hess on 9/20/11.
//  Copyright (c) 2011 I.TV. All rights reserved.
//

#import "PeopleService.h"
#import "ASIHTTPRequest.h"

@implementation PeopleService

+(void)loadPeople:(void(^)(NSArray*))callback {
    // Load from file
    
    [self loadJSONFromBundle:@"people" callback:callback];
}

+(void)loadFamilies:(void (^)(NSArray *))callback {
    [self loadJSONFromURL:@"/families" method:@"GET" callback:callback];
}
@end
