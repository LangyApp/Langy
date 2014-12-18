//
//  RememberLast.h
//  InputSourceMonitor
//
//  Created by Nicolas Santangelo on 12/12/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RememberLast : NSObject

+ (NSString *)name;

+ (NSString *)layout;

+ (bool)isEnabledOn:(NSDictionary *)app;

@end
