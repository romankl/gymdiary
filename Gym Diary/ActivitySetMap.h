//
//  ActivitySetMap.h
//  Gym Diary
//
//  Created by Roman Klauke on 04.01.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ActivityWorkoutMap;

@interface ActivitySetMap : NSManagedObject

@property(nonatomic, retain) NSDate *createdAt;
@property(nonatomic, retain) NSDecimalNumber *distance;
@property(nonatomic, retain) NSNumber *rep;
@property(nonatomic, retain) NSNumber *set;
@property(nonatomic, retain) NSDate *time;
@property(nonatomic, retain) NSDate *updatedAt;
@property(nonatomic, retain) NSDecimalNumber *weight;
@property(nonatomic, retain) ActivityWorkoutMap *usedFor;

@end
