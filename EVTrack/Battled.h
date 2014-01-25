//
//  Battled.h
//  EVTrack
//
//  Created by Ryan Mottley on 1/25/14.
//  Copyright (c) 2014 Kai Strife Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Pokemon;

@interface Battled : NSManagedObject

@property (nonatomic, retain) NSNumber * attack;
@property (nonatomic, retain) NSNumber * defense;
@property (nonatomic, retain) NSNumber * hp;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSNumber * spattack;
@property (nonatomic, retain) NSNumber * spdefense;
@property (nonatomic, retain) NSNumber * speed;
@property (nonatomic, retain) NSNumber * battled;
@property (nonatomic, retain) Pokemon *pokemon;

@end
