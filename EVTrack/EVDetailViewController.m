//
//  EVDetailViewController.m
//  EVTrack
//
//  Created by Ryan Mottley on 6/17/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import "EVDetailViewController.h"
#import "PokemonViewController.h"
#import "EVPokemon.h"
#import "PokedexStore.h"
#import "AdvancedDetailViewController.h"

@implementation EVDetailViewController
{
    NSArray *searchResults;
}

@synthesize pokemon, advDetail;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize navBar = _navBar;

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if (_splitViewBarButtonItem != splitViewBarButtonItem)
    {
        NSMutableArray *navBarItems = [[_navBar items] mutableCopy];
        if (_splitViewBarButtonItem) [navBarItems removeObject:_splitViewBarButtonItem];
        if (splitViewBarButtonItem) [navBarItems insertObject:splitViewBarButtonItem atIndex:0];
        [_navBar setItems:navBarItems];
        _splitViewBarButtonItem = splitViewBarButtonItem;
    }
}

- (void)setPokemon:(Pokemon *)p
{
    pokemon = p;
    [[self navigationItem] setTitle:[pokemon name]];
}

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
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self populateLabels]; 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Enabling scrollView
    [detailScrollView setContentSize:CGSizeMake(320, 510)];
    
    // Setting all Pokemon information
    if ([pokemon number].intValue < 10)
    {
        [detailImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"00%d.png", [pokemon number].intValue]]];
    }
    else if ([pokemon number].intValue < 100)
    {
        [detailImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"0%d.png", [pokemon number].intValue]]];
    }
    else
    {
        [detailImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png", [pokemon number].intValue]]];
    }
    [[detailImageView layer] setCornerRadius:10.0f];
    [[detailImageView layer] setBorderColor:[UIColor whiteColor].CGColor];
    [[detailImageView layer] setBorderWidth:2.5f];
    
    [detailNumberLabel setText:[NSString stringWithFormat:@"#%d", [pokemon number].intValue]];
    [detailNameLabel setText:[pokemon name]];
    _navBar.topItem.title = [pokemon name];
    
    [self setTheme];
    [self populateLabels];
    [self.view setNeedsDisplay];
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

# pragma mark - user defined selectors

- (IBAction)hpStepperChanged:(id)sender
{
    UIStepper *_hpStepper = (UIStepper *)sender;
    int hp = (int)[_hpStepper value];
    [pokemon setHp:[NSNumber numberWithInt:hp]];
    [[DataManager manager] saveContext];
    
    [self populateLabels];
}

- (IBAction)atkStepperChanged:(id)sender
{
    UIStepper *_atkStepper = (UIStepper *)sender;
    int atk = (int)[_atkStepper value];
    [pokemon setAttack:[NSNumber numberWithInt:atk]];
    [[DataManager manager] saveContext];
    
    [self populateLabels];
}

- (IBAction)defStepperChanged:(id)sender
{
    UIStepper *_defStepper = (UIStepper *)sender;
    int def = (int)[_defStepper value];
    [pokemon setDefense:[NSNumber numberWithInt:def]];
    [[DataManager manager] saveContext];
    
    [self populateLabels];
}

- (IBAction)spAtkStepperChanged:(id)sender
{
    UIStepper *_spAtkStepper = (UIStepper *)sender;
    int spAtk = (int)[_spAtkStepper value];
    [pokemon setSpattack:[NSNumber numberWithInt:spAtk]];
    [[DataManager manager] saveContext];
    
    [self populateLabels];
}

- (IBAction)spDefStepperChanged:(id)sender
{
    UIStepper *_spDefStepper = (UIStepper *)sender;
    int spDef = (int)[_spDefStepper value];
    [pokemon setSpdefense:[NSNumber numberWithInt:spDef]];
    [[DataManager manager] saveContext];
    
    [self populateLabels];
}

- (IBAction)speedStepperChanged:(id)sender
{
    UIStepper *_speedStepper = (UIStepper *)sender;
    int speed = (int)[_speedStepper value];
    [pokemon setSpeed:[NSNumber numberWithInt:speed]];
    [[DataManager manager] saveContext];
    
    [self populateLabels];
}

- (void)setTheme
{
    /*
     Setting up the theme of the boxes
     */
    [[hpView layer] setCornerRadius:20.0f];
    [[hpView layer] setBorderColor:[UIColor redColor].CGColor];
    [[hpView layer] setBorderWidth:1.2f];
    [[hpView layer] setBackgroundColor:[UIColor darkGrayColor].CGColor];
    [hpView.layer setShadowColor:[UIColor redColor].CGColor];
    [hpView.layer setShadowOpacity:0.9];
    [hpView.layer setShadowRadius:4.5];
    [hpView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    [[atkView layer] setCornerRadius:20.0f];
    [[atkView layer] setBorderColor:[UIColor orangeColor].CGColor];
    [[atkView layer] setBorderWidth:1.2f];
    [[atkView layer] setBackgroundColor:[UIColor darkGrayColor].CGColor];
    [atkView.layer setShadowColor:[UIColor orangeColor].CGColor];
    [atkView.layer setShadowOpacity:0.9];
    [atkView.layer setShadowRadius:4.5];
    [hpView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    [[defView layer] setCornerRadius:20.0f];
    [[defView layer] setBorderColor:[UIColor yellowColor].CGColor];
    [[defView layer] setBorderWidth:1.2f];
    [[defView layer] setBackgroundColor:[UIColor darkGrayColor].CGColor];
    [defView.layer setShadowColor:[UIColor yellowColor].CGColor];
    [defView.layer setShadowOpacity:0.9];
    [defView.layer setShadowRadius:4.5];
    [defView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    [[spAtkView layer] setCornerRadius:20.0f];
    [[spAtkView layer] setBorderColor:[UIColor blueColor].CGColor];
    [[spAtkView layer] setBorderWidth:1.2f];
    [[spAtkView layer] setBackgroundColor:[UIColor darkGrayColor].CGColor];
    [spAtkView.layer setShadowColor:[UIColor blueColor].CGColor];
    [spAtkView.layer setShadowOpacity:0.9];
    [spAtkView.layer setShadowRadius:4.5];
    [spAtkView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    [[spDefView layer] setCornerRadius:20.0f];
    [[spDefView layer] setBorderColor:[UIColor greenColor].CGColor];
    [[spDefView layer] setBorderWidth:1.2f];
    [[spDefView layer] setBackgroundColor:[UIColor darkGrayColor].CGColor];
    [spDefView.layer setShadowColor:[UIColor greenColor].CGColor];
    [spDefView.layer setShadowOpacity:0.9];
    [spDefView.layer setShadowRadius:4.5];
    [spDefView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    [[speedView layer] setCornerRadius:20.0f];
    [[speedView layer] setBorderColor:[UIColor purpleColor].CGColor];
    [[speedView layer] setBorderWidth:1.2f];
    [[speedView layer] setBackgroundColor:[UIColor darkGrayColor].CGColor];
    [speedView.layer setShadowColor:[UIColor purpleColor    ].CGColor];
    [speedView.layer setShadowOpacity:0.9];
    [speedView.layer setShadowRadius:4.5];
    [speedView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
}

- (void)populateLabels
{
    [hpLabel setText:[NSString stringWithFormat:@"%d", [pokemon hp].intValue]];
    [hpStepper setValue:(double)[pokemon hp].intValue];
    [hp2Stepper setValue:(double)[pokemon hp].intValue];
    
    [atkLabel setText:[NSString stringWithFormat:@"%d", [pokemon attack].intValue]];
    [atkStepper setValue:(double)[pokemon attack].intValue];
    [atk2Stepper setValue:(double)[pokemon attack].intValue];
    
    [defLabel setText:[NSString stringWithFormat:@"%d", [pokemon defense].intValue]];
    [defStepper setValue:(double)[pokemon defense].intValue];
    [def2Stepper setValue:(double)[pokemon defense].intValue];
    
    [spAtkLabel setText:[NSString stringWithFormat:@"%d", [pokemon spattack].intValue]];
    [spAtkStepper setValue:(double)[pokemon spattack].intValue];
    [spAtk2Stepper setValue:(double)[pokemon spattack].intValue];
    
    [spDefLabel setText:[NSString stringWithFormat:@"%d", [pokemon spdefense].intValue]];
    [spDefStepper setValue:(double)[pokemon spdefense].intValue];
    [spDef2Stepper setValue:(double)[pokemon spdefense].intValue];
    
    [speedLabel setText:[NSString stringWithFormat:@"%d", [pokemon speed].intValue]];
    [speedStepper setValue:(double)[pokemon speed].intValue];
    [speed2Stepper setValue:(double)[pokemon speed].intValue];
    
    int total = [pokemon hp].intValue + [pokemon attack].intValue + [pokemon defense].intValue + [pokemon spattack].intValue + [pokemon spdefense].intValue + [pokemon speed].intValue;
    [totalBox setText:[NSString stringWithFormat:@"%d", total]];
    
     [[self advDetail] viewWillAppear:YES];
}

- (void)viewDidUnload {
    _navBar = nil;
    hpStepper = nil;
    atkStepper = nil;
    defStepper = nil;
    spAtkStepper = nil;
    spDefStepper = nil;
    speedStepper = nil;
    hp2Stepper = nil;
    atk2Stepper = nil;
    def2Stepper = nil;
    spAtk2Stepper = nil;
    spDef2Stepper = nil;
    speed2Stepper = nil;
    [super viewDidUnload];
}

@end
