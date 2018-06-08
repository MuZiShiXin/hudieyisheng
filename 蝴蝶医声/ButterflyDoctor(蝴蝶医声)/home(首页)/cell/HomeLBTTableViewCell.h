//
//  HomeLBTTableViewCell.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/18.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GatoBaseTableViewCell.h"
#import "HomeLBTModel.h"

typedef void(^imageBlock)(HomeLBTModel * model);
@interface HomeLBTTableViewCell : GatoBaseTableViewCell
@property (nonatomic ,strong)NSMutableArray *arr;
@property (nonatomic ,strong)imageBlock imageBlock;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setGongGaoWithString:(NSString *)string;
-(void)setValueWithModel:(NSArray *)modelArray;

-(void)setValueWithLBTModel:(NSArray *)modelArray;

-(void)setValueWithModel:(NSArray *)modelArray WithHeight:(CGFloat )height;
@end
