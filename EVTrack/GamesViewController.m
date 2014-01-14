//
//  GamesViewController.m
//  EVTrack
//
//  Created by Ryan Mottley on 7/18/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import "GamesViewController.h"
#import "PokemonViewController.h"
#import "iPadPokemonViewController.h"
#import "GameStore.h"
#import "PokemonGame.h"

#import "Game.h"

@implementation GamesViewController
{
    NSString *version;
    NSString *savedVersion;
    NSArray *games;
}

@synthesize tView, editButton;

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
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    version = infoDictionary[(NSString *)kCFBundleVersionKey];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    savedVersion = [defaults stringForKey:@"versionNum"];
    
    if (![version isEqualToString:savedVersion])
    {
        [defaults setValue:version forKey:@"versionNum"];
        [self performSegueWithIdentifier:@"updateInfo" sender:self];
    }
    
    // [self performSegueWithIdentifier:@"updateInfo" sender:self];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)awakeFromNib
{
    self.splitViewController.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    games = [[GameStore sharedStore] allGames];
    
    [tView reloadData];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [games count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"gameCell"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"gameCell"];
    }
    
    Game *p = [games objectAtIndex:[indexPath row]];
    
    [[cell textLabel] setText:[p name]];
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


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView beginUpdates];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [[GameStore sharedStore] removeGame:[games objectAtIndex:[indexPath row]]];
        games = [[GameStore sharedStore] allGames];
        
        [tableView endUpdates];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSMutableArray *allG = [NSMutableArray arrayWithArray:[[GameStore sharedStore] allGames]];
    if (![fromIndexPath isEqual:toIndexPath])
    {
        Game *game = [games objectAtIndex:[fromIndexPath row]];
        [allG removeObjectAtIndex:[fromIndexPath row]];
        [allG insertObject:game atIndex:[toIndexPath row]];
    }
    
    for (Game *g in allG)
    {
        [g setIndex:[[NSNumber alloc] initWithInteger:[allG indexOfObject:g]]];
    }
    
    [[DataManager manager] saveContext];
    games = [[GameStore sharedStore] allGames];
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
    
}

//*****************************************
//             Segue Methods
//*****************************************

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EVScreen"]) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            PokemonViewController *pvc = segue.destinationViewController;
            NSIndexPath *indexPath = [tView indexPathForSelectedRow];
            
            pvc.gameNumber = [indexPath row];
            pvc.selectedGame = [[[GameStore sharedStore] allGames] objectAtIndex:[indexPath row]];
        }
        else
        {
            iPadPokemonViewController *ipvc = segue.destinationViewController;
            NSIndexPath *indexPath = [tView indexPathForSelectedRow];
            
            //ipvc.gameNumber = [indexPath row];
            ipvc.selectedGame = [[[GameStore sharedStore] allGames] objectAtIndex:[indexPath row]];
        }
    }
}

//*****************************************
//            Split View Methods
//*****************************************

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    if (UIInterfaceOrientationIsPortrait(orientation))
    {
        return NO;
    }
    else
    {
        return NO;
    }
}

//*****************************************
//             Editing Methods
//*****************************************

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
