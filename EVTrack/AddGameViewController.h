//
//  AddGameViewController.h
//  EVTrack
//
//  Created by Ryan Mottley on 7/18/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface AddGameViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UIScrollViewDelegate, ADBannerViewDelegate>
{
    BOOL testing;
    BOOL iAdLoaded;
    BOOL adMobLoaded;
}

@property (nonatomic, weak) IBOutlet UITableView *tView;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
