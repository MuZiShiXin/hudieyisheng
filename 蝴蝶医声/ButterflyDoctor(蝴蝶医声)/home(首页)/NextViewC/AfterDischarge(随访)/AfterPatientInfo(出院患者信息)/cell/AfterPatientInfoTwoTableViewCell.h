//
//  AfterPatientInfoTwoTableViewCell.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/27.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "patientInfoNoteModel.h"

typedef void(^imageButtonBlock)(NSInteger row);
@interface AfterPatientInfoTwoTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setvalueWithImageArray:(patientInfoNoteModel *)model;

@property (nonatomic ,strong) imageButtonBlock imageButtonBlock;
@end
