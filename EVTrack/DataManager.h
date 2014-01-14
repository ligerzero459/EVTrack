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

@interface DataManager : NSObject

+ (DataManager *)manager;

- (NSArray *)getPokedex;
- (NSArray *)getGames;
- (NSArray *)getAllGames;
- (NSArray *)getPokemon:(Game *)game;

- (Game *)newGame;
- (Games *)newGames;
- (Pokemon *)newPokemon;
- (Pokedex *)newPokedex;

- (void)deletePokemon:(Pokemon *)selectedPokemon fromGame:(Game *)selectedGame;
- (void)deleteGame:(Game *)selectedGame;
- (void)deleteGames;

- (void)saveContext;

@end
