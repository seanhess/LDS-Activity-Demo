//
//  DetailViewController.h
//  actives
//
//  Created by Sean Hess on 9/20/11.
//  Copyright (c) 2011 I.TV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
