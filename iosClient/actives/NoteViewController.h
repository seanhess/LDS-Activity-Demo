//
//  NoteViewController.h
//  actives
//
//  Created by Sean Hess on 9/22/11.
//  Copyright (c) 2011 I.TV. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoteViewControllerDelegate <NSObject>

-(void)didCompleteNote:(NSString*)note;
-(void)didCancelNote;

@end

@interface NoteViewController : UIViewController


@property (weak, nonatomic) id<NoteViewControllerDelegate>delegate;
@property (strong, nonatomic) IBOutlet UITextView *textView;
-(NSString*)note;

@end
