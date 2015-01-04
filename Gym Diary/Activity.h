//
//  Activity.h
//  Gym Diary
//
//  Created by Roman Klauke on 04.01.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ActivityWorkoutMap;

@interface Activity : NSManagedObject

@property(nonatomic, retain) NSNumber *active;
@property(nonatomic, retain) NSDate *createdAt;
@property(nonatomic, retain) NSString *imagePath;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *summary;
@property(nonatomic, retain) NSDate *updatedAt;
@property(nonatomic, retain) NSSet *shouldPerform;
@end

@interface Activity (CoreDataGeneratedAccessors)

- (void)addShouldPerformObject:(ActivityWorkoutMap *)value;

- (void)removeShouldPerformObject:(ActivityWorkoutMap *)value;

- (void)addShouldPerform:(NSSet *)values;

- (void)removeShouldPerform:(NSSet *)values;

@end
