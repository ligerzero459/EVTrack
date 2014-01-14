//
//  PokemonViewController.h
//  EVTrack
//
//  Created by Ryan Mottley on 6/16/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    
    __weak IBOutlet UITableView *tView;
}

@end
