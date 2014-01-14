//
//  GameStore.h
//  EVTrack
//
//  Created by Ryan Mottley on 7/17/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "Games.h"
#import "Game.h"

@interface GameStore : NSObject
{
    NSArray *allGames;
}

+ (GameStore *)sharedStore;

- (NSArray *)allGames;
- (Game *)gameAtIndex:(NSUInteger)index;
- (void)addGame:(Game *)game;
- (void)removeGame:(Game *)game;
- (void)wipeData;

- (NSString *)itemArchivePath;
- (void)saveChanges;

@end
