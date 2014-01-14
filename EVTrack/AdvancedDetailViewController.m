//
//  AdvancedDetailViewController.m
//  EVTrack
//
//  Created by Ryan Mottley on 7/2/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import "AdvancedDetailViewController.h"
#import "EVPokemon.h"
#import "BattledPokemonViewController.h"
#import "PowerItemsViewController.h"
#import "EVDetailViewController.h"
#import "iPadPokemonViewController.h"
#import "RenamePokemonViewController.h"

@implementation AdvancedDetailViewController
{
    NSNumber *test;
}

// Synthesizing variables
@synthesize pokemon;

// Synthesizing outlets
@synthesize pokemonImage, nameLabel;
@synthesize allPokemonBarButton;
@synthesize tView;
@synthesize popoverController;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize navBar = _navBar;
@synthesize iPadView;

//******************************
//        Synthesis end
//******************************

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
    
    if ([[pokemon number] integerValue] < 10)
    {
        [pokemonImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"00%d.png", [[pokemon number] intValue]]]];
    }
    else if ([[pokemon number] integerValue] < 100)
    {
        [pokemonImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"0%d.png", [[pokemon number] intValue]]]];
    }
    else
    {
        [pokemonImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png", [[pokemon number] intValue]]]];
    }
    [nameLabel setText:[pokemon name]];
    
    [self populateLabels];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setNameLabel:nil];
    [self setPokemonImage:nil];
    [self setTView:nil];
    [self setHpLabel:nil];
    [self setAtkLabel:nil];
    [self setDefLabel:nil];
    [self setSpAtkLabel:nil];
    [self setSpDefLabel:nil];
    [self setSpeedLabel:nil];
    [self setTotalBox:nil];
    [self setAllPokemonBarButton:nil];
    [self setNavBar:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[self.splitViewController.viewControllers objectAtIndex:0] viewWillAppear:YES];
    [tView reloadData];
    [self populateLabels];
}

- (void)setPokemon:(Pokemon *)p
{
    pokemon = p;
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
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait)
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            //[_navBar setLeftBarButtonItem:[self createPopoverBarButton]];
        }
    }
    if (toInterfaceOrientation != UIInterfaceOrientationPortrait)
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            //[_navBar setLeftBarButtonItem:nil];
        }
    }
}

//*********************************************//
//             View Setting Methods
//*********************************************//

- (void)populateLabels
{
    [nameLabel setText:[pokemon name]];
    [[self navigationItem] setTitle:[pokemon name]];
    
    [_hpLabel setText:[NSString stringWithFormat:@"%d/255", [pokemon hp].intValue]];
    
    [_atkLabel setText:[NSString stringWithFormat:@"%d/255", [pokemon attack].intValue]];
    
    [_defLabel setText:[NSString stringWithFormat:@"%d/255", [pokemon defense].intValue]];
    
    [_spAtkLabel setText:[NSString stringWithFormat:@"%d/255", [pokemon spattack].intValue]];
    
    [_spDefLabel setText:[NSString stringWithFormat:@"%d/255", [pokemon spdefense].intValue]];
    
    [_speedLabel setText:[NSString stringWithFormat:@"%d/255", [pokemon speed].intValue]];
    
    int total = [[pokemon hp] intValue] + [[pokemon attack] intValue] + [[pokemon defense] intValue] + [[pokemon spattack] intValue] + [[pokemon spdefense] intValue] + [[pokemon speed] intValue];
    [_totalBox setText:[NSString stringWithFormat:@"%d/510", total]];
}

- (UIBarButtonItem *)createPopoverBarButton
{
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"All Pokémon" style:UIBarButtonItemStyleBordered target:self action:@selector(showPopover:)];
    return barButton;
}

- (void)showPopover:(id)sender
{
    if ([popoverController isPopoverVisible])
    {
        [popoverController dismissPopoverAnimated:YES];
    }
    else
    {
        iPadPokemonViewController *popoverView = [[iPadPokemonViewController alloc] init];
        popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverView];
        [popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

//*********************************************//
//                 Segue Methods
//*********************************************//

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"BattledPokemon"])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        BattledPokemonViewController *battledPokemon = [[navigationController viewControllers] objectAtIndex:0];
        
        // Setting view instance variables
        battledPokemon.pokemon = pokemon;
        battledPokemon.parentController = self;
    }
    else if ([[segue identifier] isEqualToString:@"PowerItems"])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        PowerItemsViewController *powerItems = [[navigationController viewControllers] objectAtIndex:0];
        
        powerItems.advDetail = self;
    }
    else if ([[segue identifier] isEqualToString:@"FixDetails"])
    {
        EVDetailViewController *evDetails = segue.destinationViewController;
                
        evDetails.pokemon = pokemon;
        evDetails.advDetail = self;
    }
    else if ([[segue identifier] isEqualToString:@"changeName"])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        RenamePokemonViewController *renamePokemon = [[navigationController viewControllers] objectAtIndex:0];
        
        renamePokemon.advDetail = self;
    }
}

//*****************************************
//            Table View Methods
//*****************************************

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
