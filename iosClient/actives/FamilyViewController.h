//
//  FamilyViewController.h
//  actives
//
//  Created by Sean Hess on 9/22/11.
//  Copyright (c) 2011 I.TV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FamilyViewController : UIViewController

@property (strong, nonatomic) NSDictionary * family;

-(id)initWithFamily:(NSDictionary*)family;

@end
