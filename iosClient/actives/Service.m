//
//  Service.m
//  actives
//
//  Created by Sean Hess on 9/22/11.
//  Copyright (c) 2011 I.TV. All rights reserved.
//

#import "Service.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"

@implementation Service

+(void)loadJSONFromBundle:(NSString*)fileName callback:(void(^)(NSArray*))callback {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];  
    NSData * fileData = [NSData dataWithContentsOfFile:filePath];
    
    SBJsonParser * parser = [SBJsonParser new];
    
    NSArray * parsed = [parser objectWithData:fileData];
    callback(parsed);
}

+(void)loadJSONFromURL:(NSString*)urlString method:(NSString*)method callback:(void(^)(id))callback {
    [self loadJSONFromURL:urlString method:method body:nil callback:callback];
}

+(void)loadJSONFromURL:(NSString*)urlString method:(NSString*)method body:(NSString*)body callback:(void(^)(id))callback {

    urlString = [Domain stringByAppendingString:urlString];
    
    NSURL * url = [NSURL URLWithString:urlString];
    __weak ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:url];
    
    request.requestMethod = method;

    if (body) {
        SBJsonWriter * writer = [[SBJsonWriter alloc] init];
        request.postBody = [NSMutableData dataWithData:[writer dataWithObject:body]];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
    }
    
    [request setCompletionBlock:^{
        NSData * data = [request responseData];
        SBJsonParser * parser = [SBJsonParser new];
        NSArray * parsed = [parser objectWithData:data];
        callback(parsed);
    }];
    
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"REQUEST ERROR %@", error);
    }];
    
    [request startAsynchronous];
}




@end
