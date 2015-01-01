//
//  Activity+InitObject.m
//  Gym Diary
//
//  Created by Roman Klauke on 01.01.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import "Activity+InitObject.h"

@implementation Activity (InitObject)

- (void)awakeFromInsert {
    [super awakeFromInsert];

    self.createdAt = [NSDate date];
}


@end
