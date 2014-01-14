//
//  UpdateViewController.h
//  EVTrack
//
//  Created by Ryan Mottley on 7/21/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateViewController : UIViewController <UIScrollViewDelegate, UIPopoverControllerDelegate> {
    UIScrollView *scrollView;
    UIPageControl *pageControl;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *updateLabel;

- (IBAction)dismissModal:(id)sender;
- (IBAction)changePage:(id)sender;

@end
