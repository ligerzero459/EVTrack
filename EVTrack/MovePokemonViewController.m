//
//  MovePokemonViewController.m
//  EVTrack
//
//  Created by Ryan Mottley on 7/17/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import "MovePokemonViewController.h"
#import "GameStore.h"
#import "PokemonGame.h"

@implementation MovePokemonViewController

@synthesize gameNumber, pokemonNumber;
@synthesize tView;
@synthesize selectedGame, selectedPokemon;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//*****************************************
//            Rotation Methods
//*****************************************

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown)
    {
        return YES;
    }
    else {
        return NO;
    }
}

//*****************************************
//            Table View Methods
//*****************************************

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[GameStore sharedStore] allGames] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"addGameCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    
    Game *p = [[[GameStore sharedStore] allGames] objectAtIndex:[indexPath row]];
    
    [[cell textLabel] setText:[NSString stringWithFormat:@"%@", [p name]]];
    
    [[cell imageView] setImage:[UIImage imageNamed:[p imagePath]]];
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Game *moveTo = [[[GameStore sharedStore] allGames] objectAtIndex:[indexPath row]];
    
    if ([selectedGame isEqual:moveTo])
    {
        [self dismissModal:self];
    }
    else
    {
        [moveTo addPokemonObject:selectedPokemon];
        [selectedGame removePokemonObject:selectedPokemon];
        
        [self dismissModal:self];
    }
}

- (IBAction)dismissModal:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
