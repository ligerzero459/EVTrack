//
//  iPadPokemonViewController.h
//  EVTrack
//
//  Created by Ryan Mottley on 7/4/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EVPokemon;
@class Game;

@protocol PokemonDelegate <NSObject>

- (void)didSelectPokemon:(EVPokemon *)pokemon;

@end

@interface iPadPokemonViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISplitViewControllerDelegate, UIPopoverControllerDelegate, UIAlertViewDelegate>
{
    
    __weak IBOutlet UITableView *tView;
}

@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolbar;

@property (nonatomic) NSInteger gameNumber;
@property (nonatomic, retain) id<PokemonDelegate> delegate;

@property (nonatomic, retain) Game *selectedGame;

- (IBAction)editButtonPressed:(id)sender;
- (void)setAndShowPokemon:(Pokemon *)pokemon;

@end
