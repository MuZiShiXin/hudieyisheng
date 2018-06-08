//
//  bedNumberLeftTableViewCell.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/6/5.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bedNumberLeftTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setValueWithName:(NSString *)name WithIndexSelect:(BOOL )select;
@end
