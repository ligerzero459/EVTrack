//
//  Pokemon.h
//  EVTrack
//
//  Created by Ryan Mottley on 1/24/14.
//  Copyright (c) 2014 Kai Strife Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Battled, Game, Pokedex;

@interface Pokemon : NSManagedObject

@property (nonatomic, retain) NSNumber * attack;
@property (nonatomic, retain) NSNumber * defense;
@property (nonatomic, retain) NSNumber * hp;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSNumber * machoBrace;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSNumber * pkrs;
@property (nonatomic, retain) NSNumber * powerAnklet;
@property (nonatomic, retain) NSNumber * powerBand;
@property (nonatomic, retain) NSNumber * powerBelt;
@property (nonatomic, retain) NSNumber * powerBracer;
@property (nonatomic, retain) NSNumber * powerLens;
@property (nonatomic, retain) NSNumber * powerWeight;
@property (nonatomic, retain) NSNumber * spattack;
@property (nonatomic, retain) NSNumber * spdefense;
@property (nonatomic, retain) NSNumber * speed;
@property (nonatomic, retain) Game *game;
@property (nonatomic, retain) Pokedex *pokedex;
@property (nonatomic, retain) NSSet *recentPokemon;
@end

@interface Pokemon (CoreDataGeneratedAccessors)

- (void)addRecentPokemonObject:(Battled *)value;
- (void)removeRecentPokemonObject:(Battled *)value;
- (void)addRecentPokemon:(NSSet *)values;
- (void)removeRecentPokemon:(NSSet *)values;

@end
