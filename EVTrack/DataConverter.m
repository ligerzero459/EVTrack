//
//  DataConverter.m
//  EVTrack
//
//  Created by Ryan Mottley on 12/22/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import "DataConverter.h"
#import "AppDelegate.h"

#import "Game.h"
#import "PokemonGame.h"
#import "Pokemon.h"
#import "EVPokemon.h"

@interface DataConverter ()
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end

@implementation DataConverter
{
    AppDelegate *appDelegate;
}

+ (DataConverter *)sharedConverter
{
    static DataConverter *sharedConverter = nil;
    if (!sharedConverter) {
        sharedConverter = [[super allocWithZone:nil] init];
    }
    
    return sharedConverter;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedConverter];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        appDelegate = [UIApplication sharedApplication].delegate;
        self.managedObjectContext = appDelegate.managedObjectContext;
    }
    
    return self;
}

- (Game *)convertGame:(PokemonGame *)oldGame
{
    Game *g = [NSEntityDescription insertNewObjectForEntityForName:@"Game" inManagedObjectContext:self.managedObjectContext];
    
    [g setName:[oldGame gameName]];
    [g setImagePath:[oldGame imageName]];
    
    for (EVPokemon *p in [oldGame allPokemon])
    {
        Pokemon *newPokemon = [self convertPokemon:p];
        [newPokemon setIndex:[[NSNumber alloc] initWithInteger:[[oldGame allPokemon] indexOfObject:p]]];
        
        [g addPokemonObject:newPokemon];
    }
    
    return g;
}

- (Pokemon *)convertPokemon:(EVPokemon *)oldPokemon
{
    Pokemon *p = [NSEntityDescription insertNewObjectForEntityForName:@"Pokemon" inManagedObjectContext:self.managedObjectContext];
    [p setNumber:[[NSNumber alloc] initWithInt:[oldPokemon pokemonNumber]]];
    [p setName:[oldPokemon pokemonName]];
    [p setHp:[[NSNumber alloc] initWithInt:[oldPokemon hp]]];
    [p setAttack:[[NSNumber alloc] initWithInt:[oldPokemon attack]]];
    [p setDefense:[[NSNumber alloc] initWithInt:[oldPokemon defense]]];
    [p setSpattack:[[NSNumber alloc] initWithInt:[oldPokemon spAttack]]];
    [p setSpdefense:[[NSNumber alloc] initWithInt:[oldPokemon spDefense]]];
    [p setSpeed:[[NSNumber alloc] initWithInt:[oldPokemon speed]]];
    
    if ([oldPokemon PKRS])
        [p setPkrs:[NSNumber numberWithInt:1]];
    else
        [p setPkrs:NO];
    
    if ([oldPokemon MachoBrace])
        [p setMachoBrace:[NSNumber numberWithInt:1]];
    else
        [p setMachoBrace:NO];
    
    if ([oldPokemon PowerWeight])
        [p setPowerWeight:[NSNumber numberWithInt:1]];
    else
        [p setPowerWeight:NO];
    
    if ([oldPokemon PowerBracer])
        [p setPowerBracer:[NSNumber numberWithInt:1]];
    else
        [p setPowerBracer:NO];
    
    if ([oldPokemon PowerBelt])
        [p setPowerBelt:[NSNumber numberWithInt:1]];
    else
        [p setPowerBelt:NO];
    
    if ([oldPokemon PowerLens])
        [p setPowerLens:[NSNumber numberWithInt:1]];
    else
        [p setPowerLens:NO];
    
    if ([oldPokemon PowerBelt])
        [p setPowerBand:[NSNumber numberWithInt:1]];
    else
        [p setPowerBand:NO];
    
    if ([oldPokemon PowerAnklet])
        [p setPowerAnklet:[NSNumber numberWithInt:1]];
    else
        [p setPowerAnklet:NO];
    
    return p;
}

@end
