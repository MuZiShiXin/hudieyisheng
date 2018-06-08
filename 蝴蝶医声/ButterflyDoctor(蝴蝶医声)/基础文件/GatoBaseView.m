//
//  GatoBaseView.m
//  meiqi
//
//  Created by 辛书亮 on 2016/10/25.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "GatoBaseView.h"

@implementation GatoBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addAllViews];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addAllViews];
    }
    return self;
}

-(void)addAllViews{
    
}

+(CGFloat)getHeightForView{
    return 0;
}

@end
