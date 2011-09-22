//
//  Family.m
//  actives
//
//  Created by Sean Hess on 9/22/11.
//  Copyright (c) 2011 I.TV. All rights reserved.
//

#import "Family.h"
#import <MapKit/MapKit.h>

@implementation Family

+(NSString*)uid:(NSDictionary*)family {
    return [family objectForKey:@"uid"];
}

+(double)lat:(NSDictionary*)family {
    return [[family objectForKey:@"lat"] doubleValue];
}

+(double)lon:(NSDictionary*)family {
    return [[family objectForKey:@"lon"] doubleValue];
}

+(NSString*)name:(NSDictionary*)family {
    return [family objectForKey:@"lastName"];
}

+(BOOL)isActive:(NSDictionary*)family {
    return [[self status:family] isEqualToString:@"active"];
}

+(NSString*)status:(NSDictionary*)family {
    return [family objectForKey:@"status"];     
}

+(NSString*)fullAddress:(NSDictionary*)family {
    return [NSString stringWithFormat:@"%@ %@, %@ %@", [family objectForKey:@"address"], [family objectForKey:@"city"], [family objectForKey:@"state"], [family objectForKey:@"postalCode"]];
}

+(NSArray*)people:(NSDictionary*)family {
    return [family objectForKey:@"people"];     
}

+(void)addNote:(NSString*)note family:(NSMutableDictionary*)family {
    NSArray * notes = [self notes:family];
    if (!notes) notes = [NSArray array];
    NSMutableArray * newNotes = [NSMutableArray arrayWithArray:notes];
    [newNotes addObject:note];
    [family setObject:newNotes forKey:@"notes"];
}

+(NSArray*)notes:(NSDictionary*)family {
    return [family objectForKey:@"notes"];
}


+(CLLocationCoordinate2D)coordinate:(NSDictionary*)family {
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [self lat:family];
    coordinate.longitude = [self lon:family];
    return coordinate;
}


+(MKCoordinateRegion)centerRegionForFamilies:(NSArray*)families {

    NSDictionary * firstFamily = [families objectAtIndex:0];

    double minLat = [Family lat:firstFamily];
    double maxLat = [Family lat:firstFamily];
    double minLon = [Family lon:firstFamily];
    double maxLon = [Family lon:firstFamily];
    
    for (NSDictionary * family in families) {
        double lat = [Family lat:family];
        double lon = [Family lon:family];
        
        if (lat < minLat) minLat = lat;
        else if (lat > maxLat) maxLat = lat;
        
        if (lon < minLon) minLon = lon;
        else if (lon > maxLon) maxLon = lon;
    }
    
    double dLat = (maxLat - minLat);
    double dLon = (maxLon - minLon);    

    CLLocationCoordinate2D center;
    center.latitude = minLat + dLat;
    center.longitude = minLon + dLon;

//    NSLog(@"POINT %f %f %f %f", center.latitude, center.longitude, dLat, dLon);

    MKCoordinateSpan span;
    span.latitudeDelta=dLat*1.4;
    span.longitudeDelta=dLon*1.4;
    
    MKCoordinateRegion region;
    region.span=span;
    region.center=center;
    
    return region;
}












+(NSString*)fullName:(NSDictionary*)person {
    return [[person objectForKey:@"firstName"] stringByAppendingFormat:@" %@", [person objectForKey:@"lastName"]];
}

+(NSString*)birthDate:(NSDictionary*)person {
    return [person objectForKey:@"birthDate"];
}

+(NSString*)gender:(NSDictionary*)person {
    return [person objectForKey:@"gender"];    
}


@end
