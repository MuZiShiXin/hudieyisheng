//
//  JGGHospitalizedPatientsCellTableViewCell.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2018/5/30.
//  Copyright © 2018年 辛书亮. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  void(^tapPush)(NSInteger row);

@interface JGGHospitalizedPatientsCellTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
-(void)setValueWithArray:(NSMutableArray *)modelArray andIndex:(NSIndexPath *)indexPath;
-(void)setValueWithSuiFangArray:(NSMutableArray *)modelArray andIndex:(NSIndexPath *)indexPath;
@property(nonatomic,strong)tapPush tapPush;
@end
