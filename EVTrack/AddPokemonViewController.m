//
//  AddPokemonViewController.m
//  EVTrack
//
//  Created by Ryan Mottley on 6/19/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import "AddPokemonViewController.h"
#import "EVPokemon.h"
#import "PokedexStore.h"
#import "GameStore.h"
#import "PokemonGame.h"

#import "AppDelegate.h"
#import "Pokemon.h"
#import "Game.h"

@implementation AddPokemonViewController
{
    NSArray *searchResults;
    NSArray *pokedex;
    ADBannerView *adView;
    BOOL recievedAd;
    AppDelegate *appDelegate;
}

@synthesize tView, gameNumber;
@synthesize selectedGame;
@synthesize allPokemon = _allPokemon;

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Adding iAd to tableView
    appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    pokedex = [[DataManager manager] getPokedex];
    
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

- (void)dealloc
{
    self.searchDisplayController.delegate = nil;
    self.searchDisplayController.searchResultsDelegate = nil;
    self.searchDisplayController.searchResultsDataSource = nil;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender
{
    [self addPokemonViewControllerDidCancel:self];
}

- (IBAction)done:(id)sender
{
    [self addPokemonViewControllerDidAddPokemon:self];
}

- (void)addPokemonViewControllerDidCancel:(AddPokemonViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addPokemonViewControllerDidAddPokemon:(AddPokemonViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//*****************************************
//            Table View Methods
//*****************************************

# pragma mark - Table methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"addPokemonCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        Pokemon *p = [searchResults objectAtIndex:[indexPath row]];
        
        [[cell textLabel] setText:[NSString stringWithFormat:@"#%d %@", [p number].intValue, [p name]]];
        
        if ([[p number] intValue] < 10)
        {
            [[cell imageView] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"00%d.png", [[p number] intValue]]]];
        }
        else if ([[p number] intValue] < 100)
        {
            [[cell imageView] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"0%d.png", [[p number] intValue]]]];
        }
        else
        {
            [[cell imageView] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png", [[p number] intValue]]]];
        }
        
        [[cell textLabel] setText:[NSString stringWithFormat:@"#%d %@", [[p number] intValue], [p name]]];
    }
    else
    {
        Pokemon *p = [pokedex objectAtIndex:[indexPath row]];
        
        [[cell textLabel] setText:[NSString stringWithFormat:@"#%d %@", [p number].intValue, [p name]]];
        
        if ([[p number] intValue] < 10)
        {
            [[cell imageView] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"00%d.png", [[p number] intValue]]]];
        }
        else if ([[p number] intValue] < 100)
        {
            [[cell imageView] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"0%d.png", [[p number] intValue]]]];
        }
        else
        {
            [[cell imageView] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png", [[p number] intValue]]]];
        }
        
        [[cell textLabel] setText:[NSString stringWithFormat:@"#%d %@", [[p number] intValue], [p name]]];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [searchResults count];
    }
    else
    {
        return [pokedex count];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
        Pokemon *p = [searchResults objectAtIndex:[indexPath row]];
        Pokemon *newPokemon = [NSEntityDescription insertNewObjectForEntityForName:@"Pokemon" inManagedObjectContext:self.managedObjectContext];
        [newPokemon setIndex:[[NSNumber alloc] initWithInteger:[[[DataManager manager] getPokemon:selectedGame] count]]];
        [newPokemon setName:[p name]];
        [newPokemon setNumber:[p number]];
        
        [selectedGame addPokemonObject:newPokemon];
        [[DataManager manager] saveContext];
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        Pokemon *p = [pokedex objectAtIndex:[indexPath row]];
        Pokemon *newPokemon = [NSEntityDescription insertNewObjectForEntityForName:@"Pokemon" inManagedObjectContext:self.managedObjectContext];
        [newPokemon setIndex:[[NSNumber alloc] initWithInteger:[[[DataManager manager] getPokemon:selectedGame] count]]];
        [newPokemon setName:[p name]];
        [newPokemon setNumber:[p number]];
        
        [selectedGame addPokemonObject:newPokemon];
        [[DataManager manager] saveContext];
    }
    
    [self done:self];
}

# pragma mark - Table Section methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/*- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSArray *sectionTitles = [[NSArray alloc] initWithObjects:@"Generation 1", @"Generation 2", @"Generation 3", @"Generation 4", @"Generation 5",nil];
    
    return sectionTitles;
}*/

# pragma mark - Search methods

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@", searchText];
    
    searchResults = [pokedex filteredArrayUsingPredicate:resultPredicate];
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

- (void)setGame:(Game *)game
{
    selectedGame = game;
}

@end
