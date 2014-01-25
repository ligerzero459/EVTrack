//
//  DataManager.h
//  EVTrack
//
//  Created by Ryan Mottley on 12/28/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Game.h"
#import "Pokedex.h"
#import "Pokemon.h"
#import "Games.h"
#import "Battled.h"

@interface DataManager : NSObject

+ (DataManager *)manager;

- (NSArray *)getPokedex;
- (NSArray *)getGames;
- (NSArray *)getAllGames;
- (NSArray *)getPokemon:(Game *)game;
- (NSArray *)getBattled:(Pokemon *)pokemon;

- (Game *)newGame;
- (Games *)newGames;
- (Pokemon *)newPokemon;
- (Pokedex *)newPokedex;
- (Battled *)newBattled;

- (void)deletePokemon:(Pokemon *)selectedPokemon fromGame:(Game *)selectedGame;
- (void)deleteGame:(Game *)selectedGame;
- (void)deleteGames;
- (void)deleteBattled:(Battled *)selectedBattled fromPokemon:(Pokemon *)selectedPokemon;

- (void)addNewRecentPokemon:(Battled *)recentBattled inPokemon:(Pokemon *)selectedPokemon;

- (void)saveContext;

@end
