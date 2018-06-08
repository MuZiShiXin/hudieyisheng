//
//  TopAnyButtonView.h
//  tongxinbao
//
//  Created by 辛书亮 on 2016/12/19.
//  Copyright © 2016年 辛书亮. All rights reserved.
//

#import "GatoBaseView.h"


typedef void(^topButton)(NSInteger row);

@interface TopAnyButtonView : GatoBaseView
@property(nonatomic ,strong) topButton topBlock;//顶部按钮选择

/*
 NoArray: 为选中图片
 yesArray：选中图片
 labelArray：名字
 flag:选中第几个 默认选中第一个
 */
-(void)setValueWithNoImageArray:(NSArray *)NoArray WithYesImagearray:(NSArray *)yesArray WithLabelArray:(NSArray *)labelArray WithFlag:(NSInteger )flag;//
@end
