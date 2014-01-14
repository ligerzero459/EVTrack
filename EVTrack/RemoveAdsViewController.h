//
//  RemoveAdsViewController.h
//  EVTrack
//
//  Created by Ryan Mottley on 12/15/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "MBProgressHUD.h"

@interface RemoveAdsViewController : UIViewController <SKPaymentTransactionObserver, SKProductsRequestDelegate, MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}

- (IBAction)disableAdsPressed:(id)sender;
- (IBAction)restorePurchase:(id)sender;
@end