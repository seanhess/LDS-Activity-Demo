//
//  MasterViewController.h
//  actives
//
//  Created by Sean Hess on 9/20/11.
//  Copyright (c) 2011 I.TV. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
