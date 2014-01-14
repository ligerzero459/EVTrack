//
//  UpdateViewController.m
//  EVTrack
//
//  Created by Ryan Mottley on 7/21/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import "UpdateViewController.h"

@implementation UpdateViewController
{
    BOOL pageControlBeingUsed;
}

@synthesize scrollView, pageControl;
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
        [scrollView setContentSize:CGSizeMake(640, 388)];
        NSString *filename = [[NSBundle mainBundle] pathForResource:@"iPhoneUpdate" ofType:@"txt"];
        NSString *testString = [NSString stringWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:nil];
        [updateLabel setText:testString];
        [updateLabel sizeToFit];
    }
    else
    {
        [scrollView setContentSize:CGSizeMake(1920, 932)];
        NSString *filename = [[NSBundle mainBundle] pathForResource:@"iPadUpdate" ofType:@"txt"];
        NSString *testString = [NSString stringWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:nil];
        [updateLabel setText:testString];
        [updateLabel sizeToFit];
    }
    pageControlBeingUsed = NO;
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

- (IBAction)changePage:(id)sender
{
    pageControlBeingUsed = YES;
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [pageControl setCurrentPage:page];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (void)viewDidUnload {
    [self setUpdateLabel:nil];
    [super viewDidUnload];
}
@end
