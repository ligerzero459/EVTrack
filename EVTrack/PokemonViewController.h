//
//  PokemonViewController.h
//  EVTrack
//
//  Created by Ryan Mottley on 6/16/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EVPokemon;
@class Game;

@protocol PokemonDelegate <NSObject>

- (void)didSelectPokemon:(EVPokemon *)pokemon;

@end

@interface PokemonViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
{
    
    __weak IBOutlet UITableView *tView;
}

@property (nonatomic, retain) id<PokemonDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolbar;

@property (nonatomic) NSInteger gameNumber;
@property (nonatomic, retain) Game *selectedGame;

- (IBAction)editButtonPressed:(id)sender;

@end
