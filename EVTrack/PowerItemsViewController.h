//
//  PowerItemsViewController.h
//  EVTrack
//
//  Created by Ryan Mottley on 7/3/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@class AdvancedDetailViewController;

@interface PowerItemsViewController : UITableViewController <ADBannerViewDelegate>
{
    
}

//*****************************************
//               Properties
//*****************************************

@property (weak, nonatomic) IBOutlet UISwitch *PKRS;
@property (weak, nonatomic) IBOutlet UISwitch *machoBrace;
@property (weak, nonatomic) IBOutlet UISwitch *powerWeight;
@property (weak, nonatomic) IBOutlet UISwitch *powerBracer;
@property (weak, nonatomic) IBOutlet UISwitch *powerBelt;
@property (weak, nonatomic) IBOutlet UISwitch *powerLens;
@property (weak, nonatomic) IBOutlet UISwitch *powerBand;
@property (weak, nonatomic) IBOutlet UISwitch *powerAnklet;

@property (strong, nonatomic) AdvancedDetailViewController *advDetail;
@property (weak, nonatomic) IBOutlet UITableView *tView;

//*****************************************
//                 Methods
//*****************************************
- (IBAction)machoBraceToggled:(id)sender;
- (IBAction)powerWeightToggled:(id)sender;
- (IBAction)powerBracerToggled:(id)sender;
- (IBAction)powerBeltToggled:(id)sender;
- (IBAction)powerLensToggled:(id)sender;
- (IBAction)powerBandToggled:(id)sender;
- (IBAction)powerAnkletToggled:(id)sender;
- (IBAction)PKRSToggled:(id)sender;

- (IBAction)hpUpPressed:(id)sender;
- (IBAction)proteinPressed:(id)sender;
- (IBAction)ironPressed:(id)sender;
- (IBAction)calciumPressed:(id)sender;
- (IBAction)zincPressed:(id)sender;
- (IBAction)carbosPressed:(id)sender;

- (IBAction)dismissModal:(id)sender;

- (void)setToggleSwitches;

@end
