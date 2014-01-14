//
//  GameTableStore.m
//  EVTrack
//
//  Created by Ryan Mottley on 7/18/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import "GameTableStore.h"
#import "PokemonGame.h"

@implementation GameTableStore

+ (GameTableStore *)sharedStore
{
    static GameTableStore *sharedStore = nil;
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
        allGames = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)allGames
{
    return allGames;
}

- (void)addGame:(PokemonGame *)game
{
    [allGames addObject:game];
}

@end
