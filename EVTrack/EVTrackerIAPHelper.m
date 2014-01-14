//
//  EVTrackerIAPHelper.m
//  EVTrack
//
//  Created by Ryan Mottley on 12/15/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import "EVTrackerIAPHelper.h"

@implementation EVTrackerIAPHelper

+ (EVTrackerIAPHelper *)sharedInstance
{
    static EVTrackerIAPHelper *sharedInstance = nil;
    if (!sharedInstance)
    {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"product_ids" withExtension:@"plist"];
        NSArray *productIdentifiers = [NSArray arrayWithContentsOfURL:url];
        
        sharedInstance = [[self alloc] initWithProductIdentifiers:[NSSet setWithArray:productIdentifiers]];
    }
    
    return sharedInstance;
}

@end
