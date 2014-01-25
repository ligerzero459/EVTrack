//
//  Game.h
//  EVTrack
//
//  Created by Ryan Mottley on 1/24/14.
//  Copyright (c) 2014 Kai Strife Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Games, Pokemon;

@interface Game : NSManagedObject

@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Games *games;
@property (nonatomic, retain) NSSet *pokemon;
@end

@interface Game (CoreDataGeneratedAccessors)

- (void)addPokemonObject:(Pokemon *)value;
- (void)removePokemonObject:(Pokemon *)value;
- (void)addPokemon:(NSSet *)values;
- (void)removePokemon:(NSSet *)values;

@end
