//
//  PokemonGame.m
//  EVTrack
//
//  Created by Ryan Mottley on 7/17/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import "PokemonGame.h"

@implementation PokemonGame

@synthesize allPokemon;
@synthesize gameName, imageName;

- (id)initWithGame:(NSString *)gName withImageName:(NSString *)iName
{
    self = [super init];
    if (self)
    {
        [self setGameName:gName];
        [self setImageName:iName];
        [self setAllPokemon:[[NSMutableArray alloc] initWithCapacity:1]];
    }
    
    return self;
}

//*****************************************
//          Saving/Loading Pokemon
//*****************************************

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:gameName forKey:@"gameName"];
    [aCoder encodeObject:imageName forKey:@"imageName"];
    [aCoder encodeObject:allPokemon forKey:@"allPokemon"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        [self setGameName:[aDecoder decodeObjectForKey:@"gameName"]];
        [self setImageName:[aDecoder decodeObjectForKey:@"imageName"]];
        [self setAllPokemon:[aDecoder decodeObjectForKey:@"allPokemon"]];
    }
    return self;
}

@end
