//
//  Activity.h
//  Gym Diary
//
//  Created by Roman Klauke on 03.01.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ActivityScheduleMap, ActivitySetMap;

@interface Activity : NSManagedObject

@property(nonatomic, retain) NSNumber *active;
@property(nonatomic, retain) NSDate *createdAt;
@property(nonatomic, retain) NSString *imagePath;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *summary;
@property(nonatomic, retain) NSDate *updatedAt;
@property(nonatomic, retain) ActivityScheduleMap *inScheduleMap;
@property(nonatomic, retain) NSSet *performance;
@end

@interface Activity (CoreDataGeneratedAccessors)

- (void)addPerformanceObject:(ActivitySetMap *)value;

- (void)removePerformanceObject:(ActivitySetMap *)value;

- (void)addPerformance:(NSSet *)values;

- (void)removePerformance:(NSSet *)values;

@end
