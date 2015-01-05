//
// Created by Roman Klauke on 05.01.15.
// Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import "UITextField+TextHelper.h"


@implementation UITextField (TextHelper)

- (BOOL)isEmpty {
    return self.text.length == 0;
}

@end
