//
//  FamilyViewController.m
//  actives
//
//  Created by Sean Hess on 9/22/11.
//  Copyright (c) 2011 I.TV. All rights reserved.
//

#import "FamilyViewController.h"
#import "Family.h"

@implementation FamilyViewController
@synthesize family;

-(id)initWithFamily:(NSDictionary*)fam {
    if ((self = [super initWithNibName:@"FamilyViewController" bundle:nil])) {
        self.family = fam;
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
    
    self.navigationItem.title = [Family name:self.family];
    
    NSLog(@"FAMILY! %@", self.family);
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
