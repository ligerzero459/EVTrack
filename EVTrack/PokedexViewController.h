//
//  PokedexViewController.h
//  EVTrack
//
//  Created by Ryan Mottley on 6/20/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <iAd/iAd.h>

@class PokedexViewController;

@interface PokedexViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, ADBannerViewDelegate>
{
    
    __weak IBOutlet UITableView *tView;
}

@end
