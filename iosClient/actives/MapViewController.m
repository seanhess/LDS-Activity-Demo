//
//  MapViewController.m
//  actives
//
//  Created by Sean Hess on 9/22/11.
//  Copyright (c) 2011 I.TV. All rights reserved.
//

#import "MapViewController.h"
#import "PeopleService.h"
#import "Family.h"
#import "FamilyLocation.h"
#import "FamilyViewController.h"

#define MetersPerMile 1609.344

@implementation MapViewController
@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"Families";
        
    // load people
    [PeopleService loadFamilies:^(NSArray * families) {
        [self plot:families];
    }];    
    
}

- (void)plot:(NSArray*)families {
    // move the map
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:[Family centerRegionForFamilies:families]];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    // remove old ones
    for (id<MKAnnotation> annotation in self.mapView.annotations)
        [self.mapView removeAnnotation:annotation];
        
    // add new ones
    for (NSDictionary * family in families) {
        FamilyLocation * annotation = [[FamilyLocation alloc] initWithFamily:family];
        [self.mapView addAnnotation:annotation];
    }
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
 
    static NSString *identifier = @"FamilyLocation";   

    if ([annotation isKindOfClass:[FamilyLocation class]]) {
        FamilyLocation *location = (FamilyLocation *) annotation;
 
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
 
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;        
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
 
        if ([Family isActive:location.family])
            annotationView.pinColor = MKPinAnnotationColorGreen;
            
        else 
            annotationView.pinColor = MKPinAnnotationColorRed;
            
        return annotationView;
    }
 
    return nil;    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {

    FamilyLocation * location = (FamilyLocation *)view.annotation;
    NSDictionary * family = location.family;
    
    // Push the detail view on to the stack, baby. 
    
    FamilyViewController * familyViewController = [[FamilyViewController alloc] initWithFamily:family];
    [self.navigationController pushViewController:familyViewController animated:YES];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {

}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {

}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
