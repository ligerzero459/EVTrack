//
//  PokemonViewController.m
//  EVTrack
//
//  Created by Ryan Mottley on 6/16/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import "PokemonViewController.h"
#import "GameStore.h"
#import "EVPokemon.h"
#import "PokemonGame.h"
#import "EVDetailViewController.h"
#import "AdvancedDetailViewController.h"
#import "AddPokemonViewController.h"
#import "MovePokemonViewController.h"

#import "AppDelegate.h"
#import "Game.h"
#import "Pokemon.h"

@implementation PokemonViewController
{
    NSIndexPath *editingIndexPath;
    UITableView *editingTableView;
    NSArray *allPokemon;
}

@synthesize editButton, bottomToolbar;
@synthesize gameNumber;
@synthesize selectedGame;


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
    
    [tView setAllowsSelectionDuringEditing:YES];
    [tView reloadData];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

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

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    CGRect toolbarFrame = bottomToolbar.frame;
    CGFloat newOriginY = tView.contentOffset.y + tView.frame.size.height - toolbarFrame.size.height;
    bottomToolbar.frame = CGRectMake(toolbarFrame.origin.x, newOriginY, toolbarFrame.size.width, toolbarFrame.size.height);
    toolbarFrame = bottomToolbar.frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationItem setTitle:[selectedGame name]];
    
    allPokemon = [[DataManager manager] getPokemon:selectedGame];
    
    [tView reloadData];
    
    CGRect toolbarFrame = bottomToolbar.frame;
    CGFloat newOriginY = tView.contentOffset.y + tView.frame.size.height - toolbarFrame.size.height;
    bottomToolbar.frame = CGRectMake(toolbarFrame.origin.x, newOriginY, toolbarFrame.size.width, toolbarFrame.size.height);
    toolbarFrame = bottomToolbar.frame;
}

//*****************************************
//            Table View Methods
//*****************************************

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [allPokemon count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
       
    // Creates an instance of UITableViewCell, with default appearance
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EVCell"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EVCell"];
        
    }
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [cell addGestureRecognizer:longPressGesture];
    
    // Set the text on the cell with the description of the item
    // that is at the nth index of itmes, where n = row this cell
    // will appear in on the tableview
    
    Pokemon *p = [allPokemon objectAtIndex:[indexPath row]];
    
    // Image on the prototype cell
    UIImageView *sprite = (UIImageView *)[cell viewWithTag:100];
    
    if ([p number].intValue < 10)
    {
        [sprite setImage:[UIImage imageNamed:[NSString stringWithFormat:@"00%d.png", [p number].intValue]]];
    }
    else if ([p number].intValue < 100)
    {
        [sprite setImage:[UIImage imageNamed:[NSString stringWithFormat:@"0%d.png", [p number].intValue]]];
    }
    else
    {
        [sprite setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png", [p number].intValue]]];
    }
    
    // Labels on the prototype cell
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:101];
    [nameLabel setText:[p name]];
    UILabel *hpLabel = (UILabel *)[cell viewWithTag:102];
    [hpLabel setText:[NSString stringWithFormat:@"%d", [p hp].intValue]];
    UILabel *atkLabel = (UILabel *)[cell viewWithTag:103];
    [atkLabel setText:[NSString stringWithFormat:@"%d", [p attack].intValue]];
    UILabel *defLabel = (UILabel *)[cell viewWithTag:104];
    [defLabel setText:[NSString stringWithFormat:@"%d", [p defense].intValue]];
    UILabel *satkLabel = (UILabel *)[cell viewWithTag:105];
    [satkLabel setText:[NSString stringWithFormat:@"%d", [p spattack].intValue]];
    UILabel *sdefLabel = (UILabel *)[cell viewWithTag:106];
    [sdefLabel setText:[NSString stringWithFormat:@"%d", [p spdefense].intValue]];
    UILabel *speedLabel = (UILabel *)[cell viewWithTag:107];
    [speedLabel setText:[NSString stringWithFormat:@"%d", [p speed].intValue]];
    
    return cell;
}

- (void)longPress:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        // get affected cell
		UITableViewCell *cell = (UITableViewCell *)[gesture view];
        
		// get indexPath of cell
		NSIndexPath *indexPath = [tView indexPathForCell:cell];
        
        editingIndexPath = indexPath;
        editingTableView = tView;
        
        UIAlertView *editAlert = [[UIAlertView alloc] initWithTitle:@"Options" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Move", @"Delete", nil];
        [editAlert show];
    }
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
        //[allPokemon removeObjectAtIndex:[indexPath row]];
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [[DataManager manager] deletePokemon:[allPokemon objectAtIndex:[indexPath row]] fromGame:selectedGame];
        allPokemon = [[DataManager manager] getPokemon:selectedGame];
        
        [tableView endUpdates];
        
        CGRect toolbarFrame = bottomToolbar.frame;
        CGFloat newOriginY = tView.contentOffset.y + tView.frame.size.height - toolbarFrame.size.height;
        bottomToolbar.frame = CGRectMake(toolbarFrame.origin.x, newOriginY, toolbarFrame.size.width, toolbarFrame.size.height);
        toolbarFrame = bottomToolbar.frame;
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSMutableArray *allP = [NSMutableArray arrayWithArray:allPokemon];
    if (![fromIndexPath isEqual:toIndexPath])
    {
        Pokemon *pokemon = [allP objectAtIndex:[fromIndexPath row]];
        [allP removeObjectAtIndex:[fromIndexPath row]];
        [allP insertObject:pokemon atIndex:[toIndexPath row]];
    }
    
    for (Pokemon *p in allP)
    {
        [p setIndex:[[NSNumber alloc] initWithInteger:[allP indexOfObject:p]]];
    }
    
    [[DataManager manager] saveContext];
    allPokemon = [[DataManager manager] getPokemon:selectedGame];
}


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
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [editButton setTitle:@"Done"];
    [editButton setStyle:UIBarButtonItemStyleDone];
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [editButton setTitle:@"Edit"];
    [editButton setStyle:UIBarButtonItemStyleBordered];
}

//*****************************************
//            ScrollView Methods
//*****************************************

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect toolbarFrame = bottomToolbar.frame;
    CGFloat newOriginY = tView.contentOffset.y + tView.frame.size.height - toolbarFrame.size.height;
    bottomToolbar.frame = CGRectMake(toolbarFrame.origin.x, newOriginY, toolbarFrame.size.width, toolbarFrame.size.height);
    toolbarFrame = bottomToolbar.frame;
}

//*****************************************
//         Add Pokemon Delegate Code
//*****************************************

- (void)addPokemonViewControllerDidCancel:(AddPokemonViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addPokemonViewControllerDidAddPokemon:(AddPokemonViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//*****************************************
//             Segue Methods
//*****************************************

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddPokemon"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        AddPokemonViewController *addPokemonViewController = [[navigationController viewControllers] objectAtIndex:0];
        addPokemonViewController.gameNumber = gameNumber;
        [addPokemonViewController setGame:selectedGame];
        [addPokemonViewController setDelegate:addPokemonViewController];
    }
    else if ([segue.identifier isEqualToString:@"EVDetails"])
    {
        AdvancedDetailViewController *advDetail = segue.destinationViewController;
        NSIndexPath *indexPath = [tView indexPathForSelectedRow];
        
        // Pulls array of Pokemon and grabs selected Pokemon
        Pokemon *p = [allPokemon objectAtIndex:[indexPath row]];
        
        advDetail.pokemon = p;
    }
    else if ([segue.identifier isEqualToString:@"movePokemon"])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        MovePokemonViewController *mpvc = [[navigationController viewControllers] objectAtIndex:0];
        mpvc.gameNumber = gameNumber;
        mpvc.pokemonNumber = [editingIndexPath row];
        mpvc.selectedGame = selectedGame;
        mpvc.selectedPokemon = [allPokemon objectAtIndex:[editingIndexPath row]];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([tView isEditing])
    {
        return NO;
    }
    else return YES;
}

//*****************************************
//             Alert View Code
//*****************************************

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Move"])
    {
        [tView setEditing:NO animated:YES];
        [self performSegueWithIdentifier:@"movePokemon" sender:self];
    }
    else if ([title isEqualToString:@"Delete"])
    {
        [self tableView:editingTableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:editingIndexPath];
    }
}

- (void)viewDidUnload {
    [self setEditButton:nil];
    [self setBottomToolbar:nil];
    [super viewDidUnload];
}

- (IBAction)editButtonPressed:(id)sender {
    if ([tView isEditing])
    {
        [editButton setTitle:@"Edit"];
        [editButton setStyle:UIBarButtonItemStyleBordered];
        [tView setEditing:NO animated:YES];
    }
    else
    {
        [editButton setTitle:@"Done"];
        [editButton setStyle:UIBarButtonItemStyleDone];
        [tView setEditing:YES animated:YES];
    }
}

@end
