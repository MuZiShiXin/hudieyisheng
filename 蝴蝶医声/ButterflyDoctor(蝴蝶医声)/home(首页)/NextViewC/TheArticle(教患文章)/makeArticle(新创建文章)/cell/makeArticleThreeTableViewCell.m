//
//  makeArticleThreeTableViewCell.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/7/4.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "makeArticleThreeTableViewCell.h"
#import "GatoBaseHelp.h"

@interface makeArticleThreeTableViewCell ()<UITextFieldDelegate>
@property (nonatomic ,strong)UIView * underView;
@property (nonatomic ,strong)UITextField * titleTF;
@property (nonatomic ,strong)UIButton * deleteButton;

@property (nonatomic ,strong) UIImageView * photo;

@end
@implementation makeArticleThreeTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"makeArticleThreeTableViewCell";
    makeArticleThreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"makeArticleThreeTableViewCell" owner:nil options:nil] lastObject];
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
    if ([model.title isEqualToString:@"null"]) {
        model.title = @"";
    }
    self.titleTF.text = model.title;
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    if (self.textViewText) {
        self.textViewText(textField.text);
    }
    
    return YES;
}

-(UIView *)underView
{
    if (!_underView) {
        _underView = [[UIView alloc]init];
        _underView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_underView];
    }
    return _underView;
}
-(UITextField *)titleTF
{
    if (!_titleTF) {
        _titleTF = [[UITextField alloc]init];
        _titleTF.font = FONT(34);
        _titleTF.delegate = self;
        _titleTF.placeholder = @"请输入图片注释（选填）";
        [self.underView addSubview:_titleTF];
    }
    return _titleTF;
}
-(UIButton *)deleteButton
{
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton addTarget:self action:@selector(deleteButtonBlock) forControlEvents:UIControlEventTouchUpInside];
        [_deleteButton setBackgroundImage:[UIImage imageNamed:@"deleteButton"] forState:UIControlStateNormal];
        [self addSubview:_deleteButton];
    }
    return _deleteButton;
}
-(void)deleteButtonBlock
{
    if (self.deleteOneBlcok) {
        self.deleteOneBlcok();
    }
}

-(UIImageView *)photo
{
    if (!_photo) {
        _photo = [[UIImageView alloc]init];
        _photo.contentMode = UIViewContentModeScaleAspectFit;
        _photo.backgroundColor = [UIColor whiteColor];
        [self.underView addSubview:_photo];
    }
    return _photo;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor appAllBackColor];
    
    self.underView.sd_layout.leftSpaceToView(self, Gato_Width_320_(10))
    .rightSpaceToView(self, Gato_Width_320_(10))
    .topSpaceToView(self, Gato_Height_548_(5))
    .bottomSpaceToView(self, Gato_Height_548_(5));
    
    GatoViewBorderRadius(self.underView, 5, 1, [UIColor HDViewBackColor]);
    
    self.photo.sd_layout.leftSpaceToView(self.underView, Gato_Width_320_(0))
    .rightSpaceToView(self.underView, 0)
    .topSpaceToView(self.underView, 0)
    .heightIs(Gato_Height_548_(200));
    
    
    self.titleTF.sd_layout.leftSpaceToView(self.underView, Gato_Width_320_(10))
    .rightSpaceToView(self.underView, Gato_Width_320_(30))
    .topSpaceToView(self.photo, 0)
    .bottomSpaceToView(self.underView, 0);
    
    self.deleteButton.sd_layout.leftSpaceToView(self, Gato_Width_320_(5))
    .topSpaceToView(self, 0)
    .widthIs(Gato_Width_320_(20))
    .heightIs(Gato_Height_548_(20));
    

    
}


@end
