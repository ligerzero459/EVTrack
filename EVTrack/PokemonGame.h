//
//  PokemonGame.h
//  EVTrack
//
//  Created by Ryan Mottley on 7/17/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PokemonGame : NSObject <NSCoding>
{
    
}

@property (nonatomic, strong) NSMutableArray *allPokemon;
@property (nonatomic, strong) NSString *gameName;
@property (nonatomic, strong) NSString *imageName;

- (id)initWithGame:(NSString *)gName withImageName:(NSString *)iName;

@end
