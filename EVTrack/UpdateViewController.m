//
//  UpdateViewController.m
//  EVTrack
//
//  Created by Ryan Mottley on 7/21/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import "UpdateViewController.h"

@implementation UpdateViewController

@synthesize updateLabel;

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
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        NSString *filename = [[NSBundle mainBundle] pathForResource:@"iPhoneUpdate" ofType:@"txt"];
        NSString *testString = [NSString stringWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:nil];
        [updateLabel setText:testString];
        [updateLabel sizeToFit];
    }
    else
    {
        NSString *filename = [[NSBundle mainBundle] pathForResource:@"iPadUpdate" ofType:@"txt"];
        NSString *testString = [NSString stringWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:nil];
        [updateLabel setText:testString];
        [updateLabel sizeToFit];
    }
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

- (void)viewDidUnload {
    [self setUpdateLabel:nil];
    [super viewDidUnload];
}

@end
