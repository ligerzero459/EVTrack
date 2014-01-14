//
//  AddPokemonViewController.h
//  EVTrack
//
//  Created by Ryan Mottley on 6/19/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@class AddPokemonViewController;

@protocol AddPokemonViewControllerDelegate <NSObject>

- (void)addPokemonViewControllerDidCancel:(AddPokemonViewController *)controller;
- (void)addPokemonViewControllerDidAddPokemon:(AddPokemonViewController *)controller;

@end

@interface AddPokemonViewController : UITableViewController <AddPokemonViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UIScrollViewDelegate, ADBannerViewDelegate>
{
    BOOL testing;
    BOOL iAdLoaded;
    BOOL adMobLoaded;
}

@property (nonatomic, strong) id <AddPokemonViewControllerDelegate> delegate;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, weak) IBOutlet UITableView *tView;
@property (nonatomic) NSArray *allPokemon;

@property (nonatomic) NSInteger gameNumber;
@property (nonatomic, retain) Game *selectedGame;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

- (void)setGame:(Game *)game;

@end
