//
//  AdvancedDetailViewController.h
//  EVTrack
//
//  Created by Ryan Mottley on 7/2/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewBarButtonItemPresenter.h"
#import "AppDelegate.h"

@class EVPokemon;
@class iPadPokemonViewController;

@interface AdvancedDetailViewController : UITableViewController <SplitViewBarButtonItemPresenter>
{
    UIPopoverController *popoverController;
}

@property (strong, nonatomic) Pokemon *pokemon;
@property (nonatomic, retain) iPadPokemonViewController *iPadView;

@property (strong, nonatomic) IBOutlet UITableView *tView;
@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UIImageView *pokemonImage;

@property (weak, nonatomic) UILabel *hpLabel;
@property (weak, nonatomic) UILabel *atkLabel;
@property (weak, nonatomic) UILabel *defLabel;
@property (weak, nonatomic) UILabel *spAtkLabel;
@property (weak, nonatomic) UILabel *spDefLabel;
@property (weak, nonatomic) UILabel *speedLabel;
@property (weak, nonatomic) UITextField *totalBox;

@property (weak, nonatomic) UILabel *battledName;
@property (weak, nonatomic) UILabel *numberBattled;
@property (weak, nonatomic) UIImageView *battledImage;
@property (weak, nonatomic) UILabel *firstEV;
@property (weak, nonatomic) UILabel *firstEVNum;
@property (weak, nonatomic) UIView *firstEVView;
@property (weak, nonatomic) UILabel *secondEV;
@property (weak, nonatomic) UILabel *secondEVNum;
@property (weak, nonatomic) UIView *secondEVView;
@property (weak, nonatomic) UILabel *thirdEV;
@property (weak, nonatomic) UILabel *thirdEVNum;
@property (weak, nonatomic) UIView *thirdEVView;
@property (weak, nonatomic) UIStepper *battledStepper;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *allPokemonBarButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
@property (nonatomic, retain) UIPopoverController *popoverController;

- (UIBarButtonItem *)createPopoverBarButton;
- (void)showPopover:(id)sender;

@end
