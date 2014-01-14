//
//  MovePokemonViewController.h
//  EVTrack
//
//  Created by Ryan Mottley on 7/17/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovePokemonViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
{
    
}

@property (nonatomic) NSInteger gameNumber;
@property (nonatomic) NSInteger pokemonNumber;
@property (nonatomic, weak) IBOutlet UITableView *tView;

@property (nonatomic, retain) Game *selectedGame;
@property (nonatomic, retain) Pokemon *selectedPokemon;

- (IBAction)dismissModal:(id)sender;

@end
