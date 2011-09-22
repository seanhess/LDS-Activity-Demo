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

+(double)lat:(NSDictionary*)family {
    return [[family objectForKey:@"lat"] doubleValue];
}

+(double)lon:(NSDictionary*)family {
    return [[family objectForKey:@"lon"] doubleValue];
}

+(NSString*)name:(NSDictionary*)family {
    return [family objectForKey:@"lastName"];
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


@end
