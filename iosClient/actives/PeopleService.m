//
//  PeopleService.m
//  actives
//
//  Created by Sean Hess on 9/20/11.
//  Copyright (c) 2011 I.TV. All rights reserved.
//

#import "PeopleService.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"

@implementation PeopleService

+(void)loadJSON:(NSString*)fileName callback:(void(^)(NSArray*))callback {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];  
    NSData * fileData = [NSData dataWithContentsOfFile:filePath];
    
    SBJsonParser * parser = [SBJsonParser new];
    
    NSArray * parsed = [parser objectWithData:fileData];
    callback(parsed);
}

+(void)loadPeople:(void(^)(NSArray*))callback {
    // Load from file
    
    [self loadJSON:@"people" callback:callback];
}

+(void)loadFamilies:(void (^)(NSArray *))callback {
    [self loadJSON:@"families" callback:callback];
}
@end
