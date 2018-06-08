//
//  UILabel+GatoGory.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/6/17.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "UILabel+GatoGory.h"
#import "GatoMethods.h"
@implementation UILabel (GatoGory)

//设置label的行间距
-(void)setLineSpaceWithSpacing:(NSInteger) spacing
{
    [GatoMethods setLineSpaceWithString:self WithSpacing:spacing];
}

@end
