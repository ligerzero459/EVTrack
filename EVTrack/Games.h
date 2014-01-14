//
//  Games.h
//  EVTrack
//
//  Created by Ryan Mottley on 12/28/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Game;

@interface Games : NSManagedObject

@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSSet *game;
@end

@interface Games (CoreDataGeneratedAccessors)

- (void)addGameObject:(Game *)value;
- (void)removeGameObject:(Game *)value;
- (void)addGame:(NSSet *)values;
- (void)removeGame:(NSSet *)values;

@end
