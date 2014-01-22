//
//  AddGameViewController.m
//  EVTrack
//
//  Created by Ryan Mottley on 7/18/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import "AddGameViewController.h"
#import "GameStore.h"
#import "GameTableStore.h"
#import "PokemonGame.h"

#import "AppDelegate.h"
#import "Games.h"
#import "Game.h"

@interface AddGameViewController ()
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end

@implementation AddGameViewController
{
    NSArray *searchResults;
    ADBannerView *adView;
    NSArray *allGames;
    AppDelegate *appDelegate;
}

@synthesize tView;

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
    
    appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    allGames = [[DataManager manager] getAllGames];

    // Adding iAd to tableView
    BOOL disabledAds = [[NSUserDefaults standardUserDefaults] boolForKey:@"com.kaistrifeproductions.EVTracker.removeAds"];
    if (!disabledAds)
    {
        NSLog(@"Adding Ad View");
        adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
        [adView setDelegate:self];
        [adView setHidden:YES];
        if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortrait)
        {
            adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
        }
        else adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
        
        tView.tableFooterView = adView;
    }
    else
    {
        adView = nil;
    }
    
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    // Placing it at the bottom so you don't have to scroll
    CGRect adViewFrame = adView.frame;
    CGFloat newOriginY = tView.frame.size.height - adViewFrame.size.height;
    adView.frame = CGRectMake(adViewFrame.origin.x, newOriginY, adViewFrame.size.width, adViewFrame.size.height);
    adViewFrame = adView.frame;
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

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
    {
        adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    }
    else if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation))
    {
        adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    CGRect adViewFrame = adView.frame;
    CGFloat newOriginY = tView.contentOffset.y + tView.frame.size.height - adViewFrame.size.height;
    adView.frame = CGRectMake(adViewFrame.origin.x, newOriginY, adViewFrame.size.width, adViewFrame.size.height);
    adViewFrame = adView.frame;
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
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [searchResults count];
    }
    else
    {
        return [allGames count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"addGameCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        Game *g = [searchResults objectAtIndex:[indexPath row]];
        
        [[cell textLabel] setText:[NSString stringWithFormat:@"%@", [g name]]];
        
        [[cell imageView] setImage:[UIImage imageNamed:[g imagePath]]];
    }
    else
    {
        Game *g = [allGames objectAtIndex:[indexPath row]];
        
        [[cell textLabel] setText:[NSString stringWithFormat:@"%@", [g name]]];
        
        [[cell imageView] setImage:[UIImage imageNamed:[g imagePath]]];
    }
    
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
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        Game *selected = [searchResults objectAtIndex:[indexPath row]];
        Game *g = [[DataManager manager] newGame];
        [g setName:[selected name]];
        [g setImagePath:[selected imagePath]];
        [g setIndex:[NSNumber numberWithInteger:[[[GameStore sharedStore] allGames] count]]];
        [[GameStore sharedStore] addGame:g];
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        Game *selected = [allGames objectAtIndex:[indexPath row]];
        Game *g = [[DataManager manager] newGame];
        [g setName:[selected name]];
        [g setImagePath:[selected imagePath]];
        [g setIndex:[NSNumber numberWithInteger:[[[GameStore sharedStore] allGames] count]]];
        [[GameStore sharedStore] addGame:g];
    }
    
    [self done:self];
}

# pragma mark - Search methods

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@", searchText];
    
    searchResults = [allGames filteredArrayUsingPredicate:resultPredicate];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

//*****************************************
//            ScrollView Methods
//*****************************************

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Getting table and search bar bounds
    CGRect tableBounds = self.tableView.bounds;
    CGRect searchBarFrame = self.searchDisplayController.searchBar.frame;
    
    [scrollView layoutSubviews];
    
    self.searchDisplayController.searchBar.frame = CGRectMake(tableBounds.origin.x, tableBounds.origin.y, searchBarFrame.size.width, searchBarFrame.size.height);
    
    CGRect adViewFrame = adView.frame;
    CGFloat newOriginY = tView.contentOffset.y + tView.frame.size.height - adViewFrame.size.height;
    adView.frame = CGRectMake(adViewFrame.origin.x, newOriginY, adViewFrame.size.width, adViewFrame.size.height);
    adViewFrame = adView.frame;
}

//*****************************************
//            iAd View Methods
//*****************************************

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    BOOL disabledAds = [[NSUserDefaults standardUserDefaults] boolForKey:@"com.kaistrifeproductions.EVTracker.removeAds"];
    if (!disabledAds)
    {
        [adView setHidden:NO];
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    BOOL disabledAds = [[NSUserDefaults standardUserDefaults] boolForKey:@"com.kaistrifeproductions.EVTracker.removeAds"];
    if (!disabledAds)
    {
        [adView setHidden:YES];
    }
}

//*****************************************
//           Cancel/Done Methods
//*****************************************

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
