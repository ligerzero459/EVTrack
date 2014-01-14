//
//  RemoveAdsViewController.m
//  EVTrack
//
//  Created by Ryan Mottley on 12/15/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import "RemoveAdsViewController.h"

#import "EVTrackerIAPHelper.h"
#import <UIKit/UIKit.h>

@interface RemoveAdsViewController ()

@end

@implementation RemoveAdsViewController

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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)disableAdsPressed:(id)sender {
    if ([SKPaymentQueue canMakePayments])
    {
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:@"com.kaistrifeproductions.EVTracker.removeAds"]];
        
        request.delegate = self;
        [request start];
        
        HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        HUD.labelText = @"Connecting to store...";
        [HUD setDelegate:self];
    }
    else
    {
        UIAlertView *temp = [[UIAlertView alloc] initWithTitle:@"Unable to purchase" message:@"Unable to complete purchase. Check parental controls or internet connection." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [temp show];
    }
}

- (IBAction)restorePurchase:(id)sender {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [HUD setDelegate:self];
}

// StoreKit Methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    SKProduct *validProduct = nil;
    
    int count = [response.products count];
    
    if (count > 0)
    {
        validProduct = [[response products] objectAtIndex:0];
        
        SKPayment *payment = [SKPayment paymentWithProduct:validProduct];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    else
    {
        
        UIAlertView *tmp = [[UIAlertView alloc]
                            
                            initWithTitle:@"Not Available"
                            
                            message:@"No products to purchase"
                            
                            delegate:self
                            
                            cancelButtonTitle:nil
                            
                            otherButtonTitles:@"Ok", nil];  
        
        [tmp show];
        
    }
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"Purchase in progress");
                
                break;
                
            case SKPaymentTransactionStatePurchased:
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSLog(@"Payment successfully processed");
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"com.kaistrifeproductions.EVTracker.disableAds"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                break;
                
            case SKPaymentTransactionStateRestored:
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSLog(@"Transactions restored");
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"com.kaistrifeproductions.EVTracker.disableAds"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                break;
                
            case SKPaymentTransactionStateFailed:
                
                if (transaction.error.code != SKErrorPaymentCancelled) {
                    NSLog(@"Error! Payment cancelled");
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                break;
                
            default:
                break;
        }
    }
}

-(void)requestDidFinish:(SKRequest *)request
{
    NSLog(@"Request finished");
    [HUD hide:YES afterDelay:1];
}

-(void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"Failed to connect with error: %@", [error localizedDescription]);
    HUD.mode = MBProgressHUDModeText;
	HUD.labelText = [error localizedDescription];
	HUD.margin = 10.f;
	HUD.removeFromSuperViewOnHide = YES;
    [HUD hide:YES afterDelay:3];
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
