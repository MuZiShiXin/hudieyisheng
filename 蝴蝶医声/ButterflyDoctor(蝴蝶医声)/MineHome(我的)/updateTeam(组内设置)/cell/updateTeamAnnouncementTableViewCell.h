//
//  updateTeamAnnouncementTableViewCell.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/6/16.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^zhankaigonggaoBlock)();
@interface updateTeamAnnouncementTableViewCell : UITableViewCell
@property (nonatomic ,strong) zhankaigonggaoBlock zhankaigonggaoBlock;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setValueWithModel:(NSString *)model WithZhankai:(NSString *)zhankai;



@end
