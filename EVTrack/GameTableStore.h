//
//  GameTableStore.h
//  EVTrack
//
//  Created by Ryan Mottley on 7/18/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PokemonGame;

@interface GameTableStore : NSObject
{
    NSMutableArray *allGames;
}

+ (GameTableStore *)sharedStore;

- (NSArray *)allGames;
- (void)addGame:(PokemonGame *)game;

@end
