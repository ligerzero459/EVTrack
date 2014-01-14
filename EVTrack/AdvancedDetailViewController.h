//
//  AdvancedDetailViewController.h
//  EVTrack
//
//  Created by Ryan Mottley on 7/2/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewBarButtonItemPresenter.h"

@class EVPokemon;
@class iPadPokemonViewController;

@interface AdvancedDetailViewController : UITableViewController <SplitViewBarButtonItemPresenter>
{
    UIPopoverController *popoverController;
}

@property (strong, nonatomic) Pokemon *pokemon;
@property (nonatomic, retain) iPadPokemonViewController *iPadView;

@property (strong, nonatomic) IBOutlet UITableView *tView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pokemonImage;

@property (weak, nonatomic) IBOutlet UILabel *hpLabel;
@property (weak, nonatomic) IBOutlet UILabel *atkLabel;
@property (weak, nonatomic) IBOutlet UILabel *defLabel;
@property (weak, nonatomic) IBOutlet UILabel *spAtkLabel;
@property (weak, nonatomic) IBOutlet UILabel *spDefLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UITextField *totalBox;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *allPokemonBarButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
@property (nonatomic, retain) UIPopoverController *popoverController;

- (UIBarButtonItem *)createPopoverBarButton;
- (void)showPopover:(id)sender;

@end
