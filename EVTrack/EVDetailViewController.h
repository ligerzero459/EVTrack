//
//  EVDetailViewController.h
//  EVTrack
//
//  Created by Ryan Mottley on 6/17/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SplitViewBarButtonItemPresenter.h"

@class EVPokemon;
@class AdvancedDetailViewController;

@interface EVDetailViewController : UIViewController <SplitViewBarButtonItemPresenter, UISearchDisplayDelegate>
{
    // Main Views
    __weak IBOutlet UIScrollView *detailScrollView;
    __weak IBOutlet UIImageView *detailImageView;
    __weak IBOutlet UILabel *detailNumberLabel;
    __weak IBOutlet UILabel *detailNameLabel;
    
    // EV Views
    __weak IBOutlet UIView *hpView;
    __weak IBOutlet UIView *atkView;
    __weak IBOutlet UIView *defView;
    __weak IBOutlet UIView *spAtkView;
    __weak IBOutlet UIView *spDefView;
    __weak IBOutlet UIView *speedView;
    
    // EV Text Boxes
    __weak IBOutlet UITextField *totalBox;
    __weak IBOutlet UILabel *hpLabel;
    __weak IBOutlet UILabel *atkLabel;
    __weak IBOutlet UILabel *defLabel;
    __weak IBOutlet UILabel *spAtkLabel;
    __weak IBOutlet UILabel *spDefLabel;
    __weak IBOutlet UILabel *speedLabel;
    
    // EV Toggles
    __weak IBOutlet UIStepper *hpStepper;
    __weak IBOutlet UIStepper *atkStepper;
    __weak IBOutlet UIStepper *defStepper;
    __weak IBOutlet UIStepper *spAtkStepper;
    __weak IBOutlet UIStepper *spDefStepper;
    __weak IBOutlet UIStepper *speedStepper;
    __weak IBOutlet UIStepper *hp2Stepper;
    __weak IBOutlet UIStepper *atk2Stepper;
    __weak IBOutlet UIStepper *def2Stepper;
    __weak IBOutlet UIStepper *spAtk2Stepper;
    __weak IBOutlet UIStepper *spDef2Stepper;
    __weak IBOutlet UIStepper *speed2Stepper;
}

@property (nonatomic, strong) Pokemon *pokemon;
@property (nonatomic, assign) id<UISplitViewControllerDelegate> delegate;
@property (nonatomic, weak) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) AdvancedDetailViewController *advDetail;

- (IBAction)hpStepperChanged:(id)sender;
- (IBAction)atkStepperChanged:(id)sender;
- (IBAction)defStepperChanged:(id)sender;
- (IBAction)spAtkStepperChanged:(id)sender;
- (IBAction)spDefStepperChanged:(id)sender;
- (IBAction)speedStepperChanged:(id)sender;

- (void)setTheme;
- (void)populateLabels;

@end
