//
//  patientInfoImageTableViewCell.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/22.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface patientInfoImageTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setValueWithImageUrl:(NSString *)imageUrl;

@end
