//
//  DataConverter.h
//  EVTrack
//
//  Created by Ryan Mottley on 12/22/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Game;
@class Pokemon;
@class EVPokemon;
@class PokemonGame;

@interface DataConverter : NSObject

+ (DataConverter *)sharedConverter;

- (Game *)convertGame:(PokemonGame *)oldGame;
- (Pokemon *)convertPokemon:(EVPokemon *)oldPokemon;

@end
