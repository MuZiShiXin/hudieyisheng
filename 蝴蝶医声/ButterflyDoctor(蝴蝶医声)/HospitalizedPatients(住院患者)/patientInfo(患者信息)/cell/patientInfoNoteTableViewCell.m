//
//  patientInfoNoteTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/24.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "patientInfoNoteTableViewCell.h"
#import "GatoBaseHelp.h"

#define textfieldTag 4240948
#define textviewTag 42409480
@interface patientInfoNoteTableViewCell ()<UITextFieldDelegate,UITextViewDelegate>

@end
@implementation patientInfoNoteTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"patientInfoNoteTableViewCell";
    patientInfoNoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"patientInfoNoteTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)setValueWithModel:(patientInfoNoteModel *)model
{
    
    if (model.bedNumber.length > 0) {
        UITextField * text = (UITextField *)[self viewWithTag:textfieldTag];
        text.text = model.bedNumber;
    }
    if (model.caseNo.length > 0) {
        UITextField * text = (UITextField *)[self viewWithTag:textfieldTag + 1];
        text.text = model.caseNo;
    }
    if (model.remark.length > 0) {
        UITextView * text = (UITextView *)[self viewWithTag:textviewTag];
        text.text = model.remark;
    }
}
-(void)bedNumberButton
{
    if (self.bedNumberBlock) {
        self.bedNumberBlock();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor appAllBackColor];
    [self newViews];
}
-(void)newViews
{
    NSArray * titleArray = @[@"床号",@"病案号"];
    NSArray * textfieldPArray = @[@"请输入患者床号",@"请输入患者病案号"];
    for (int i = 0 ; i < 2; i ++) {
        UIView * view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        view.sd_layout.leftSpaceToView(self,Gato_Width_320_(12))
        .topSpaceToView(self,Gato_Width_320_(13) + i * Gato_Width_320_(36))
        .rightSpaceToView(self,Gato_Width_320_(12))
        .heightIs(Gato_Width_320_(36));
        
        GatoViewBorderRadius(view, 0, 1, [UIColor appAllBackColor]);
        
        UILabel * title = [[UILabel alloc]init];
        title.font = FONT(32);
        title.textColor = [UIColor YMAppAllTitleColor];
        title.textAlignment = NSTextAlignmentCenter;
        [view addSubview:title];
        title.text = titleArray[i];
        title.sd_layout.leftSpaceToView(view,0)
        .topSpaceToView(view,0)
        .widthIs(Gato_Width_320_(65))
        .heightIs(Gato_Width_320_(36));
        
        
        UITextField * textfield = [[UITextField alloc]init];
        textfield.tag = i + textfieldTag;
        textfield.delegate = self;
        textfield.font = FONT(32);
        textfield.textColor = [UIColor HDBlackColor];
        textfield.placeholder = textfieldPArray[i];
        if (i == 1) {
            textfield.keyboardType = UIKeyboardTypeNumberPad;
        }
        [view addSubview:textfield];
        textfield.sd_layout.rightSpaceToView(view,Gato_Width_320_(30))
        .topSpaceToView(view,0)
        .leftSpaceToView(title,Gato_Width_320_(5))
        .heightIs(Gato_Height_548_(36));
        
        UIImageView * image = [[UIImageView alloc]init];
        image.image = [UIImage imageNamed:@"inpatient_btn_alter"];
        [view addSubview:image];
        image.sd_layout.rightSpaceToView(view,Gato_Width_320_(17))
        .topSpaceToView(view,Gato_Height_548_(14))
        .widthIs(Gato_Width_320_(10))
        .heightIs(Gato_Height_548_(10));
        
        
    }
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(bedNumberButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    button.sd_layout.leftSpaceToView(self,Gato_Width_320_(12))
    .topSpaceToView(self,Gato_Width_320_(13))
    .rightSpaceToView(self,Gato_Width_320_(12))
    .heightIs(Gato_Width_320_(36));
    
    
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    view.sd_layout.leftSpaceToView(self,Gato_Width_320_(12))
    .topSpaceToView(self,Gato_Width_320_(13) + 2 * Gato_Width_320_(36) )
    .rightSpaceToView(self,Gato_Width_320_(12))
    .heightIs(Gato_Width_320_(120));
    
    GatoViewBorderRadius(view, 0, 1, [UIColor appAllBackColor]);
    
    UILabel * title = [[UILabel alloc]init];
    title.font = FONT(32);
    title.textColor = [UIColor YMAppAllTitleColor];
    title.textAlignment = NSTextAlignmentCenter;
    [view addSubview:title];
    title.text = @"备注";
    title.sd_layout.leftSpaceToView(view,0)
    .topSpaceToView(view,0)
    .widthIs(Gato_Width_320_(65))
    .heightIs(Gato_Width_320_(36));
    
    
    UITextView * textview = [[UITextView alloc]init];
    textview.font = FONT(32);
    textview.delegate = self;
    textview.tag = textviewTag;
    textview.textColor = [UIColor HDBlackColor];
    [view addSubview:textview];
    textview.sd_layout.rightSpaceToView(view,Gato_Width_320_(30))
    .topSpaceToView(view,Gato_Height_548_(0))
    .leftSpaceToView(title,0)
    .heightIs(Gato_Height_548_(100));
    
    UIImageView * image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"inpatient_btn_alter"];
    [view addSubview:image];
    image.sd_layout.rightSpaceToView(view,Gato_Width_320_(17))
    .topSpaceToView(view,Gato_Height_548_(9))
    .widthIs(Gato_Width_320_(10))
    .heightIs(Gato_Height_548_(10));
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length > 0) {
        
    }else{
        textField.text = @"";
    }
    if (textField.tag - textfieldTag == 0) {
        if (self.textFieldBlock) {
            self.textFieldBlock(textField.text,0);
        }
    }else{
        if (self.textFieldBlock) {
            self.textFieldBlock(textField.text,1);
        }
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length > 0) {
        
    }else{
        textField.text = @"";
    }
    if (textField.tag - textfieldTag == 0) {
        if (self.textFieldBlock) {
            self.textFieldBlock(textField.text,0);
        }
        [textField resignFirstResponder];
        return YES;
    }else{
        if (self.textFieldBlock) {
            self.textFieldBlock(textField.text,1);
        }
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
}


-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length < 1) {
        textView.text = @"";
    }
    if (self.textViewBlock) {
        self.textViewBlock(textView.text);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)dealloc
{
    NSLog(@"释放了");
}
@end
