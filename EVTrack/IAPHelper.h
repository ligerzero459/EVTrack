//
//  IAPHelper.h
//  EVTrack
//
//  Created by Ryan Mottley on 12/15/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);
UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;

@interface IAPHelper : NSObject

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;
- (void)buyProduct:(SKProduct *)product;
- (BOOL)productPurchased:(NSString *)productIdentifier;
- (void)restoreCompletedTransactions;

@end
