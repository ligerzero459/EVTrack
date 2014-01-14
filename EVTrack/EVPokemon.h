//
//  EVPokemon.h
//  EVTrack
//
//  Created by Ryan Mottley on 6/16/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVPokemon : NSObject <NSCoding>
{
    
}

@property (nonatomic) int pokemonNumber;
@property (nonatomic, copy) NSString *pokemonName;
@property (nonatomic) int level;
@property (nonatomic) int hp;
@property (nonatomic) int attack;
@property (nonatomic) int defense;
@property (nonatomic) int spAttack;
@property (nonatomic) int spDefense;
@property (nonatomic) int speed;
@property (nonatomic) BOOL PKRS;
@property (nonatomic) BOOL MachoBrace;
@property (nonatomic) BOOL PowerWeight;
@property (nonatomic) BOOL PowerBracer;
@property (nonatomic) BOOL PowerBelt;
@property (nonatomic) BOOL PowerLens;
@property (nonatomic) BOOL PowerBand;
@property (nonatomic) BOOL PowerAnklet;

+ (id)newPokemonEntry:(NSString *)pokemonName withNumber:(int)pokemonNumber;
+ (id)newPokemonEntry:(NSString *)pName withNumber:(int)pNumber withLevel:(int)lvl withHP:(int)hitpoints
              withAtk:(int)atk withDef:(int)def withSpA:(int)spAtk withSpD:(int)spDef withSpeed:(int)spd;

- (id)initWithPokemonName:(NSString *)pName withNumber:(int)pNumber;
- (id)initWithPokemonName:(NSString *)pName withNumber:(int)pNumber withLevel:(int)lvl withHP:(int)hitpoints
                withAtk:(int)atk withDef:(int)def withSpA:(int)spAtk withSpD:(int)spDef withSpeed:(int)spd;

- (void)addHp:(int)value;
- (void)addAttack:(int)value;
- (void)addDefense:(int)value;
- (void)addSpAttack:(int)value;
- (void)addSpDefense:(int)value;
- (void)addSpeed:(int)value;

@end
