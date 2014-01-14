//
//  PowerItemsViewController.m
//  EVTrack
//
//  Created by Ryan Mottley on 7/3/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import "AdvancedDetailViewController.h"
#import "PowerItemsViewController.h"
#import "EVPokemon.h"

@implementation PowerItemsViewController
{
    ADBannerView *adView;
}

//*****************************************
//               Synthesis
//*****************************************

@synthesize PKRS, machoBrace, powerWeight, powerBracer,
            powerBelt, powerBand, powerLens, powerAnklet;
@synthesize advDetail, tView;

//*****************************************
//         Initialization Methods
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self setToggleSwitches];
    
    // Adding iAd to tableView
    BOOL disabledAds = [[NSUserDefaults standardUserDefaults] boolForKey:@"com.kaistrifeproductions.EVTracker.disableAds"];
    if (!disabledAds)
    {
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

- (void)viewDidUnload {
    [self setPKRS:nil];
    [self setMachoBrace:nil];
    [self setPowerWeight:nil];
    [self setPowerBracer:nil];
    [self setPowerBelt:nil];
    [self setPowerLens:nil];
    [self setPowerBand:nil];
    [self setPowerAnklet:nil];
    [super viewDidUnload];
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

- (IBAction)dismissModal:(id)sender
{
    [[DataManager manager] saveContext];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect adViewFrame = adView.frame;
    CGFloat newOriginY = tView.contentOffset.y + tView.frame.size.height - adViewFrame.size.height;
    adView.frame = CGRectMake(adViewFrame.origin.x, newOriginY, adViewFrame.size.width, adViewFrame.size.height);
    adViewFrame = adView.frame;
}

//*****************************************
//             Toggle Methods
//*****************************************

- (IBAction)machoBraceToggled:(id)sender {
    if ([machoBrace isOn]) {
        [advDetail.pokemon setMachoBrace:[NSNumber numberWithBool:YES]];
        [powerWeight setOn:NO animated:YES];
        [powerBracer setOn:NO animated:YES];
        [powerBelt setOn:NO animated:YES];
        [powerLens setOn:NO animated:YES];
        [powerBand setOn:NO animated:YES];
        [powerAnklet setOn:NO animated:YES];
        
        [advDetail.pokemon setPowerWeight:NO];
        [advDetail.pokemon setPowerBracer:NO];
        [advDetail.pokemon setPowerBelt:NO];
        [advDetail.pokemon setPowerLens:NO];
        [advDetail.pokemon setPowerBand:NO];
        [advDetail.pokemon setPowerAnklet:NO];
    }
    else {
        [advDetail.pokemon setMachoBrace:NO];
    }
}

- (IBAction)powerWeightToggled:(id)sender {
    if ([powerWeight isOn]) {
        [advDetail.pokemon setPowerWeight:[NSNumber numberWithBool:YES]];
        [machoBrace setOn:NO animated:YES];
        [powerBracer setOn:NO animated:YES];
        [powerBelt setOn:NO animated:YES];
        [powerLens setOn:NO animated:YES];
        [powerBand setOn:NO animated:YES];
        [powerAnklet setOn:NO animated:YES];
        
        [advDetail.pokemon setMachoBrace:NO];
        [advDetail.pokemon setPowerBracer:NO];
        [advDetail.pokemon setPowerBelt:NO];
        [advDetail.pokemon setPowerLens:NO];
        [advDetail.pokemon setPowerBand:NO];
        [advDetail.pokemon setPowerAnklet:NO];
    }
    else {
        [advDetail.pokemon setPowerWeight:NO];
    }
}

- (IBAction)powerBracerToggled:(id)sender {
    if ([powerBracer isOn]) {
        [advDetail.pokemon setPowerBracer:[NSNumber numberWithBool:YES]];
        [powerWeight setOn:NO animated:YES];
        [machoBrace setOn:NO animated:YES];
        [powerBelt setOn:NO animated:YES];
        [powerLens setOn:NO animated:YES];
        [powerBand setOn:NO animated:YES];
        [powerAnklet setOn:NO animated:YES];
        
        [advDetail.pokemon setPowerWeight:NO];
        [advDetail.pokemon setMachoBrace:NO];
        [advDetail.pokemon setPowerBelt:NO];
        [advDetail.pokemon setPowerLens:NO];
        [advDetail.pokemon setPowerBand:NO];
        [advDetail.pokemon setPowerAnklet:NO];
    }
    else {
        [advDetail.pokemon setPowerBracer:NO];
    }
}

- (IBAction)powerBeltToggled:(id)sender {
    if ([powerBelt isOn]) {
        [advDetail.pokemon setPowerBelt:[NSNumber numberWithBool:YES]];
        [powerWeight setOn:NO animated:YES];
        [powerBracer setOn:NO animated:YES];
        [machoBrace setOn:NO animated:YES];
        [powerLens setOn:NO animated:YES];
        [powerBand setOn:NO animated:YES];
        [powerAnklet setOn:NO animated:YES];
        
        [advDetail.pokemon setPowerWeight:NO];
        [advDetail.pokemon setPowerBracer:NO];
        [advDetail.pokemon setMachoBrace:NO];
        [advDetail.pokemon setPowerLens:NO];
        [advDetail.pokemon setPowerBand:NO];
        [advDetail.pokemon setPowerAnklet:NO];
    }
    else {
        [advDetail.pokemon setPowerBelt:NO];
    }
}

- (IBAction)powerLensToggled:(id)sender {
    if ([powerLens isOn]) {
        [advDetail.pokemon setPowerLens:[NSNumber numberWithBool:YES]];
        [powerWeight setOn:NO animated:YES];
        [powerBracer setOn:NO animated:YES];
        [powerBelt setOn:NO animated:YES];
        [machoBrace setOn:NO animated:YES];
        [powerBand setOn:NO animated:YES];
        [powerAnklet setOn:NO animated:YES];
        
        [advDetail.pokemon setPowerWeight:NO];
        [advDetail.pokemon setPowerBracer:NO];
        [advDetail.pokemon setPowerBelt:NO];
        [advDetail.pokemon setMachoBrace:NO];
        [advDetail.pokemon setPowerBand:NO];
        [advDetail.pokemon setPowerAnklet:NO];
    }
    else {
        [advDetail.pokemon setPowerLens:NO];
    }
}

- (IBAction)powerBandToggled:(id)sender {
    if ([powerBand isOn]) {
        [advDetail.pokemon setPowerBand:[NSNumber numberWithBool:YES]];
        [powerWeight setOn:NO animated:YES];
        [powerBracer setOn:NO animated:YES];
        [powerBelt setOn:NO animated:YES];
        [powerLens setOn:NO animated:YES];
        [machoBrace setOn:NO animated:YES];
        [powerAnklet setOn:NO animated:YES];
        
        [advDetail.pokemon setPowerWeight:NO];
        [advDetail.pokemon setPowerBracer:NO];
        [advDetail.pokemon setPowerBelt:NO];
        [advDetail.pokemon setPowerLens:NO];
        [advDetail.pokemon setMachoBrace:NO];
        [advDetail.pokemon setPowerAnklet:NO];
    }
    else {
        [advDetail.pokemon setPowerBand:NO];
    }
}

- (IBAction)powerAnkletToggled:(id)sender {
    if ([powerAnklet isOn]) {
        [advDetail.pokemon setPowerAnklet:[NSNumber numberWithBool:YES]];
        [powerWeight setOn:NO animated:YES];
        [powerBracer setOn:NO animated:YES];
        [powerBelt setOn:NO animated:YES];
        [powerLens setOn:NO animated:YES];
        [powerBand setOn:NO animated:YES];
        [machoBrace setOn:NO animated:YES];
        
        [advDetail.pokemon setPowerWeight:NO];
        [advDetail.pokemon setPowerBracer:NO];
        [advDetail.pokemon setPowerBelt:NO];
        [advDetail.pokemon setPowerLens:NO];
        [advDetail.pokemon setPowerBand:NO];
        [advDetail.pokemon setMachoBrace:NO];
    }
    else {
        [advDetail.pokemon setPowerAnklet:NO];
    }
}

- (IBAction)PKRSToggled:(id)sender {
    if ([PKRS isOn]) {
        [advDetail.pokemon setPkrs:[NSNumber numberWithBool:YES]];
    }
    else {
        [advDetail.pokemon setPkrs:NO];
    }
}

- (IBAction)hpUpPressed:(id)sender {
    [advDetail.pokemon setHp:[NSNumber numberWithInt:([advDetail.pokemon hp].intValue + 10)]];
}

- (IBAction)proteinPressed:(id)sender {
    [advDetail.pokemon setAttack:[NSNumber numberWithInt:([advDetail.pokemon attack].intValue + 10)]];
}

- (IBAction)ironPressed:(id)sender {
    [advDetail.pokemon setDefense:[NSNumber numberWithInt:([advDetail.pokemon defense].intValue + 10)]];
}

- (IBAction)calciumPressed:(id)sender {
    [advDetail.pokemon setSpattack:[NSNumber numberWithInt:([advDetail.pokemon spattack].intValue + 10)]];
}

- (IBAction)zincPressed:(id)sender {
    [advDetail.pokemon setSpdefense:[NSNumber numberWithInt:([advDetail.pokemon spdefense].intValue + 10)]];
}

- (IBAction)carbosPressed:(id)sender {
    [advDetail.pokemon setSpeed:[NSNumber numberWithInt:([advDetail.pokemon speed].intValue + 10)]];
}

- (void)setToggleSwitches
{
    [PKRS setOn:NO animated:YES];
    [machoBrace setOn:NO animated:YES];
    [powerWeight setOn:NO animated:YES];
    [powerBracer setOn:NO animated:YES];
    [powerBelt setOn:NO animated:YES];
    [powerLens setOn:NO animated:YES];
    [powerBand setOn:NO animated:YES];
    [powerAnklet setOn:NO animated:YES];
    
    
    if ([advDetail.pokemon pkrs]) {
        [PKRS setOn:YES animated:YES];
    }
    
    if ([advDetail.pokemon machoBrace])
    {
        [machoBrace setOn:YES animated:YES];
    }
    else if ([advDetail.pokemon powerWeight])
    {
        [powerWeight setOn:YES animated:YES];
    }
    else if ([advDetail.pokemon powerLens])
    {
        [powerLens setOn:YES animated:YES];
    }
    else if ([advDetail.pokemon powerBracer])
    {
        [powerBracer setOn:YES animated:YES];
    }
    else if ([advDetail.pokemon powerBelt])
    {
        [powerBelt setOn:YES animated:YES];
    }
    else if ([advDetail.pokemon powerBand])
    {
        [powerBand setOn:YES animated:YES];
    }
    else if ([advDetail.pokemon powerAnklet])
    {
        [powerAnklet setOn:YES animated:YES];
    }
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
