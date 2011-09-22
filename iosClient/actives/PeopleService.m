//
//  PeopleService.m
//  actives
//
//  Created by Sean Hess on 9/20/11.
//  Copyright (c) 2011 I.TV. All rights reserved.
//

#import "PeopleService.h"
#import "ASIHTTPRequest.h"
#import "Family.h"

@implementation PeopleService

+(void)loadPeople:(void(^)(NSArray*))callback {
    // Load from file
    
    [self loadJSONFromBundle:@"people" callback:callback];
}

+(void)loadFamilies:(void (^)(NSArray *))callback {
    [self loadJSONFromURL:@"/families" method:@"GET" callback:^(NSArray * array) {
        NSMutableArray * newArray = [NSMutableArray array];
        
        for (NSDictionary * dict in array)
            [newArray addObject:[NSMutableDictionary dictionaryWithDictionary:dict]];
            
        callback(newArray);
    }];
}

+(void)loadFamily:(NSDictionary*)family callback:(void(^)(NSMutableDictionary*))callback {
    [self loadJSONFromURL:[NSString stringWithFormat:@"/family/%@", [Family uid:family]] method:@"GET" callback:^(NSDictionary * family) {
        callback([NSMutableDictionary dictionaryWithDictionary:family]);
    }];
}

+(void)saveNote:(NSString*)note family:(NSDictionary*)family callback:(void(^)(NSObject*))callback {
    [self loadJSONFromURL:[NSString stringWithFormat:@"/family/%@/note", [Family uid:family]] method:@"POST" body:[NSDictionary dictionaryWithObject:note forKey:@"note"] callback:callback];
}

@end
