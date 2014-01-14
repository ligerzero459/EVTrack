//
//  GamesViewController.h
//  EVTrack
//
//  Created by Ryan Mottley on 7/18/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GamesViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UISplitViewControllerDelegate, UIPopoverControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *editButton;

- (IBAction)editButtonPressed:(id)sender;

@end
