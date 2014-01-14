//
//  OptionsViewController.m
//  EVTrack
//
//  Created by Ryan Mottley on 12/15/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import "OptionsViewController.h"
#import "iPadPokemonViewController.h"
#import "GameStore.h"

@implementation OptionsViewController

@synthesize tView;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/***********************
     Table Methods
***********************/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Deselects row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([indexPath section] == 0 && [indexPath row] == 0)
    {
        UIAlertView *wipeAlert = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"Are you sure you want to wipe your data?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Wipe Data", nil];
        [wipeAlert show];
    }
}

/************************
    Alertview Methods
************************/

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Wipe Data"])
    {
        [[GameStore sharedStore] wipeData];
        [[self tabBarController] setSelectedIndex:0];
        
        // If user has game selected before data wipe, sends them back to main menu
        // and puts a blank pokemon in the window
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            iPadPokemonViewController *ippvc = [[[[[self.tabBarController.viewControllers objectAtIndex:0] viewControllers] objectAtIndex:0] viewControllers] objectAtIndex:1];
            [ippvc setAndShowPokemon:nil];
            [[ippvc navigationController] popToRootViewControllerAnimated:YES];
        }
        else
        {
            [[[[self.tabBarController.viewControllers objectAtIndex:0] viewControllers] objectAtIndex:0] popToRootViewControllerAnimated:YES];
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

@end
