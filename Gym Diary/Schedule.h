//
//  Schedule.h
//  Gym Diary
//
//  Created by Roman Klauke on 31.12.14.
//  Copyright (c) 2014 Roman Klauke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Workout;

@interface Schedule : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * progress;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) Workout *useWorkout;

@end
