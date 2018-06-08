//
//  ModifyArticleTextTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/25.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "ModifyArticleTextTableViewCell.h"
#import "GatoBaseHelp.h"

@interface ModifyArticleTextTableViewCell ()<UITextFieldDelegate , UITextViewDelegate>
@property (nonatomic ,strong) UITextField * titleTF;
@property (nonatomic ,strong) UITextView * centerTV;
@property (nonatomic ,strong) UIButton * pushWenku;

@property (nonatomic ,strong) NSMutableArray * dicArray;
@end
@implementation ModifyArticleTextTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ModifyArticleTextTableViewCell";
    ModifyArticleTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ModifyArticleTextTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor appAllBackColor];
    
    UILabel * title = [[UILabel alloc]init];
    title.text = @"标题";
    title.font = FONT(30);
    [self addSubview:title];
    title.sd_layout.leftSpaceToView(self,Gato_Width_320_(16))
    .rightSpaceToView(self,Gato_Width_320_(16))
    .topSpaceToView(self,0)
    .heightIs(Gato_Width_320_(36));
    
    UIView * tfView = [[UIView alloc]init];
    tfView.backgroundColor = [UIColor whiteColor];
    [self addSubview:tfView];
    tfView.sd_layout.leftSpaceToView(self,Gato_Width_320_(13))
    .rightSpaceToView(self,Gato_Width_320_(13))
    .topSpaceToView(title,0)
    .heightIs(Gato_Width_320_(37));
    GatoViewBorderRadius(tfView, 3, 1, [UIColor HDViewBackColor]);
    [tfView addSubview:self.titleTF];
    
    self.titleTF.sd_layout.leftSpaceToView(tfView,Gato_Width_320_(8))
    .rightSpaceToView(tfView,Gato_Width_320_(8))
    .topSpaceToView(tfView,0)
    .bottomSpaceToView(tfView,0);
    
    UILabel * center = [[UILabel alloc]init];
    center.text = @"推送信息";
    center.font = FONT(30);
    [self addSubview:center];
    center.sd_layout.leftSpaceToView(self,Gato_Width_320_(16))
    .rightSpaceToView(self,Gato_Width_320_(16))
    .topSpaceToView(tfView,0)
    .heightIs(Gato_Width_320_(36));
    
    UIView * tvView = [[UIView alloc]init];
    tvView.backgroundColor = [UIColor whiteColor];
    [self addSubview:tvView];
    tvView.sd_layout.leftSpaceToView(self,Gato_Width_320_(13))
    .rightSpaceToView(self,Gato_Width_320_(13))
    .topSpaceToView(center,0)
    .heightIs(Gato_Width_320_(113));
    GatoViewBorderRadius(tvView, 3, 1, [UIColor HDViewBackColor]);
    [tvView addSubview:self.centerTV];
    
    self.centerTV.sd_layout.leftSpaceToView(tvView,Gato_Width_320_(8))
    .rightSpaceToView(tvView,Gato_Width_320_(8))
    .topSpaceToView(tvView,Gato_Width_320_(8))
    .bottomSpaceToView(tvView,Gato_Width_320_(8));
    
    
    UIView * buttonView = [[UIView alloc]init];
    buttonView.backgroundColor = [UIColor whiteColor];
    [self addSubview:buttonView];
    buttonView.sd_layout.leftSpaceToView(self,Gato_Width_320_(13))
    .rightSpaceToView(self,Gato_Width_320_(13))
    .topSpaceToView(tvView,Gato_Width_320_(13))
    .heightIs(Gato_Width_320_(32));
    GatoViewBorderRadius(buttonView, 3, 1, [UIColor HDViewBackColor]);
    
    UILabel * buttonLabel = [[UILabel alloc]init];
    buttonLabel.text = @"患教文章";
    buttonLabel.font = FONT(26);
    [buttonView addSubview:buttonLabel];
    buttonLabel.sd_layout.leftSpaceToView(buttonView,Gato_Width_320_(10))
    .rightSpaceToView(buttonView,Gato_Width_320_(10))
    .topSpaceToView(buttonView,0)
    .heightIs(Gato_Width_320_(32));
    
    UIImageView * jiantou = [[UIImageView alloc]init];
    jiantou.image = [UIImage imageNamed:@"more"];
    [buttonView addSubview:jiantou];
    jiantou.sd_layout.rightSpaceToView(buttonView,Gato_Width_320_(8))
    .topSpaceToView(buttonView,Gato_Width_320_(13))
    .widthIs(Gato_Width_320_(4))
    .heightIs(Gato_Width_320_(7));
    
    [buttonView addSubview:self.pushWenku];
    
    self.pushWenku.sd_layout.leftSpaceToView(buttonView,0)
    .rightSpaceToView(buttonView,0)
    .topSpaceToView(buttonView,0)
    .bottomSpaceToView(buttonView,0);
    
}
+(CGFloat)getheight
{
    return Gato_Height_548_(272);
}
-(void)setValueWithModel:(modifyArticleModel *)model
{
    if (model.title.length > 0) {
        self.titleTF.text = model.title;
    }
    if (model.content.length > 0) {
        self.centerTV.text = model.content;
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length > 0) {
        if (self.textBlock) {
            self.textBlock(textField.text,0);
        }
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length > 0) {
        if (self.textBlock) {
            self.textBlock(textField.text,0);
        }
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
}


-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length > 0) {
        if (self.textBlock) {
            self.textBlock(textView.text,1);
        }
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)pushwenkuButton
{
    if (self.MoerButton) {
        self.MoerButton();
    }
}
-(UIButton *)pushWenku
{
    if (!_pushWenku) {
        _pushWenku = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pushWenku addTarget:self action:@selector(pushwenkuButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pushWenku;
}
-(UITextView *)centerTV
{
    if (!_centerTV) {
        _centerTV = [[UITextView alloc]init];
        _centerTV.delegate = self;
        _centerTV.font = FONT(26);
    }
    return _centerTV;
}

-(UITextField *)titleTF
{
    if (!_titleTF) {
        _titleTF = [[UITextField alloc]init];
        _titleTF.delegate = self;
        _titleTF.font = FONT(26);
    }
    return _titleTF;
}


@end
