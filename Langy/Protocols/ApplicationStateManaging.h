//
//  ApplicationStateManaging.h
//  Langy
//
//  Created by Nicolas Santangelo on 1/10/15.
//  Copyright (c) 2015 Nicolas Santangelo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ApplicationStateManaging <NSObject>

- (void)appStateChanged:(BOOL)isOn;

@end
