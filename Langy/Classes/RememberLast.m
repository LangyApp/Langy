//
//  RememberLast.m
//  Langy
//
//  Created by Nicolas Santangelo on 12/12/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "RememberLast.h"

@implementation RememberLast

+ (NSString *)name {
    return @"Remember last used";
}

+ (NSString *)layout {
    return @"remember_last";
}

+ (bool)isEnabledOn:(NSDictionary *)app {
    return [app[@"layout"] isEqualToString: [RememberLast layout]];
}

@end
