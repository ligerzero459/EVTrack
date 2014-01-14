//
//  OptionsViewController.h
//  EVTrack
//
//  Created by Ryan Mottley on 12/15/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface OptionsViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UIScrollViewDelegate, ADBannerViewDelegate, UIAlertViewDelegate, UISplitViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tView;


@end
