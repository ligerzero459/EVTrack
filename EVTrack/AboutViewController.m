//
//  AboutViewController.m
//  EVTrack
//
//  Created by Ryan Mottley on 12/1/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

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

- (IBAction)fbButtonPress:(id)sender
{
    NSURL *fbURL = [[NSURL alloc] initWithString:@"fb://profile/149272685277959"];
    // check if app is installed
    if ( ! [[UIApplication sharedApplication] canOpenURL:fbURL] ) {
        // if we get here, we can't open the FB app.
        fbURL = [[NSURL alloc] initWithString:@"https://www.facebook.com/PokemonEvTracker?ref=hl"]; // direct URL on FB website to open in safari
    }
    
    [[UIApplication sharedApplication] openURL:fbURL];
}

- (IBAction)twitterButtonPress:(id)sender
{
    NSArray *urls = [NSArray arrayWithObjects:
                     @"twitter://user?screen_name={handle}", // Twitter
                     @"tweetbot:///user_profile/{handle}", // TweetBot
                     @"echofon:///user_timeline?{handle}", // Echofon
                     @"twit:///user?screen_name={handle}", // Twittelator Pro
                     @"x-seesmic://twitter_profile?twitter_screen_name={handle}", // Seesmic
                     @"x-birdfeed://user?screen_name={handle}", // Birdfeed
                     @"tweetings:///user?screen_name={handle}", // Tweetings
                     @"simplytweet:?link=http://twitter.com/{handle}", // SimplyTweet
                     @"icebird://user?screen_name={handle}", // IceBird
                     @"fluttr://user/{handle}", // Fluttr
                     @"http://twitter.com/{handle}",
                     nil];
    
    NSString *twitterAccount = @"EVTracker";
    
    UIApplication *application = [UIApplication sharedApplication];
    
    for (NSString *candidate in urls) {
        NSURL *url = [NSURL URLWithString:[candidate stringByReplacingOccurrencesOfString:@"{handle}" withString:twitterAccount]];
        if ([application canOpenURL:url])
        {
            [application openURL:url];
            return;
        }
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
