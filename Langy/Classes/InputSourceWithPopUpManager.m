//
//  InputSourceWithPopUpManager.m
//  Langy
//
//  Created by Nicolas Santangelo on 12/27/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "InputSourceWithPopUpManager.h"


@interface InputSourceWithPopUpManager () {
    InputSource *inputSource;
    NSArray *installedSources;
}

@end

@implementation InputSourceWithPopUpManager

- (id)init {
    if (self = [super init]) {
        inputSource = [[InputSource alloc] init];
        installedSources = [inputSource installed];
    }
    return self;
}

- (id)initWithSources:(NSArray *)sources {
    if (self = [super init]) {
        inputSource = [[InputSource alloc] init];
        installedSources = sources;
    }
    return self;
}

- (void)addToMenu:(NSMenu *)menu withApp:(NSDictionary *)app {
    [menu addItem:[self menuItem:app layoutName:[self getLocalizedNameFor:app]]];
    
    for (int i = 0; i < [installedSources count]; i++) {
        if (![installedSources[i][@"layout"] isEqualTo:app[@"layout"]]) {
            [menu addItem:[self menuItem:@{ @"name": app[@"name"], @"layout": installedSources[i][@"layout"] } layoutName:installedSources[i][@"name"]]];
        }
    }
    if (![RememberLast isEnabledOn:app]) {
        [self addRememberLastTo:menu forApp:app];
    }
}

- (NSString *)getLocalizedNameFor:(NSDictionary *)app {
    if ([RememberLast isEnabledOn:app]) {
        return [RememberLast name];
    } else {
        return [inputSource addStatusTo:[inputSource localizedName:app[@"layout"]] fromKey:app[@"layout"]];
    }
}

- (void)addRememberLastTo:(NSMenu *)menu forApp:(NSDictionary *)app {
    [menu addItem:[self menuItem:@{ @"name": app[@"name"], @"layout": [RememberLast layout] } layoutName:[RememberLast name]]];
}

- (InputSourceWithPopUpMenuItem *)menuItem:(NSDictionary *)app layoutName:(NSString *)layout {
    return [[InputSourceWithPopUpMenuItem alloc] initWithApp:app andLayoutName:layout];
}

@end
