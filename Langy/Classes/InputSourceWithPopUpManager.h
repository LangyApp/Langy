//
//  InputSourceWithPopUpManager.h
//  Langy
//
//  Created by Nicolas Santangelo on 12/27/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "InputSource.h"
#import "RememberLast.h"

#import "InputSourceWithPopUpMenuItem.h"

@interface InputSourceWithPopUpManager : NSObject

- (id)initWithSources:(NSArray *)sources;

- (void)addToMenu:(NSMenu *)menu withApp:(NSDictionary *)app;

@end
