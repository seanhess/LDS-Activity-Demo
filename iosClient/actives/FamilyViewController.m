//
//  FamilyViewController.m
//  actives
//
//  Created by Sean Hess on 9/22/11.
//  Copyright (c) 2011 I.TV. All rights reserved.
//

#import "FamilyViewController.h"
#import "Family.h"
#import "NoteViewController.h"
#import "PeopleService.h"

@implementation FamilyViewController
@synthesize family;
@synthesize tableView;
@synthesize notePopover, noteViewController;

-(id)initWithFamily:(NSMutableDictionary*)fam {
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
    
    self.navigationItem.title = [NSString stringWithFormat:@"The %@ Family", [Family name:self.family]];
    
}

- (void)load {
    [PeopleService loadFamily:self.family callback:^(NSMutableDictionary * fam) {
        self.family = fam;
        [self.tableView reloadData];
    }];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3; // (name, status, address), (people), (notes)
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *sectionHeader = nil;
	
	if(section == 0) {
		sectionHeader = @"Summary";
	}
	
    else if(section == 1) {
		sectionHeader = @"Members";
	}
    
    else {
        sectionHeader = @"Notes";
    }
		
	return sectionHeader;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.

	if(section == 0) {
        return 2;
	}
	
    else if(section == 1) {
		return [[Family people:self.family] count];
	}
    
    else {
        return [[Family notes:self.family] count] + 1;
    }
}

- (UITableViewCell *)labelCell {

    static NSString *LabelCellIdentifier = @"LabelCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LabelCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:LabelCellIdentifier];
    }
    
    return cell;
}

- (UITableViewCell *)rightCell {

    static NSString *CellIdentifier = @"RightCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

- (UITableViewCell *)normalCell {

    static NSString *CellIdentifier = @"NormalCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath
{            

    UITableViewCell * cell;
        
    // info
    if(indexPath.section == 0) {
    
        cell = [self labelCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        // status
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Activity";
            cell.detailTextLabel.text = [Family status:self.family];
        }
        
        // address
        else {
            cell.textLabel.text = @"Address";        
            cell.detailTextLabel.text = [Family fullAddress:self.family];
        }
	}
	
    // people
    else if(indexPath.section == 1) {
        cell = [self rightCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDictionary * person = [[Family people:self.family] objectAtIndex:indexPath.row];
        cell.textLabel.text = [Family fullName:person];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", [Family birthDate:person], [Family gender:person]];
	}
    
    // notes
    else {
        
        cell = [self normalCell];    
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Add a Note";
            cell.accessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
        }
        
        else {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSString * note = [[Family notes:self.family] objectAtIndex:indexPath.row-1];
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
            cell.textLabel.text = note;
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];        
        }
    }
    
    
    // Configure the cell...
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    // notes
    if (indexPath.section == 2 && indexPath.row > 0) {
        NSString * note = [[Family notes:self.family] objectAtIndex:indexPath.row-1];    
        
        UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
        CGSize constraintSize = CGSizeMake(self.tableView.frame.size.width - 140, MAXFLOAT);
        CGSize labelSize = [note sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];

        return labelSize.height + 20;

    }
    
    return 42;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // notes
    if (indexPath.section == 2 && indexPath.row == 0) {
    
    
        self.noteViewController = [[NoteViewController alloc] initWithNibName:@"NoteViewController" bundle:nil];
        self.noteViewController.delegate = self;
        
        UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];

        UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:self.noteViewController];

        navController.contentSizeForViewInPopover = CGSizeMake(500, 400);
        
        self.notePopover = [[UIPopoverController alloc] initWithContentViewController:navController];
        [self.notePopover presentPopoverFromRect:cell.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        
        self.notePopover.delegate = self;
    
    }


}

- (void)didCancelNote {
    [self.notePopover dismissPopoverAnimated:YES];
}

- (void)didCompleteNote:(NSString *)note {
    NSLog(@"NOTE! %@", self.noteViewController.note);
    [self.notePopover dismissPopoverAnimated:YES];  
    
    [Family addNote:note family:self.family];
    NSLog(@"Family Notes %@ %@", self.family, [Family notes:family] );
    
    [PeopleService saveNote:note family:self.family callback:^(NSObject * response) {
        [self load];        
    }];  
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    
}

@end
