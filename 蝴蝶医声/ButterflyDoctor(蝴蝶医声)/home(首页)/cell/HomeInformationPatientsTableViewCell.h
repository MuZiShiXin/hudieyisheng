//
//  HomeInformationPatientsTableViewCell.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2018/6/4.
//  Copyright © 2018年 辛书亮. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  void(^upcell)();
@interface HomeInformationPatientsTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property(nonatomic,strong)upcell upcell;
@property (nonatomic,assign)CGFloat cellH;
@end
