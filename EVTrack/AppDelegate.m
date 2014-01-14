//
//  AppDelegate.m
//  EVTrack
//
//  Created by Ryan Mottley on 6/14/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import <BugSense-iOS/BugSenseController.h>

#import "AppDelegate.h"
#import "PokemonGame.h"
#import "EVPokemon.h"
#import "PokemonViewController.h"
#import "EVDetailViewController.h"
#import "PokedexStore.h"
#import "GameTableStore.h"
#import "GameStore.h"

#import "iRate.h"
#import "EVTrackerIAPHelper.h"

// Core Data Models
#import "Games.h"
#import "Game.h"
#import "Pokemon.h"
#import "Pokedex.h"

#import "DataConverter.h"

@interface AppDelegate ()
{
    Pokedex *pokedex;
    Games *games;
}

@end

@implementation AppDelegate
{
    NSUserDefaults *defaults;
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (void)initialize
{
    [[iRate sharedInstance] setDaysUntilPrompt:5];
    [[iRate sharedInstance] setUsesUntilPrompt:10];
    [[iRate sharedInstance] setRemindPeriod:2];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Initialize BugSense
    [BugSenseController sharedControllerWithBugSenseAPIKey:@"e645c125"];
    
    defaults = [NSUserDefaults standardUserDefaults];
    BOOL migratePokedex = [defaults boolForKey:@"migratePokedex"];
    BOOL migrateGames = [defaults boolForKey:@"migrateGames"];
    
    if (!migratePokedex)
    {
        pokedex = [NSEntityDescription insertNewObjectForEntityForName:@"Pokedex" inManagedObjectContext:self.managedObjectContext];
        
        NSString *pathPokedex = [[NSBundle mainBundle] pathForResource:@"PokemonList" ofType:@"plist"];
        NSDictionary *rootPokedex = [[NSDictionary alloc] initWithContentsOfFile:pathPokedex];
        
        for (id key in rootPokedex)
        {
            NSArray *pokemonArray = [[NSArray alloc] initWithArray:[rootPokedex objectForKey:@"Pokemon"]];
            NSDictionary *pokemonEntry = [[NSDictionary alloc] init];
            EVPokemon *pokemon = [[EVPokemon alloc] init];
            
            for (pokemonEntry in pokemonArray)
            {
                [pokemon setPokemonNumber:[[pokemonEntry objectForKey:@"Num"] intValue]];
                [pokemon setPokemonName:[pokemonEntry objectForKey:@"Name"]];
                [pokemon setHp:[[pokemonEntry objectForKey:@"HP"] intValue]];
                [pokemon setAttack:[[pokemonEntry objectForKey:@"Atk"] intValue]];
                [pokemon setDefense:[[pokemonEntry objectForKey:@"Def"] intValue]];
                [pokemon setSpAttack:[[pokemonEntry objectForKey:@"SpAtk"] intValue]];
                [pokemon setSpDefense:[[pokemonEntry objectForKey:@"SpDef"] intValue]];
                [pokemon setSpeed:[[pokemonEntry objectForKey:@"Speed"] intValue]];
                [pokemon setMachoBrace:[[pokemonEntry objectForKey:@"MachoBrace"] boolValue]];
                [pokemon setPowerWeight:[[pokemonEntry objectForKey:@"PowerWeight"] boolValue]];
                [pokemon setPowerLens:[[pokemonEntry objectForKey:@"PowerLens"] boolValue]];
                [pokemon setPowerBracer:[[pokemonEntry objectForKey:@"PowerBracer"] boolValue]];
                [pokemon setPowerBelt:[[pokemonEntry objectForKey:@"PowerBelt"] boolValue]];
                [pokemon setPowerBand:[[pokemonEntry objectForKey:@"PowerBand"] boolValue]];
                [pokemon setPowerAnklet:[[pokemonEntry objectForKey:@"PowerAnklet"] boolValue]];
                [pokemon setPKRS:[[pokemonEntry objectForKey:@"PKRS"] boolValue]];
                
                Pokemon *p = [[DataConverter sharedConverter] convertPokemon:pokemon];
                [p setIndex:[[NSNumber alloc] initWithInteger:[pokemonArray indexOfObject:pokemonEntry]]];
                
                [pokedex addPokemonObject:p];
                
            }
        }
        [defaults setBool:YES forKey:@"migratePokedex"];
    }
    
    if (!migrateGames)
    {
        games = [NSEntityDescription insertNewObjectForEntityForName:@"Games" inManagedObjectContext:self.managedObjectContext];
        [games setIndex:[[NSNumber alloc] initWithInt:0]];
        
        NSString *pathGames = [[NSBundle mainBundle] pathForResource:@"GameList" ofType:@"plist"];
        NSDictionary *rootGames = [[NSDictionary alloc] initWithContentsOfFile:pathGames];
        
        for (id key in rootGames)
        {
            NSArray *gamesArray = [[NSArray alloc] initWithArray:[rootGames objectForKey:@"Game"]];
            NSDictionary *gameEntry = [[NSDictionary alloc] init];
            PokemonGame *game = [[PokemonGame alloc] init];
            for (gameEntry in gamesArray)
            {
                [game setGameName:[gameEntry objectForKey:@"gameName"]];
                [game setImageName:[gameEntry objectForKey:@"imageName"]];
                
                Game *g = [[DataConverter sharedConverter] convertGame:game];
                [g setIndex:[[NSNumber alloc] initWithInteger:[gamesArray indexOfObject:gameEntry]]];
                
                [games addGameObject:g];
            }
        }
        [defaults setBool:YES forKey:@"migrateGames"];
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[GameStore sharedStore] saveChanges];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[GameStore sharedStore] saveChanges];
}

#pragma mark - Core Data

- (NSManagedObjectContext *) managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
                                               stringByAppendingPathComponent: @"EVTracker.sqlite"]];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                   initWithManagedObjectModel:[self managedObjectModel]];
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil URL:storeUrl options:nil error:&error]) {
        /*Error for store creation should be handled in here*/
    }
    
    return _persistentStoreCoordinator;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSArray *)getData:(NSString *)identifier
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:identifier
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    
    NSArray *fetchedData = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return fetchedData;
}

@end
