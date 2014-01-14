//
//  GameStore.m
//  EVTrack
//
//  Created by Ryan Mottley on 7/17/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import "GameStore.h"
#import "PokemonGame.h"

#import "Pokemon.h"

@interface GameStore ()
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end

@implementation GameStore
{
    AppDelegate *appDelegate;
}

+ (GameStore *)sharedStore
{
    static GameStore *sharedStore = nil;
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
    appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    self = [super init];
    if (self)
    {
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"gamesMigrated"])
        {
            NSString *path = [self itemArchivePath];
            allGames = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
            
            Games *games = [NSEntityDescription insertNewObjectForEntityForName:@"Games" inManagedObjectContext:self.managedObjectContext];
            [games setIndex:[[NSNumber alloc] initWithInt:1]];
            
            if ([allGames count] > 0)
            {
                for (PokemonGame *game in allGames)
                {
                    Game *g = [[DataConverter sharedConverter] convertGame:game];
                    [g setIndex:[[NSNumber alloc] initWithInteger:[allGames indexOfObject:game]]];
                    
                    [games addGameObject:g];
                    [[DataManager manager] saveContext];
                }
            }
            	
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"gamesMigrated"];
        }
    }
    return self;
}

- (NSArray *)allGames
{
    return [[DataManager manager] getGames];
}

- (void)addGame:(Game *)game
{
    if ([[[[appDelegate getData:@"Games"] objectAtIndex:0] index] isEqualToNumber:[[NSNumber alloc] initWithInt:1]])
        [[[appDelegate getData:@"Games"] objectAtIndex:0] addGameObject:game];
    else
        [[[appDelegate getData:@"Games"] objectAtIndex:1] addGameObject:game];
    
    [[DataManager manager] saveContext];
}

- (void)removeGame:(Game *)game
{
    [[DataManager manager] deleteGame:game];
    
    [[DataManager manager] saveContext];
}

- (Game *)gameAtIndex:(NSUInteger)index
{
    return (Game *)[allGames objectAtIndex:index];
}

- (void)wipeData
{
    [[DataManager manager] deleteGames];
    
    Games *g = [[DataManager manager] newGames];
    [g setIndex:[[NSNumber alloc] initWithInt:1]];
    
    [[DataManager manager] saveContext];
}

# pragma mark - Archive operations

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // Get one and only document directory from the list
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"games.archive"];
}

- (void)saveChanges
{
    [[DataManager manager] saveContext];
}

@end
