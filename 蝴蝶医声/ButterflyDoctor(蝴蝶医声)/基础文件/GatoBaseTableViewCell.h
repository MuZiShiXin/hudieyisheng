//
//  GatoBaseTableViewCell.h
//  meiqi
//
//  Created by 辛书亮 on 2016/10/24.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GatoBaseTableViewCell : UITableViewCell
#pragma mark 添加组件
-(void)addAllViews;

#pragma mark 返回高度
+(CGFloat)getHeightForCell;


@end
