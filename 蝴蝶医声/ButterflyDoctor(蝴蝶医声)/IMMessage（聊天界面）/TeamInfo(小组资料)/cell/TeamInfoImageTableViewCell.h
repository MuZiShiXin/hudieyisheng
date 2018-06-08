//
//  TeamInfoImageTableViewCell.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/5/11.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TeamImageModel;

typedef void(^zhankaiBlock)(BOOL selete);
typedef void(^imageBlock)(TeamImageModel * model);
@interface TeamInfoImageTableViewCell : UITableViewCell
@property (nonatomic ,strong)zhankaiBlock zhankaiBlock;
@property (nonatomic ,strong)imageBlock imageBlock;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setValueWithModelArray:(NSArray *)modelArray Withzhankai:(BOOL)selete;

@end
