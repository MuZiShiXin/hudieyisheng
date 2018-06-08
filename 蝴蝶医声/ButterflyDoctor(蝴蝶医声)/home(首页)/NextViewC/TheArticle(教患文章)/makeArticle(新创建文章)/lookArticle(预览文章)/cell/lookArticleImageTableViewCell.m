//
//  lookArticleImageTableViewCell.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/7/4.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "lookArticleImageTableViewCell.h"
#import "GatoBaseHelp.h"

@interface lookArticleImageTableViewCell ()
@property (nonatomic ,strong) UIView * view;
@property (nonatomic ,strong) UIImageView * photo;
@property (nonatomic ,strong) UILabel * titleLabel;
@end

@implementation lookArticleImageTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"lookArticleImageTableViewCell";
    lookArticleImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"lookArticleImageTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

-(void)setValueWithModel:(makeArticleModel *)model
{

        if (model.photoImageStrData) {
            UIImage * image = [UIImage imageWithData:model.photoImageStrData];
            self.photo.image = image;
        }else{
            if (model.photoImage) {
                self.photo.image = model.photoImage;
            }
        }
//    }
    CGFloat height = self.photo.image.size.height * Gato_Width_320_(300) /self.photo.image.size.width;
    self.photo.sd_layout.widthIs(Gato_Width_320_(300))
    .heightIs(height);
 
    if ([model.title isEqualToString:@"null"]) {
        model.title = @"";
    }
    self.titleLabel.frame = CGRectMake(0, height, Gato_Width_320_(300), Gato_Width_320_(30));
    self.titleLabel.text = model.title;
    [self.titleLabel sizeToFit];
    self.height = height + self.titleLabel.height + Gato_Height_548_(10);
    
}
-(UIView *)view
{
    if (!_view) {
        _view = [[UIView alloc]init];
        _view.backgroundColor = [UIColor appAllBackColor];
        [self addSubview:_view];
    }
    return _view;
}
-(UIImageView *)photo
{
    if (!_photo) {
        _photo = [[UIImageView alloc]init];
        [self.view addSubview:_photo];
    }
    return _photo;
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = FONT(34);
        _titleLabel.numberOfLines = 0;
        [self.view addSubview:_titleLabel];
    }
    return _titleLabel;
}
-(void)showZoomImageView:(UITapGestureRecognizer *)tap
{
    if (self.buttonImageBlock) {
        self.buttonImageBlock(tap);
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.view.sd_layout.leftSpaceToView(self, Gato_Width_320_(10))
    .rightSpaceToView(self, Gato_Width_320_(10))
    .topSpaceToView(self, Gato_Width_320_(5))
    .bottomSpaceToView(self, Gato_Width_320_(5));
    
    self.photo.sd_layout.leftSpaceToView(self.view, Gato_Width_320_(0))
    .rightSpaceToView(self.view, Gato_Width_320_(0))
    .topSpaceToView(self.view, Gato_Height_548_(0))
    .heightIs(Gato_Height_548_(100));
    self.photo.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showZoomImageView:)];
    [self.photo addGestureRecognizer:tap];
    
//    self.titleLabel.sd_layout.leftSpaceToView(self.view, Gato_Width_320_(10))
//    .rightSpaceToView(self.view, Gato_Width_320_(10))
//    .topSpaceToView(self.photo, 0)
//    .autoHeightRatio(0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
