//
//  XibBaseCell.m
//  butterflyDoctor
//
//  Created by 丰华财经 on 2017/5/3.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "XibBaseCell.h"

@implementation XibBaseCell

+ (NSString *)getCellID{
    return NSStringFromClass([self class]);
}

+ (CGFloat)getHeightForCell {
    return 0.0f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
