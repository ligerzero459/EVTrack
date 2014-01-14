//
//  PokemonViewController.m
//  EVTrack
//
//  Created by Ryan Mottley on 6/16/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import "MainViewController.h"
#import "EVPokemonStore.h"
#import "EVPokemon.h"
#import "EVDetailViewController.h"
#import "AddPokemonViewController.h"

@implementation MainViewController

- (id)init
{
    self = [super init];
    
    if (self)
    {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [tView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[EVPokemonStore sharedStore] allPokemon] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
       
    // Creates an instance of UITableViewCell, with default appearance
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EVCell"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EVCell"];
    }
    
    [[cell layer] setBorderColor:[UIColor whiteColor].CGColor];
    [[cell layer] setBorderWidth:1.5f];
    
    // Set the text on the cell with the description of the item
    // that is at the nth index of itmes, where n = row this cell
    // will appear in on the tableview
    
    EVPokemon *p = [[[EVPokemonStore sharedStore] allPokemon] objectAtIndex:[indexPath row]];
    
    // Image on the prototype cell
    UIImageView *sprite = (UIImageView *)[cell viewWithTag:100];
    [sprite setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png", [p pokemonNumber]]]];
    
    // Labels on the prototype cell
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:101];
    [nameLabel setText:[p pokemonName]];
    UILabel *hpLabel = (UILabel *)[cell viewWithTag:102];
    [hpLabel setText:[NSString stringWithFormat:@"%d", [p hp]]];
    UILabel *atkLabel = (UILabel *)[cell viewWithTag:103];
    [atkLabel setText:[NSString stringWithFormat:@"%d", [p attack]]];
    UILabel *defLabel = (UILabel *)[cell viewWithTag:104];
    [defLabel setText:[NSString stringWithFormat:@"%d", [p defense]]];
    UILabel *satkLabel = (UILabel *)[cell viewWithTag:105];
    [satkLabel setText:[NSString stringWithFormat:@"%d", [p spAttack]]];
    UILabel *sdefLabel = (UILabel *)[cell viewWithTag:106];
    [sdefLabel setText:[NSString stringWithFormat:@"%d", [p spDefense]]];
    UILabel *speedLabel = (UILabel *)[cell viewWithTag:107];
    [speedLabel setText:[NSString stringWithFormat:@"%d", [p speed]]];
    
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


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EVPokemonStore *ps = [EVPokemonStore sharedStore];
        NSArray *pokemon = [ps allPokemon];
        EVPokemon *p = [pokemon objectAtIndex:[indexPath row]];
        [ps removePokemon:p];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


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
    // Deselects row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Creates instance of EVDetailViewController
    EVDetailViewController *detailController = [[EVDetailViewController alloc] init];
    
    // Pulls array of Pokemon and grabs selected Pokemon
    NSArray *allPokemon = [[EVPokemonStore sharedStore] allPokemon];
    EVPokemon *p = [allPokemon objectAtIndex:[indexPath row]];
    
    // Passes to the detailController
    [detailController setPokemon:p];
    
    // Pushed detailController onto the stack
    [self.navigationController pushViewController:detailController animated:YES];
    
}

- (void)addPokemonViewControllerDidCancel:(AddPokemonViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addPokemonViewControllerDidAddPokemon:(AddPokemonViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddPokemon"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        AddPokemonViewController *addPokemonViewController = [[navigationController viewControllers] objectAtIndex:0];
        [addPokemonViewController setDelegate:self];
        
    }
}

@end
