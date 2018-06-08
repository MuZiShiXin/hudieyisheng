//
//  GatoBaseTableViewCell.m
//  meiqi
//
//  Created by 辛书亮 on 2016/10/24.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "GatoBaseTableViewCell.h"
#import "GatoBaseHelp.h"
@implementation GatoBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self addAllViews];
    }
    return self;
}


#pragma mark 添加组件

-(void)addAllViews{
    
}
#pragma mark 返回高度
+(CGFloat)getHeightForCell{
    return 0;
}




@end
