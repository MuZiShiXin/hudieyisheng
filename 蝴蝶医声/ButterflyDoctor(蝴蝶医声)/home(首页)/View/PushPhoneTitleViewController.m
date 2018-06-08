//
//  PushPhoneTitleViewController.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/6/7.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "PushPhoneTitleViewController.h"
#import "GatoBaseHelp.h"

#define MAX_LIMIT_NUMS 200
@interface PushPhoneTitleViewController ()<UITextViewDelegate>

@property (nonatomic ,strong) UITextView * textview;
@property (nonatomic ,strong) UILabel * textViewPlaceholder;
@property (nonatomic ,strong) UIButton * phoneButton;
@property (strong, nonatomic) UILabel *BTNumber;
@end

@implementation PushPhoneTitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    self.title = @"平台留言";
    
    self.view.backgroundColor = [UIColor appAllBackColor];
    
    
//    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,50,30)];
//    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
//    rightButton.titleLabel.font = FONT(26);
//    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [rightButton addTarget:self action:@selector(searchprogram) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem= rightItem;
    
    UILabel * label = [[UILabel alloc]init];
    label.text = @"给助理留言吧！";
    label.font = FONT(32);
    label.textColor = [UIColor HDTitleRedColor];
    [self.view addSubview:label];
    label.sd_layout.leftSpaceToView(self.view, Gato_Width_320_(10))
    .topSpaceToView(self.view, Gato_Height_548_(10))
    .rightSpaceToView(self.view, 20)
    .heightIs(Gato_Height_548_(30));
    
    UILabel * label1 = [[UILabel alloc]init];
    label1.text = @"我们会全力改进和解决问题";
    label1.font = FONT(32);
    label1.textColor = [UIColor HDBlackColor];
    [self.view addSubview:label1];
    label1.sd_layout.leftSpaceToView(self.view, Gato_Width_320_(10))
    .topSpaceToView(label, Gato_Height_548_(10))
    .rightSpaceToView(self.view, 20)
    .heightIs(Gato_Height_548_(30));
    
    
    self.textview.sd_layout.leftSpaceToView(self.view, Gato_Width_320_(10))
    .rightSpaceToView(self.view, Gato_Width_320_(15))
    .topSpaceToView(label1, Gato_Height_548_(10))
    .heightIs(Gato_Height_548_(150));
    
    GatoViewBorderRadius(self.textview, 3, 1, [UIColor HDViewBackColor]);
    
    
    self.textViewPlaceholder = [[UILabel alloc]init];
    self.textViewPlaceholder.font = FONT(32);
    self.textViewPlaceholder.textColor = [UIColor YMAppAllTitleColor];
    self.textViewPlaceholder.text = @"请添写您想要留言的内容...";
    [self.textview addSubview:self.textViewPlaceholder];
    self.textViewPlaceholder.sd_layout.leftSpaceToView(self.textview,Gato_Width_320_(5))
    .rightSpaceToView(self.textview,Gato_Width_320_(18))
    .topSpaceToView(self.textview,Gato_Height_548_(5))
    .heightIs(Gato_Height_548_(20));
    
    
    UIView * underView = [[UIView alloc]init];
    underView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:underView];
    underView.sd_layout.leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .heightIs(Gato_Height_548_(55));
    UIView * fgx = [[UIView alloc]init];
    fgx.backgroundColor = [UIColor HDViewBackColor];
    [underView addSubview:fgx];
    fgx.frame = CGRectMake(0, 0, Gato_Width, 1);
    
    self.phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.phoneButton setTitle:@"确认发送" forState:UIControlStateNormal];
    [self.phoneButton setBackgroundColor:[UIColor HDThemeColor]];
    [self.phoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.phoneButton addTarget:self action:@selector(phoneButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    self.phoneButton.titleLabel.font = FONT(32);
    [self.view addSubview:self.phoneButton];
    self.phoneButton.sd_layout.leftSpaceToView(self.view, Gato_Width_320_(80))
    .rightSpaceToView(self.view, Gato_Width_320_(80))
    .bottomSpaceToView(self.view, Gato_Height_548_(10))
    .heightIs(Gato_Height_548_(35));
    GatoViewBorderRadius(self.phoneButton, 5, 0, [UIColor redColor]);
    
    self.BTNumber = [[UILabel alloc]init];
    self.BTNumber.font = FONT(30);
    self.BTNumber.textAlignment = NSTextAlignmentRight;
    self.BTNumber.text = @"0/200字";
    [self.textview addSubview:self.BTNumber];
    self.BTNumber.sd_layout.rightSpaceToView(self.textview, Gato_Width_320_(5))
    .bottomSpaceToView(self.textview, Gato_Height_548_(5))
    .widthIs(Gato_Width_320_(60))
    .heightIs(Gato_Height_548_(20));
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos)
    {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < MAX_LIMIT_NUMS)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }
            else
            {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                          
                                          if (idx >= rg.length) {
                                              *stop = YES; //取出所需要就break，提高效率
                                              return ;
                                          }
                                          
                                          trimString = [trimString stringByAppendingString:substring];
                                          
                                          idx++;
                                      }];
                
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
            self.BTNumber.text = [NSString stringWithFormat:@"%d/%ld字",0,(long)MAX_LIMIT_NUMS];
        }
        return NO;
    }
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        
        [textView setText:s];
    }
    
    //不让显示负数 口口日
    self.BTNumber.text = [NSString stringWithFormat:@"%ld/%d字",existTextNum,MAX_LIMIT_NUMS];
}

#pragma mark - 网络请求
-(void)phoneButtonDidClicked
{
    if (self.textview.text.length < 1) {
        [self showHint:@"请输入您的留言"];
        return;
    }
    [self updataPhoneNumber];
}
-(void)updataPhoneNumber
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    if (self.textview.text.length > 0) {
        [self.updateParms setObject:self.textview.text forKey:@"content"];
    }else{
        [self.updateParms setObject:@"请医疗助理尽快给我回电话！" forKey:@"content"];
    }
    [IWHttpTool postWithURL:HD_Home_PhoneNumber params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:nil message:@"我们已收到您的反馈信息，我们将会在工作时间内与您取得联系" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *cancel1 = [UIAlertAction actionWithTitle:@"我知道了" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            if ([cancel1 valueForKey:@"titleTextColor"]) {
                [cancel1 setValue:[UIColor HDThemeColor] forKey:@"titleTextColor"];
            }
            [alert1 addAction:cancel1];
            [self showDetailViewController:alert1 sender:nil];
            
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)searchprogram
{
    if (self.titleBlock) {
        self.titleBlock(self.textview.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.textViewPlaceholder.hidden = YES;
    return YES;
}
//结束编辑

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length > 0) {
        self.textViewPlaceholder.hidden = YES;
    }else{
        self.textViewPlaceholder.hidden = NO;
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITextView *)textview
{
    if (!_textview) {
        _textview = [[UITextView alloc]init];
        _textview.font = FONT(32);
        _textview.delegate = self;
        [self.view addSubview:_textview];
    }
    return _textview;
}



@end
