//
//  AfterPatientInfoDataOneTableViewCell.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/27.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "patientInfoNoteModel.h"
@interface AfterPatientInfoDataOneTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;


-(void)setValueWithModel:(patientInfoNoteModel *)model;
@end
