//
//  Pokedex.h
//  EVTrack
//
//  Created by Ryan Mottley on 1/24/14.
//  Copyright (c) 2014 Kai Strife Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Pokemon;

@interface Pokedex : NSManagedObject

@property (nonatomic, retain) NSSet *pokemon;
@end

@interface Pokedex (CoreDataGeneratedAccessors)

- (void)addPokemonObject:(Pokemon *)value;
- (void)removePokemonObject:(Pokemon *)value;
- (void)addPokemon:(NSSet *)values;
- (void)removePokemon:(NSSet *)values;

@end
