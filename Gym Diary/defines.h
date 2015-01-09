//
//  defines.h
//  Gym Diary
//
//  Created by Roman Klauke on 09.01.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#ifndef Gym_Diary_defines_h
#define Gym_Diary_defines_h

#import <CocoaLumberjack/DDLog.h>

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
  static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

#endif
