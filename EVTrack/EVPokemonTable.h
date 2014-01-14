//
//  EVPokemonTable.h
//  EVTrack
//
//  Created by Ryan Mottley on 6/18/13.
//  Copyright (c) 2013 Kai Strife Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EVPokemonTable : NSManagedObject

@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * attack;
@property (nonatomic, retain) NSNumber * defense;
@property (nonatomic, retain) NSNumber * spattack;
@property (nonatomic, retain) NSNumber * spdefense;
@property (nonatomic, retain) NSNumber * hp;
@property (nonatomic, retain) NSNumber * speed;

@end
