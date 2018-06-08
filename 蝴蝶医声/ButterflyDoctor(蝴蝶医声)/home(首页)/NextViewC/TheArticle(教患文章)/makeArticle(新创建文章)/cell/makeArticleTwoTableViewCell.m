//
//  makeArticleTwoTableViewCell.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/7/4.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "makeArticleTwoTableViewCell.h"
#import "GatoBaseHelp.h"

@interface makeArticleTwoTableViewCell ()<UITextViewDelegate>
@property (nonatomic ,strong)UIView * underView;
@property (nonatomic ,strong)UITextView * titleTV;
@property (nonatomic ,strong) UILabel * textViewPlaceholder;
@property (nonatomic ,strong)UIButton * deleteButton;

@end
@implementation makeArticleTwoTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"makeArticleTwoTableViewCell";
    makeArticleTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"makeArticleTwoTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

-(void)setValueWithModel:(makeArticleModel *)model
{
    
    self.titleTV.text = model.title;
    if (self.titleTV.text.length > 0) {
        self.textViewPlaceholder.hidden = YES;
    }else{
        
    }
}

//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
//{
//    if (textView == self.titleTV) {
//        self.textViewPlaceholder.hidden = YES;
//    }
//    return YES;
//}
//内容发生改变编辑
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        self.textViewPlaceholder.hidden = YES;
    }else{
        self.textViewPlaceholder.hidden = NO;
    }
}
//结束编辑

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView == self.titleTV) {
        if (textView.text.length > 0) {
            self.textViewPlaceholder.hidden = YES;
            if (self.textViewText) {
                self.textViewText(textView.text);
            }
        }else{
            self.textViewPlaceholder.hidden = NO;
        }
    }
    
    
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
-(UITextView *)titleTV
{
    if (!_titleTV) {
        _titleTV = [[UITextView alloc]init];
        _titleTV.font = FONT(34);
        _titleTV.delegate = self;
        [self.underView addSubview:_titleTV];
    }
    return _titleTV;
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
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor appAllBackColor];
    
    self.underView.sd_layout.leftSpaceToView(self, Gato_Width_320_(10))
    .rightSpaceToView(self, Gato_Width_320_(10))
    .topSpaceToView(self, Gato_Height_548_(5))
    .bottomSpaceToView(self, Gato_Height_548_(5));
    
    GatoViewBorderRadius(self.underView, 5, 1, [UIColor HDViewBackColor]);
    
    self.titleTV.sd_layout.leftSpaceToView(self.underView, Gato_Width_320_(10))
    .rightSpaceToView(self.underView, Gato_Width_320_(30))
    .topSpaceToView(self.underView, Gato_Height_548_(10))
    .bottomSpaceToView(self.underView, Gato_Height_548_(10));
    
    self.deleteButton.sd_layout.leftSpaceToView(self, Gato_Width_320_(5))
    .topSpaceToView(self, 0)
    .widthIs(Gato_Width_320_(20))
    .heightIs(Gato_Height_548_(20));
    
    self.textViewPlaceholder = [[UILabel alloc]init];
    self.textViewPlaceholder.font = FONT(34);
    self.textViewPlaceholder.textColor = [UIColor YMAppAllTitleColor];
    self.textViewPlaceholder.text = @"请输入文章正文";
    [self.underView addSubview:self.textViewPlaceholder];
    self.textViewPlaceholder.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(13))
    .rightSpaceToView(self.underView,Gato_Width_320_(18))
    .topSpaceToView(self.underView,Gato_Height_548_(10))
    .heightIs(Gato_Height_548_(25));
    
}

@end
