//
//  AdvancedDetailViewController.m
//  EVTrack
//
//  Created by Ryan Mottley on 7/2/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import "AdvancedDetailViewController.h"
#import "BattledPokemonViewController.h"
#import "PowerItemsViewController.h"
#import "EVDetailViewController.h"
#import "iPadPokemonViewController.h"
#import "PokemonViewController.h"
#import "RenamePokemonViewController.h"

@implementation AdvancedDetailViewController
{
    NSNumber *test;
    NSArray *allRecent;
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
    allRecent = [[DataManager manager] getBattled:pokemon];
    [self populateLabels];
    [tView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
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
    [_navBar setTitle:[pokemon name]];
    
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
    if (indexPath.section == 3)
    {
        Battled *recent = [allRecent objectAtIndex:[indexPath row]];
        
        int multiplier = 1;
        
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
            [pokemon setHp:[NSNumber numberWithInt:([pokemon hp].intValue + (([recent hp].intValue + 4) * multiplier))]];
        else
            [pokemon setHp:[NSNumber numberWithInt:([pokemon hp].intValue + [recent hp].intValue * multiplier)]];
        
        if ([pokemon powerBracer])
            [pokemon setAttack:[NSNumber numberWithInt:([pokemon attack].intValue + (([recent attack].intValue + 4) * multiplier))]];
        else
            [pokemon setAttack:[NSNumber numberWithInt:([pokemon attack].intValue + [recent attack].intValue * multiplier)]];
        
        if ([pokemon powerBelt])
            [pokemon setDefense:[NSNumber numberWithInt:([pokemon defense].intValue + (([recent defense].intValue + 4) * multiplier))]];
        else
            [pokemon setDefense:[NSNumber numberWithInt:([pokemon defense].intValue + [recent defense].intValue * multiplier)]];
        
        if ([pokemon powerLens])
            [pokemon setSpattack:[NSNumber numberWithInt:([pokemon spattack].intValue + (([recent spattack].intValue + 4) * multiplier))]];
        else
            [pokemon setSpattack:[NSNumber numberWithInt:([pokemon spattack].intValue + [recent spattack].intValue * multiplier)]];
        
        if ([pokemon powerBand])
            [pokemon setSpdefense:[NSNumber numberWithInt:([pokemon spdefense].intValue + (([recent spdefense].intValue + 4) * multiplier))]];
        else
            [pokemon setSpdefense:[NSNumber numberWithInt:([pokemon spdefense].intValue + [recent spdefense].intValue * multiplier)]];
        
        if ([pokemon powerAnklet])
            [pokemon setSpeed:[NSNumber numberWithInt:([pokemon speed].intValue + (([recent speed].intValue + 4) * multiplier))]];
        else
            [pokemon setSpeed:[NSNumber numberWithInt:([pokemon speed].intValue + [recent speed].intValue * multiplier)]];
        
        [recent setBattled:[NSNumber numberWithInt:([[recent battled] intValue] + 1)]];
        [[DataManager manager] saveContext];
    }
    
    [tView reloadData];
    [self populateLabels];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 1;
    else if (section == 1)
        return 3;
    else if (section == 2)
        return 2;
    else
        return [allRecent count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 3)
        return @"Recent Battles";
    else if (section == 1)
        return @"Effort Values";
    else
        return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString *numberIdentifier = @"nameCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:numberIdentifier forIndexPath:indexPath];
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:numberIdentifier];
        }
        
        nameLabel = (UILabel *)[cell viewWithTag:2];
        pokemonImage = (UIImageView *)[cell viewWithTag:1];
        
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
        
        return cell;
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            static NSString *ident = @"hpCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident forIndexPath:indexPath];
            
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
            }
            _hpLabel = (UILabel *)[cell viewWithTag:3];
            _atkLabel = (UILabel *)[cell viewWithTag:4];
            _defLabel = (UILabel *)[cell viewWithTag:5];
            
            return cell;
        }
        else if (indexPath.row == 1)
        {
            static NSString *ident = @"spAtkCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident forIndexPath:indexPath];
            
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
            }
            _spAtkLabel = (UILabel *)[cell viewWithTag:6];
            _spDefLabel = (UILabel *)[cell viewWithTag:7];
            _speedLabel = (UILabel *)[cell viewWithTag:8];
            
            return cell;
        }
        else if (indexPath.row == 2)
        {
            static NSString *ident = @"totalCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident forIndexPath:indexPath];
            
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
            }
            _totalBox = (UITextField *)[cell viewWithTag:9];
            
            return cell;
        }
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            static NSString *ident = @"newBattledCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident forIndexPath:indexPath];
            
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
            }
            
            return cell;
        }
        if (indexPath.row == 1)
        {
            static NSString *ident = @"fixCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident forIndexPath:indexPath];
            
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
            }
            [self populateLabels];
            
            return cell;
        }
    }
    else
    {
        static NSString *ident = @"battledCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident forIndexPath:indexPath];
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        }
        
        UIImageView *battledImage = (UIImageView *)[cell viewWithTag:10];
        UILabel *battledName = (UILabel *)[cell viewWithTag:11];
        UILabel *firstEV = (UILabel *)[cell viewWithTag:15];
        UILabel *firstEVDetail = (UILabel *)[cell viewWithTag:18];
        UIView *firstEVView = (UIView *)[cell viewWithTag:12];
        UILabel *secondEV = (UILabel *)[cell viewWithTag:16];
        UILabel *secondEVDetail = (UILabel *)[cell viewWithTag:19];
        UIView *secondEVView = (UIView *)[cell viewWithTag:13];
        UILabel *thirdEV = (UILabel *)[cell viewWithTag:17];
        UILabel *thirdEVDetail = (UILabel *)[cell viewWithTag:20];
        UIView *thirdEVView = (UIView *)[cell viewWithTag:14];
        UILabel *numberBattled = (UILabel *)[cell viewWithTag:21];
        // UIStepper *battledStepper = (UIStepper *)[cell viewWithTag:22];
        
        Battled *recentBattled = [allRecent objectAtIndex:indexPath.row];
        
        if ([[recentBattled number] integerValue] < 10)
        {
            [battledImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"00%d.png", [[recentBattled number] intValue]]]];
        }
        else if ([[recentBattled number] integerValue] < 100)
        {
            [battledImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"0%d.png", [[recentBattled number] intValue]]]];
        }
        else
        {
            [battledImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png", [[recentBattled number] intValue]]]];
        }
        
        [battledName setText:[recentBattled name]];
        [numberBattled setText:[[recentBattled battled] stringValue]];
        
        [firstEVView setHidden:YES];
        [secondEVView setHidden:YES];
        [thirdEVView setHidden:YES];
        
        if ([recentBattled hp].intValue > 0)
        {
            [firstEVView setHidden:NO];
            [firstEVView setBackgroundColor:[UIColor colorWithRed:0.89 green:0.15 blue:0.008 alpha:1]];
            
            [firstEV setText:@"HP"];
            [firstEVDetail setText:[NSString stringWithFormat:@"%d", [recentBattled hp].intValue]];
        }
        if ([recentBattled attack].intValue > 0)
        {
            if ([firstEVView isHidden])
            {
                [firstEVView setHidden:NO];
                [firstEVView setBackgroundColor:[UIColor orangeColor]];
                
                [firstEV setText:@"Atk"];
                [firstEVDetail setText:[NSString stringWithFormat:@"%d", [recentBattled attack].intValue]];
            }
            else if ([secondEVView isHidden])
            {
                [secondEVView setHidden:NO];
                [secondEVView setBackgroundColor:[UIColor orangeColor]];
                
                [secondEV setText:@"Atk"];
                [secondEVDetail setText:[NSString stringWithFormat:@"%d", [recentBattled attack].intValue]];
            }
        }
        if ([recentBattled defense].intValue > 0)
        {
            if ([firstEVView isHidden])
            {
                [firstEVView setHidden:NO];
                [firstEVView setBackgroundColor:[UIColor yellowColor]];
                
                [firstEV setText:@"Def"];
                [firstEVDetail setText:[NSString stringWithFormat:@"%d", [recentBattled defense].intValue]];
            }
            else if ([secondEVView isHidden])
            {
                [secondEVView setHidden:NO];
                [secondEVView setBackgroundColor:[UIColor yellowColor]];
                
                [secondEV setText:@"Def"];
                [secondEVDetail setText:[NSString stringWithFormat:@"%d", [recentBattled defense].intValue]];
            }
            else
            {
                [thirdEVView setHidden:NO];
                [thirdEVView setBackgroundColor:[UIColor yellowColor]];
                
                [thirdEV setText:@"Def"];
                [thirdEVDetail setText:[NSString stringWithFormat:@"%d", [recentBattled defense].intValue]];
            }
        }
        if ([recentBattled spattack].intValue > 0)
        {
            if ([firstEVView isHidden])
            {
                [firstEVView setHidden:NO];
                [firstEVView setBackgroundColor:[UIColor colorWithRed:0 green:0.53 blue:0.89 alpha:1]];
                
                [firstEV setText:@"SpAk"];
                [firstEVDetail setText:[NSString stringWithFormat:@"%d", [recentBattled spattack].intValue]];
            }
            else if ([secondEVView isHidden])
            {
                [secondEVView setHidden:NO];
                [secondEVView setBackgroundColor:[UIColor colorWithRed:0 green:0.53 blue:0.89 alpha:1]];
                
                [secondEV setText:@"SpAk"];
                [secondEVDetail setText:[NSString stringWithFormat:@"%d", [recentBattled spattack].intValue]];
            }
            else
            {
                [thirdEVView setHidden:NO];
                [thirdEVView setBackgroundColor:[UIColor colorWithRed:0 green:0.53 blue:0.89 alpha:1]];
                
                [thirdEV setText:@"SpAk"];
                [thirdEVDetail setText:[NSString stringWithFormat:@"%d", [recentBattled spattack].intValue]];
            }
        }
        if ([recentBattled spdefense].intValue > 0)
        {
            if ([firstEVView isHidden])
            {
                [firstEVView setHidden:NO];
                [firstEVView setBackgroundColor:[UIColor greenColor]];
                
                [firstEV setText:@"SpDf"];
                [firstEVDetail setText:[NSString stringWithFormat:@"%d", [recentBattled spdefense].intValue]];
            }
            else if ([secondEVView isHidden])
            {
                [secondEVView setHidden:NO];
                [secondEVView setBackgroundColor:[UIColor greenColor]];
                
                [secondEV setText:@"SpDf"];
                [secondEVDetail setText:[NSString stringWithFormat:@"%d", [recentBattled spdefense].intValue]];
            }
            else
            {
                [thirdEVView setHidden:NO];
                [thirdEVView setBackgroundColor:[UIColor greenColor]];
                
                [thirdEV setText:@"SpDf"];
                [thirdEVDetail setText:[NSString stringWithFormat:@"%d", [recentBattled spdefense].intValue]];
            }
        }
        if ([recentBattled speed].intValue > 0)
        {
            if ([firstEVView isHidden])
            {
                [firstEVView setHidden:NO];
                [firstEVView setBackgroundColor:[UIColor colorWithRed:0.96 green:0.21 blue:0.91 alpha:1]];
                
                [firstEV setText:@"Spd"];
                [firstEVDetail setText:[NSString stringWithFormat:@"%d", [recentBattled speed].intValue]];
            }
            else if ([secondEVView isHidden])
            {
                [secondEVView setHidden:NO];
                [secondEVView setBackgroundColor:[UIColor colorWithRed:0.96 green:0.21 blue:0.91 alpha:1]];
                
                [secondEV setText:@"Speed"];
                [secondEVDetail setText:[NSString stringWithFormat:@"%d", [recentBattled speed].intValue]];
            }
            else
            {
                [thirdEVView setHidden:NO];
                [thirdEVView setBackgroundColor:[UIColor colorWithRed:0.96 green:0.21 blue:0.91 alpha:1]];
                
                [thirdEV setText:@"Speed"];
                [thirdEVDetail setText:[NSString stringWithFormat:@"%d", [recentBattled speed].intValue]];
            }
        }
        
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3)
    {
        if ([[pokemon recentPokemon] count] == 0)
            return NO;
        else
            return YES;
    }
    else
    {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tView beginUpdates];
        
        [tView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [[DataManager manager] deleteBattled:[allRecent objectAtIndex:[indexPath row]] fromPokemon:pokemon];
        
        allRecent = [[DataManager manager] getBattled:pokemon];
        
        [tView endUpdates];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 66.0;
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0 || indexPath.row == 1)
        {
            return 66.0;
        }
        else
        {
            return 54.0;
        }
    }
    else if (indexPath.section == 2)
    {
        return 44.0;
    }
    else
    {
        return 124.0;
    }
}

@end
