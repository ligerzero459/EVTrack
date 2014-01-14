//
//  PokedexStore.h
//  EVTrack
//
//  Created by Ryan Mottley on 6/20/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EVPokemon;

@interface PokedexStore : NSObject
{
    NSMutableArray *allPokemon;
}

+ (PokedexStore *)sharedStore;

- (NSArray *)allPokemon;
- (void)addPokemon:(EVPokemon *)pokemon;
- (EVPokemon *)addPokemon:(NSString *)pName withNumber:(int)pNumber withLevel:(int)lvl withHP:(int)hitpoints
                     withAtk:(int)atk withDef:(int)def withSpA:(int)spAtk withSpD:(int)spDef withSpeed:(int)spd;

@end
