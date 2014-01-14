//
//  BattledPokemonViewController.h
//  EVTrack
//
//  Created by Ryan Mottley on 7/2/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@class EVPokemon;
@class AdvancedDetailViewController;

@interface BattledPokemonViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UIScrollViewDelegate, ADBannerViewDelegate>
{
    
}

//****************************
//         Properties
//****************************

@property (strong, nonatomic) Pokemon *pokemon;
@property (strong, nonatomic) AdvancedDetailViewController *parentController;
@property (weak, nonatomic) IBOutlet UITableView *tView;

//****************************
//           Methods
//****************************

- (IBAction)dismissModal:(id)sender;

@end
