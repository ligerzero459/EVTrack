//
//  RenamePokemonViewController.m
//  EVTrack
//
//  Created by Ryan Mottley on 10/3/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import "RenamePokemonViewController.h"
#import "AdvancedDetailViewController.h"
#import "EVPokemon.h"

@implementation RenamePokemonViewController
{
    ADBannerView *adView;
}

@synthesize advDetail, tView, renameField;

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
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)dismissModal:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dismissModalSave:(id)sender
{
    [advDetail.pokemon setName:[renameField text]];
    [[DataManager manager] saveContext];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
