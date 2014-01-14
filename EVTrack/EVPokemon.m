//
//  EVPokemon.m
//  EVTrack
//
//  Created by Ryan Mottley on 6/16/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import "EVPokemon.h"

@implementation EVPokemon
@synthesize pokemonName, pokemonNumber;
@synthesize level, hp, attack, defense, spAttack, spDefense, speed;
@synthesize MachoBrace, PowerAnklet, PowerBand, PowerBelt, PowerBracer, PowerLens, PowerWeight, PKRS;

+ (id)newPokemonEntry:(NSString *)pokemonName withNumber:(int)pokemonNumber
{
    EVPokemon *p = [[EVPokemon alloc] initWithPokemonName:pokemonName withNumber:pokemonNumber];
    
    return p;
}

+ (id)newPokemonEntry:(NSString *)pName withNumber:(int)pNumber withLevel:(int)lvl withHP:(int)hitpoints
              withAtk:(int)atk withDef:(int)def withSpA:(int)spAtk withSpD:(int)spDef withSpeed:(int)spd
{
    EVPokemon *p = [[EVPokemon alloc] initWithPokemonName:pName withNumber:pNumber withLevel:lvl withHP:hitpoints withAtk:atk withDef:def withSpA:spAtk withSpD:spDef withSpeed:spd];
    
    return p;
}

- (id) init
{
    return [self initWithPokemonName:@"Pokemon" withNumber:1];
}

- (id)initWithPokemonName:(NSString *)pName withNumber:(int)pNumber
{
    self = [super init];
    
    if (self)
    {
        [self setPokemonNumber:pNumber];
        [self setPokemonName:pName];
        [self setLevel:1];
        [self setHp:0];
        [self setAttack:0];
        [self setDefense:0];
        [self setSpAttack:0];
        [self setSpDefense:0];
        [self setSpeed:0];
        [self setMachoBrace:NO];
        [self setPowerAnklet:NO];
        [self setPowerBand:NO];
        [self setPowerBelt:NO];
        [self setPowerBracer:NO];
        [self setPowerLens:NO];
        [self setPowerWeight:NO];
        [self setPKRS:NO];
    }
    
    return self;
}

- (id)initWithPokemonName:(NSString *)pName withNumber:(int)pNumber withLevel:(int)lvl withHP:(int)hitpoints
                  withAtk:(int)atk withDef:(int)def withSpA:(int)spAtk withSpD:(int)spDef withSpeed:(int)spd
{
    self = [super init];
    
    if (self)
    {
        [self setPokemonNumber:pNumber];
        [self setPokemonName:pName];
        [self setLevel:lvl];
        [self setHp:hitpoints];
        [self setAttack:atk];
        [self setDefense:def];
        [self setSpAttack:spAtk];
        [self setSpDefense:spDef];
        [self setSpeed:spd];
        [self setMachoBrace:NO];
        [self setPowerAnklet:NO];
        [self setPowerBand:NO];
        [self setPowerBelt:NO];
        [self setPowerBracer:NO];
        [self setPowerLens:NO];
        [self setPowerWeight:NO];
        [self setPKRS:NO];
    }
    
    return self;
}

//*****************************************
//             Adding EV Values
//*****************************************

- (void)addHp:(int)value
{
    hp += value;
}

- (void)addAttack:(int)value
{
    attack += value;
}

- (void)addDefense:(int)value
{
    defense += value;
}

- (void)addSpAttack:(int)value
{
    spAttack += value;
}

- (void)addSpDefense:(int)value
{
    spDefense += value;
}

- (void)addSpeed:(int)value
{
    speed += value;
}

//*****************************************
//          Saving/Loading Pokemon
//*****************************************

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:pokemonNumber forKey:@"pokemonNumber"];
    [aCoder encodeObject:pokemonName forKey:@"pokemonName"];
    [aCoder encodeInt:level forKey:@"level"];
    [aCoder encodeInt:hp forKey:@"hp"];
    [aCoder encodeInt:attack forKey:@"attack"];
    [aCoder encodeInt:defense forKey:@"defense"];
    [aCoder encodeInt:spAttack forKey:@"spAttack"];
    [aCoder encodeInt:spDefense forKey:@"spDefense"];
    [aCoder encodeInt:speed forKey:@"speed"];
    [aCoder encodeBool:MachoBrace forKey:@"MachoBrace"];
    [aCoder encodeBool:PowerAnklet forKey:@"PowerAnklet"];
    [aCoder encodeBool:PowerBand forKey:@"PowerBand"];
    [aCoder encodeBool:PowerBelt forKey:@"PowerBelt"];
    [aCoder encodeBool:PowerBracer forKey:@"PowerBracer"];
    [aCoder encodeBool:PowerLens forKey:@"PowerLens"];
    [aCoder encodeBool:PowerWeight forKey:@"PowerWeight"];
    [aCoder encodeBool:PKRS forKey:@"PKRS"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        [self setPokemonNumber:[aDecoder decodeIntForKey:@"pokemonNumber"]];
        [self setPokemonName:[aDecoder decodeObjectForKey:@"pokemonName"]];
        [self setLevel:[aDecoder decodeIntForKey:@"level"]];
        [self setHp:[aDecoder decodeIntForKey:@"hp"]];
        [self setAttack:[aDecoder decodeIntForKey:@"attack"]];
        [self setDefense:[aDecoder decodeIntForKey:@"defense"]];
        [self setSpAttack:[aDecoder decodeIntForKey:@"spAttack"]];
        [self setSpDefense:[aDecoder decodeIntForKey:@"spDefense"]];
        [self setSpeed:[aDecoder decodeIntForKey:@"speed"]];
        [self setMachoBrace:[aDecoder decodeBoolForKey:@"MachoBrace"]];
        [self setPowerAnklet:[aDecoder decodeBoolForKey:@"PowerAnklet"]];
        [self setPowerBand:[aDecoder decodeBoolForKey:@"PowerBand"]];
        [self setPowerBelt:[aDecoder decodeBoolForKey:@"PowerBelt"]];
        [self setPowerBracer:[aDecoder decodeBoolForKey:@"PowerBracer"]];
        [self setPowerLens:[aDecoder decodeBoolForKey:@"PowerLens"]];
        [self setPowerWeight:[aDecoder decodeBoolForKey:@"PowerWeight"]];
        [self setPKRS:[aDecoder decodeBoolForKey:@"PKRS"]];
    }
    return self;
}

- (NSString *)description
{
    NSString *description = [[NSString alloc] initWithFormat:@"Pokemon Number: %d, Pokemon Name: %@", pokemonNumber, pokemonName];
    
    return description;
}

@end
