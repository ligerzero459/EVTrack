//
//  BattledPokemonViewController.m
//  EVTrack
//
//  Created by Ryan Mottley on 7/2/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import "BattledPokemonViewController.h"
#import "EVPokemon.h"
#import "PokedexStore.h"
#import "AdvancedDetailViewController.h"

@implementation BattledPokemonViewController
{
    NSArray *searchResults;
    ADBannerView *adView;
}

// Synthesizing variables
@synthesize pokemon, parentController;
@synthesize tView;
// Synthesizing outlets


//******************************
//        Synthesis end
//******************************

//*****************************************
//          Initialization Methods
//*****************************************

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
    
    // Adding iAd to tableView
    
    BOOL disabledAds = [[NSUserDefaults standardUserDefaults] boolForKey:@"com.kaistrifeproductions.EVTracker.disableAds"];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    // Placing it at the bottom so you don't have to scroll
    CGRect adViewFrame = adView.frame;
    CGFloat newOriginY = tView.frame.size.height - adViewFrame.size.height;
    adView.frame = CGRectMake(adViewFrame.origin.x, newOriginY, adViewFrame.size.width, adViewFrame.size.height);
    adViewFrame = adView.frame;
}

- (IBAction)dismissModal:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//****************************************
//           Table View Methods
//****************************************

# pragma mark - Table methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"PokemonCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        Pokemon *p = [searchResults objectAtIndex:[indexPath row]];
        
        [[cell textLabel] setText:[NSString stringWithFormat:@"#%@ %@", [p number], [p name]]];
        
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
    }
    else
    {
        Pokemon *p = [[[DataManager manager] getPokedex] objectAtIndex:[indexPath row]];
        
        [[cell textLabel] setText:[NSString stringWithFormat:@"#%@ %@", [p number], [p name]]];
        
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
        return [[[DataManager manager] getPokedex] count];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Pokemon *p;
    int multiplier = 1;
    
    // Determines pokemon selected from table
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        p = [searchResults objectAtIndex:[indexPath row]];
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        p = [[[DataManager manager] getPokedex] objectAtIndex:[indexPath row]];
        
    }
    
    // Sets multiplier based on items/pkrs
    if ([pokemon machoBrace] && [pokemon pkrs])
    {
        multiplier = 4;
    }
    else if ([pokemon machoBrace] || [pokemon pkrs])
    {
        multiplier = 2;
    }
    else
    {
        multiplier = 1;
    }
    
    // Adds EVs while checking for items
    // Should solve logic error on EV addition
    if ([pokemon powerWeight])
        [pokemon setHp:[NSNumber numberWithInt:([pokemon hp].intValue + (([p hp].intValue + 4) * multiplier))]];
    else
        [pokemon setHp:[NSNumber numberWithInt:([pokemon hp].intValue + [p hp].intValue * multiplier)]];
    
    if ([pokemon powerBracer])
        [pokemon setAttack:[NSNumber numberWithInt:([pokemon attack].intValue + (([p attack].intValue + 4) * multiplier))]];
    else
        [pokemon setAttack:[NSNumber numberWithInt:([pokemon attack].intValue + [p attack].intValue * multiplier)]];
    
    if ([pokemon powerBelt])
        [pokemon setDefense:[NSNumber numberWithInt:([pokemon defense].intValue + (([p defense].intValue + 4) * multiplier))]];
    else
        [pokemon setDefense:[NSNumber numberWithInt:([pokemon defense].intValue + [p defense].intValue * multiplier)]];
    
    if ([pokemon powerLens])
        [pokemon setSpattack:[NSNumber numberWithInt:([pokemon spattack].intValue + (([p spattack].intValue + 4) * multiplier))]];
    else
        [pokemon setSpattack:[NSNumber numberWithInt:([pokemon spattack].intValue + [p spattack].intValue * multiplier)]];
    
    if ([pokemon powerBand])
        [pokemon setSpdefense:[NSNumber numberWithInt:([pokemon spdefense].intValue + (([p spdefense].intValue + 4) * multiplier))]];
    else
        [pokemon setSpdefense:[NSNumber numberWithInt:([pokemon spdefense].intValue + [p spdefense].intValue * multiplier)]];
    
    if ([pokemon powerAnklet])
        [pokemon setSpeed:[NSNumber numberWithInt:([pokemon speed].intValue + (([p speed].intValue + 4) * multiplier))]];
    else
        [pokemon setSpeed:[NSNumber numberWithInt:([pokemon speed].intValue + [p speed].intValue * multiplier)]];
    
    parentController.pokemon = pokemon;
    
    [[DataManager manager] saveContext];
    [self dismissViewControllerAnimated:YES completion:nil];
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

//*****************************************
//           Search Bar Methods
//*****************************************

# pragma mark - Search methods

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@", searchText];
    
    searchResults = [[[DataManager manager] getPokedex] filteredArrayUsingPredicate:resultPredicate];
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
    CGRect tableBounds = tView.bounds;
    CGRect searchBarFrame = self.searchDisplayController.searchBar.frame;
    
    [scrollView layoutSubviews];
    
    self.searchDisplayController.searchBar.frame = CGRectMake(tableBounds.origin.x, tableBounds.origin.y, searchBarFrame.size.width, searchBarFrame.size.height);
    
    CGRect adViewFrame = adView.frame;
    CGFloat newOriginY = tView.contentOffset.y + tView.frame.size.height - adViewFrame.size.height;
    adView.frame = CGRectMake(adViewFrame.origin.x, newOriginY, adViewFrame.size.width, adViewFrame.size.height);
    adViewFrame = adView.frame;
}

- (void)viewDidUnload {
    [self setTView:nil];
    [super viewDidUnload];
}

//*****************************************
//              Ad View Methods
//*****************************************

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    BOOL disabledAds = [[NSUserDefaults standardUserDefaults] boolForKey:@"com.kaistrifeproductions.EVTracker.disableAds"];
    if (!disabledAds)
    {
        [adView setHidden:NO];
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    BOOL disabledAds = [[NSUserDefaults standardUserDefaults] boolForKey:@"com.kaistrifeproductions.EVTracker.disableAds"];
    if (!disabledAds)
    {
        [adView setHidden:YES];
    }
}

@end
