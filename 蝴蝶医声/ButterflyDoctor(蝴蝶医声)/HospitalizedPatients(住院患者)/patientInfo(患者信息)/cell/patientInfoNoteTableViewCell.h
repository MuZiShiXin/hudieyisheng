//
//  patientInfoNoteTableViewCell.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/24.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "patientInfoNoteModel.h"
typedef void(^textFieldBlock)(NSString * text,NSInteger row);//text 输入内容 row 0床好 1病案号
typedef void(^textViewBlock)(NSString * text);
typedef void(^bedNumberBlock)();
@interface patientInfoNoteTableViewCell : UITableViewCell
@property (nonatomic ,strong) textFieldBlock textFieldBlock;
@property (nonatomic ,strong) textViewBlock textViewBlock;
@property (nonatomic ,strong) bedNumberBlock bedNumberBlock;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


-(void)setValueWithModel:(patientInfoNoteModel *)model;

@end
