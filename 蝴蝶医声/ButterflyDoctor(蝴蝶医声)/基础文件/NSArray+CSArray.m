//
//  NSArray+CSArray.m
//  FilmBaiXiaoSheng
//
//  Created by  xiaotu on 16/8/22.
//  Copyright © 2016年 XT-Fyn-Lz-Jy. All rights reserved.
//

#import "NSArray+CSArray.h"

@implementation NSArray (CSArray)

- (id)objectAtIndexWithNullDetection:(NSInteger)index{
    if (self == nil) {
        return nil;
    }
    
    if ([self isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    if (index >= self.count) {
        return nil;
    }

    return [self objectAtIndex:index];
}

@end
