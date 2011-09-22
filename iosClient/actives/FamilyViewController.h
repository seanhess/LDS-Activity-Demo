//
//  FamilyViewController.h
//  actives
//
//  Created by Sean Hess on 9/22/11.
//  Copyright (c) 2011 I.TV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteViewController.h"

@interface FamilyViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPopoverControllerDelegate, NoteViewControllerDelegate>

@property (strong, nonatomic) NSMutableDictionary * family;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIPopoverController *notePopover;
@property (strong, nonatomic) NoteViewController *noteViewController;

-(id)initWithFamily:(NSMutableDictionary*)family;

@end
