//
//  PokedexViewController.m
//  EVTrack
//
//  Created by Ryan Mottley on 6/20/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import "PokedexViewController.h"
#import "EVPokemon.h"
#import "PokedexStore.h"

#import "AppDelegate.h"
#import "Pokedex.h"
#import "Pokemon.h"

@interface PokedexViewController ()
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end

@implementation PokedexViewController
{
    NSArray *searchResults;
    ADBannerView *adView;
    NSArray *pokedex;
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
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    pokedex = [[DataManager manager] getPokedex];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [tView reloadData];
    
    CGRect tableBounds = tView.bounds;
    CGRect searchBarFrame = self.searchDisplayController.searchBar.frame;
    
    [tView layoutSubviews];
    
    self.searchDisplayController.searchBar.frame = CGRectMake(tableBounds.origin.x, tableBounds.origin.y, searchBarFrame.size.width, searchBarFrame.size.height);
    
    // Placing it at the bottom so you don't have to scroll
    CGRect adViewFrame = adView.frame;
    CGFloat newOriginY = tView.contentOffset.y + tView.frame.size.height - adViewFrame.size.height;
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
        
        UIImageView *sprite = (UIImageView *)[cell viewWithTag:1000];
        if ([[p number] intValue] < 10)
        {
            [sprite setImage:[UIImage imageNamed:[NSString stringWithFormat:@"00%d.png", [[p number] intValue]]]];
        }
        else if ([[p number] intValue] < 100)
        {
            [sprite setImage:[UIImage imageNamed:[NSString stringWithFormat:@"0%d.png", [[p number] intValue]]]];
        }
        else
        {
            [sprite setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png", [[p number] intValue]]]];
        }
        
        // Labels on the prototype cell
        UILabel *nameLabel = (UILabel *)[cell viewWithTag:1010];
        [nameLabel setText:[NSString stringWithFormat:@"#%d %@", [[p number] intValue], [p name]]];
        
        UILabel *firstEV = (UILabel *)[cell viewWithTag:1050];
        UILabel *firstEVDetail = (UILabel *)[cell viewWithTag:1060];
        UILabel *secondEV = (UILabel *)[cell viewWithTag:1070];
        UILabel *secondEVDetail = (UILabel *)[cell viewWithTag:1080];
        UILabel *thirdEV = (UILabel *)[cell viewWithTag:1081];
        UILabel *thirdEVDetail = (UILabel *)[cell viewWithTag:1082];
        
        [firstEV setHidden:YES];
        [firstEVDetail setHidden:YES];
        [secondEV setHidden:YES];
        [secondEVDetail setHidden:YES];
        [thirdEV setHidden:YES];
        [thirdEVDetail setHidden:YES];
        
        if ([p hp].intValue > 0)
        {
            [firstEV setHidden:NO];
            [firstEVDetail setHidden:NO];
            
            [firstEV setText:@"HP"];
            [firstEV setTextColor:[UIColor colorWithRed:0.89 green:0.15 blue:0.008 alpha:1]];
            [firstEVDetail setText:[NSString stringWithFormat:@"%d", [p hp].intValue]];
            [firstEVDetail setTextColor:[UIColor colorWithRed:0.89 green:0.15 blue:0.008 alpha:1]];
        }
        if ([p attack].intValue > 0)
        {
            if ([firstEV isHidden])
            {
                [firstEV setHidden:NO];
                [firstEVDetail setHidden:NO];
                
                [firstEV setText:@"Atk"];
                [firstEV setTextColor:[UIColor orangeColor]];
                [firstEVDetail setText:[NSString stringWithFormat:@"%d", [p attack].intValue]];
                [firstEVDetail setTextColor:[UIColor orangeColor]];
            }
            else if ([secondEV isHidden])
            {
                [secondEV setHidden:NO];
                [secondEVDetail setHidden:NO];
                
                [secondEV setText:@"Atk"];
                [secondEV setTextColor:[UIColor orangeColor]];
                [secondEVDetail setText:[NSString stringWithFormat:@"%d", [p attack].intValue]];
                [secondEVDetail setTextColor:[UIColor orangeColor]];
            }
        }
        if ([p defense].intValue > 0)
        {
            if ([firstEV isHidden])
            {
                [firstEV setHidden:NO];
                [firstEVDetail setHidden:NO];
                
                [firstEV setText:@"Def"];
                [firstEV setTextColor:[UIColor yellowColor]];
                [firstEVDetail setText:[NSString stringWithFormat:@"%d", [p defense].intValue]];
                [firstEVDetail setTextColor:[UIColor yellowColor]];
            }
            else if ([secondEV isHidden])
            {
                [secondEV setHidden:NO];
                [secondEVDetail setHidden:NO];
                
                [secondEV setText:@"Def"];
                [secondEV setTextColor:[UIColor yellowColor]];
                [secondEVDetail setText:[NSString stringWithFormat:@"%d", [p defense].intValue]];
                [secondEVDetail setTextColor:[UIColor yellowColor]];
            }
            else
            {
                [thirdEV setHidden:NO];
                [thirdEVDetail setHidden:NO];
                
                [thirdEV setText:@"Def"];
                [thirdEV setTextColor:[UIColor yellowColor]];
                [thirdEVDetail setText:[NSString stringWithFormat:@"%d", [p defense].intValue]];
                [thirdEVDetail setTextColor:[UIColor yellowColor]];
            }
        }
        if ([p spattack].intValue > 0)
        {
            if ([firstEV isHidden])
            {
                [firstEV setHidden:NO];
                [firstEVDetail setHidden:NO];
                
                [firstEV setText:@"SpAtk"];
                [firstEV setTextColor:[UIColor colorWithRed:0 green:0.53 blue:0.89 alpha:1]];
                [firstEVDetail setText:[NSString stringWithFormat:@"%d", [p spattack].intValue]];
                [firstEVDetail setTextColor:[UIColor colorWithRed:0 green:0.53 blue:0.89 alpha:1]];
            }
            else if ([secondEV isHidden])
            {
                [secondEV setHidden:NO];
                [secondEVDetail setHidden:NO];
                
                [secondEV setText:@"SpAtk"];
                [secondEV setTextColor:[UIColor colorWithRed:0 green:0.53 blue:0.89 alpha:1]];
                [secondEVDetail setText:[NSString stringWithFormat:@"%d", [p spattack].intValue]];
                [secondEVDetail setTextColor:[UIColor colorWithRed:0 green:0.53 blue:0.89 alpha:1]];
            }
            else
            {
                [thirdEV setHidden:NO];
                [thirdEVDetail setHidden:NO];
                
                [thirdEV setText:@"SpAtk"];
                [thirdEV setTextColor:[UIColor colorWithRed:0 green:0.53 blue:0.89 alpha:1]];
                [thirdEVDetail setText:[NSString stringWithFormat:@"%d", [p spattack].intValue]];
                [thirdEVDetail setTextColor:[UIColor colorWithRed:0 green:0.53 blue:0.89 alpha:1]];
            }
        }
        if ([p spdefense].intValue > 0)
        {
            if ([firstEV isHidden])
            {
                [firstEV setHidden:NO];
                [firstEVDetail setHidden:NO];
                
                [firstEV setText:@"SpDef"];
                [firstEV setTextColor:[UIColor greenColor]];
                [firstEVDetail setText:[NSString stringWithFormat:@"%d", [p spdefense].intValue]];
                [firstEVDetail setTextColor:[UIColor greenColor]];
            }
            else if ([secondEV isHidden])
            {
                [secondEV setHidden:NO];
                [secondEVDetail setHidden:NO];
                
                [secondEV setText:@"SpDef"];
                [secondEV setTextColor:[UIColor greenColor]];
                [secondEVDetail setText:[NSString stringWithFormat:@"%d", [p spdefense].intValue]];
                [secondEVDetail setTextColor:[UIColor greenColor]];
            }
            else
            {
                [thirdEV setHidden:NO];
                [thirdEVDetail setHidden:NO];
                
                [thirdEV setText:@"SpDef"];
                [thirdEV setTextColor:[UIColor greenColor]];
                [thirdEVDetail setText:[NSString stringWithFormat:@"%d", [p spdefense].intValue]];
                [thirdEVDetail setTextColor:[UIColor greenColor]];
            }
        }
        if ([p speed].intValue > 0)
        {
            if ([firstEV isHidden])
            {
                [firstEV setHidden:NO];
                [firstEVDetail setHidden:NO];
                
                [firstEV setText:@"Speed"];
                [firstEV setTextColor:[UIColor colorWithRed:0.96 green:0.21 blue:0.91 alpha:1]];
                [firstEVDetail setText:[NSString stringWithFormat:@"%d", [p speed].intValue]];
                [firstEVDetail setTextColor:[UIColor colorWithRed:0.96 green:0.21 blue:0.91 alpha:1]];
            }
            else if ([secondEV isHidden])
            {
                [secondEV setHidden:NO];
                [secondEVDetail setHidden:NO];
                
                [secondEV setText:@"Speed"];
                [secondEV setTextColor:[UIColor colorWithRed:0.96 green:0.21 blue:0.91 alpha:1]];
                [secondEVDetail setText:[NSString stringWithFormat:@"%d", [p speed].intValue]];
                [secondEVDetail setTextColor:[UIColor colorWithRed:0.96 green:0.21 blue:0.91 alpha:1]];
            }
            else
            {
                [thirdEV setHidden:NO];
                [thirdEVDetail setHidden:NO];
                
                [thirdEV setText:@"Speed"];
                [thirdEV setTextColor:[UIColor colorWithRed:0.96 green:0.21 blue:0.91 alpha:1]];
                [thirdEVDetail setText:[NSString stringWithFormat:@"%d", [p speed].intValue]];
                [thirdEVDetail setTextColor:[UIColor colorWithRed:0.96 green:0.21 blue:0.91 alpha:1]];
            }
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
        return [pokedex count];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        Pokemon *p = [searchResults objectAtIndex:[indexPath row]];
        
        int row = [pokedex indexOfObject:p];
        
        [self.searchDisplayController setActive:NO];
        [tView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

# pragma mark - Table Section methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

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
    CGRect tableBounds = tView.bounds;
    CGRect searchBarFrame = self.searchDisplayController.searchBar.frame;
    
    [scrollView layoutSubviews];
    
    self.searchDisplayController.searchBar.frame = CGRectMake(tableBounds.origin.x, tableBounds.origin.y, searchBarFrame.size.width, searchBarFrame.size.height);
    
    CGRect adViewFrame = adView.frame;
    CGFloat newOriginY = tView.contentOffset.y + tView.frame.size.height - adViewFrame.size.height;
    adView.frame = CGRectMake(adViewFrame.origin.x, newOriginY, adViewFrame.size.width, adViewFrame.size.height);
    adViewFrame = adView.frame;
}

//*****************************************
//              Ad View Methods
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

@end
