//
//  DataManager.m
//  EVTrack
//
//  Created by Ryan Mottley on 12/28/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import "DataManager.h"

#import "AppDelegate.h"

@interface DataManager  ()
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end

@implementation DataManager
{
    AppDelegate *appDelegate;
}

+ (DataManager *)manager
{
    static DataManager *manager = nil;
    
    if (!manager)
    {
        manager = [[super allocWithZone:nil] init];
    }
    
    return manager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self manager];
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        appDelegate = [UIApplication sharedApplication].delegate;
        self.managedObjectContext = appDelegate.managedObjectContext;
    }
    
    return self;
}

- (NSArray *)getPokedex
{
    NSArray *pokedex = [appDelegate getData:@"Pokedex"];
    Pokedex *retrievedPokedex = [pokedex objectAtIndex:0];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"number" ascending:YES];
    NSArray *sortedArray = [[retrievedPokedex pokemon] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    return sortedArray;
}

- (NSArray *)getPokemon:(Game *)game
{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    NSArray *sortedArray = [[game pokemon] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    return sortedArray;
}

- (NSArray *)getBattled:(Pokemon *)pokemon
{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:NO];
    NSArray *sortedArray = [[pokemon recentPokemon] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    return sortedArray;
}

- (NSArray *)getGames
{
    NSArray *games = [appDelegate getData:@"Games"];
    Games *retrivedGames;
    if ([[[games objectAtIndex:0] index] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        retrivedGames = [games objectAtIndex:0];
    }
    else
    {
        retrivedGames = [games objectAtIndex:1];
    }
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    NSArray *sortedArray = [[retrivedGames game] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    return sortedArray;
}

- (NSArray *)getAllGames
{
    NSArray *games = [appDelegate getData:@"Games"];
    Games *retrivedGames;
    if ([[[games objectAtIndex:0] index] isEqualToNumber:[NSNumber numberWithInt:0]])
    {
        retrivedGames = [games objectAtIndex:0];
    }
    else
    {
        retrivedGames = [games objectAtIndex:1];
    }
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    NSArray *sortedArray = [[retrivedGames game] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    return sortedArray;
}

- (Game *)newGame
{
    Game *game = [NSEntityDescription insertNewObjectForEntityForName:@"Game" inManagedObjectContext:self.managedObjectContext];
    
    return game;
}

- (Games *)newGames
{
    Games *games = [NSEntityDescription insertNewObjectForEntityForName:@"Games" inManagedObjectContext:self.managedObjectContext];
    
    return games;
}

- (Pokemon *)newPokemon
{
    Pokemon *pokemon = [NSEntityDescription insertNewObjectForEntityForName:@"Pokemon" inManagedObjectContext:self.managedObjectContext];
    
    return pokemon;
}

- (Pokedex *)newPokedex
{
    Pokedex *pokedex = [NSEntityDescription insertNewObjectForEntityForName:@"Pokedex" inManagedObjectContext:self.managedObjectContext];
    
    return pokedex;
}

- (Battled *)newBattled
{
    Battled *battled = [NSEntityDescription insertNewObjectForEntityForName:@"Battled" inManagedObjectContext:self.managedObjectContext];
    
    return battled;
}

- (void)deleteGame:(Game *)selectedGame
{
    if ([[[[appDelegate getData:@"Games"] objectAtIndex:0] index] isEqualToNumber:[[NSNumber alloc] initWithInt:1]])
        [[[appDelegate getData:@"Games"] objectAtIndex:0] removeGameObject:selectedGame];
    else
        [[[appDelegate getData:@"Games"] objectAtIndex:1] removeGameObject:selectedGame];
    
    [self saveContext];
}

- (void)deletePokemon:(Pokemon *)selectedPokemon fromGame:(Game *)selectedGame
{
    [selectedGame removePokemonObject:selectedPokemon];
    [self.managedObjectContext deleteObject:selectedPokemon];
    [self saveContext];
}

- (void)deleteGames
{
    if ([[[[appDelegate getData:@"Games"] objectAtIndex:0] index] isEqualToNumber:[[NSNumber alloc] initWithInt:1]])
        [self.managedObjectContext deleteObject:[[appDelegate getData:@"Games"] objectAtIndex:0]];
    else
        [self.managedObjectContext deleteObject:[[appDelegate getData:@"Games"] objectAtIndex:1]];
    
    [self saveContext];
}

- (void)deleteBattled:(Battled *)selectedBattled fromPokemon:(Pokemon *)selectedPokemon
{
    [selectedPokemon removeRecentPokemonObject:selectedBattled];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    NSArray *sortedArray = [[selectedPokemon recentPokemon] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    for (int i = 0; i < [sortedArray count]; i++)
    {
        [[sortedArray objectAtIndex:i] setIndex:[NSNumber numberWithInt:i]];
    }
    
    [self.managedObjectContext deleteObject:selectedBattled];
    [self saveContext];
}

- (Pokemon *)addNewRecentPokemon:(Battled *)recentBattled inPokemon:(Pokemon *)selectedPokemon
{
    if ([[selectedPokemon recentPokemon] count] == 10)
    {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
        NSArray *sortedArray = [[selectedPokemon recentPokemon] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
        
        [self deleteBattled:[sortedArray objectAtIndex:0] fromPokemon:selectedPokemon];
        [recentBattled setIndex:[NSNumber numberWithInt:9]];
        
        [selectedPokemon addRecentPokemonObject:recentBattled];
        [self saveContext];
        return selectedPokemon;
    }
    else
    {
        [recentBattled setIndex:[NSNumber numberWithInt:[[selectedPokemon recentPokemon] count]]];
        
        [selectedPokemon addRecentPokemonObject:recentBattled];
        [self saveContext];
        return selectedPokemon;
    }
}

- (void)saveContext
{
    [appDelegate saveContext];
}

@end
