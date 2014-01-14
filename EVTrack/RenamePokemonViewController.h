//
//  RenamePokemonViewController.h
//  EVTrack
//
//  Created by Ryan Mottley on 10/3/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@class AdvancedDetailViewController;

@interface RenamePokemonViewController : UITableViewController <ADBannerViewDelegate>
{
    
}

//*****************************************
//                Properties
//*****************************************

@property (strong, nonatomic) AdvancedDetailViewController *advDetail;
@property (weak, nonatomic) IBOutlet UITableView *tView;
@property (weak, nonatomic) IBOutlet UITextField *renameField;

//*****************************************
//                 Methods
//*****************************************

- (IBAction)dismissModal:(id)sender;
- (IBAction)dismissModalSave:(id)sender;

@end
