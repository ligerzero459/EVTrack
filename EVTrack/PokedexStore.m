//
//  PokedexStore.m
//  EVTrack
//
//  Created by Ryan Mottley on 6/20/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import "PokedexStore.h"
#import "EVPokemon.h"

@implementation PokedexStore

+ (PokedexStore *)sharedStore
{
    static PokedexStore *sharedStore = nil;
    if (!sharedStore)
    {
        sharedStore = [[super allocWithZone:nil] init];
    }
    
    return sharedStore;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        allPokemon = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)allPokemon
{
    return allPokemon;
}

- (void)addPokemon:(EVPokemon *)pokemon
{
    [allPokemon addObject:pokemon];
}

- (EVPokemon *)addPokemon:(NSString *)pokemonName withNumber:(int)pokemonNumber withLevel:(int)lvl withHP:(int)hitpoints
                  withAtk:(int)atk withDef:(int)def withSpA:(int)spAtk withSpD:(int)spDef withSpeed:(int)spd;
{
    EVPokemon *p = [EVPokemon newPokemonEntry:pokemonName withNumber:pokemonNumber withLevel:lvl withHP:hitpoints withAtk:atk withDef:def withSpA:spAtk withSpD:spDef withSpeed:spd];
    
    [allPokemon addObject:p];
    
    return p;
}

@end
