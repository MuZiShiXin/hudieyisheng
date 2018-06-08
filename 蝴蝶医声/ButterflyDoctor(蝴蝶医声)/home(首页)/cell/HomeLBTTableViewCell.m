//
//  HomeLBTTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/18.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "HomeLBTTableViewCell.h"

#import "ZHScrollView.h"
#import "GatoBaseHelp.h"
#import "LYNetConn.h"
#import "GatoURL.h"
#import "UIImageView+WebCache.h"
#import "XRCarouselView.h"


@interface HomeLBTTableViewCell ()<XRCarouselViewDelegate>
@property (nonatomic, strong) XRCarouselView *carouselView;

@property (nonatomic ,strong) UILabel * conterLabel;
@property (nonatomic ,strong) UIView * conterView;
@end
@implementation HomeLBTTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"HomeLBTTableViewCell";
    HomeLBTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeLBTTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
+(CGFloat)getHeightForCell
{
    return Gato_Height_548_(99) ;
}

-(void)addAllViews
{
    [self InternetForZuHeView];
}
-(void)setGongGaoWithString:(NSString *)string
{
    self.conterLabel.text = string;
}
-(void)setValueWithConter:(NSString *)con
{
    
    if (con == nil) {
        self.conterLabel.hidden = YES;
        self.conterView.hidden = YES;
        return;
    }
    self.conterLabel.text = con;
}

-(void)setValueWithModel:(NSArray *)modelArray
{
    
    for (UIView *subView in self.subviews) {
        if ([subView.class isSubclassOfClass:[ZHScrollView class]] || [subView.class isSubclassOfClass:[UIPageControl class]]) {
            [subView removeFromSuperview];
        }
    }
    if (modelArray.count == 0) {
        return ;
    }
    
    NSMutableArray * imageArray = [NSMutableArray array];
    for (int i = 0 ; i < modelArray.count ; i ++) {
        HomeLBTModel * model = [[HomeLBTModel alloc]init];
        model = modelArray[i];
        [imageArray addObject:ModelNull(model.picUrl)];
    }
    
    
    ZHScrollView * lunboView = [[ZHScrollView alloc]initWithFrame:CGRectMake(Gato_0, 0, Gato_Width * 3 / 2 / 1.5 , Gato_Height_548_(99) ) WithImage:imageArray];
    [self addSubview:lunboView];
    __weak typeof(self) weakSelf =self;
    lunboView.bannerBlock = ^(NSInteger row){
        if (weakSelf.imageBlock) {
            weakSelf.imageBlock(modelArray[row]);
        }
    };
    
    //4.添加pageControl:分页，展示目前看到的是第几页
    UIPageControl *page = [[UIPageControl alloc] init];
    page.center = CGPointMake(self.bounds.size.width * 0.5, Gato_Height_548_(90) );
    page.numberOfPages = modelArray.count;
    page.currentPageIndicatorTintColor = [UIColor whiteColor];
    //    page.pageIndicatorTintColor = Gato_(255, 255, 255);
    [self addSubview:page];
    lunboView.block = ^(NSInteger pageCurrent){
        page.currentPage = pageCurrent;
    };
}
-(void)setValueWithModel:(NSArray *)modelArray WithHeight:(CGFloat )height
{
    for (UIView *subView in self.subviews) {
        if ([subView.class isSubclassOfClass:[ZHScrollView class]] || [subView.class isSubclassOfClass:[UIPageControl class]]) {
            [subView removeFromSuperview];
        }
    }
    if (modelArray.count == 0) {
        return ;
    }
    
    NSMutableArray * imageArray = [NSMutableArray array];
    for (int i = 0 ; i < modelArray.count ; i ++) {
        HomeLBTModel * model = [[HomeLBTModel alloc]init];
        model = modelArray[i];
        [imageArray addObject:ModelNull(model.picUrl)];
    }
    
    
    self.carouselView = [[XRCarouselView alloc] initWithFrame:CGRectMake(Gato_0, 0, Gato_Width * 3 / 2 / 1.5 , height )];
    
    
    //设置占位图片,须在设置图片数组之前设置,不设置则为默认占位图
    _carouselView.placeholderImage = [UIImage imageNamed:@"nav_essay"];
    
    //设置图片数组及图片描述文字
    _carouselView.imageArray = imageArray;
    _carouselView.describeArray = nil;
    
    //用代理处理图片点击
    _carouselView.delegate = self;
    
    //设置每张图片的停留时间，默认值为5s，最少为2s
    _carouselView.time = 2;
    
    //设置分页控件的图片,不设置则为系统默认
    //    [_carouselView setPageImage:[UIImage imageNamed:@"other"] andCurrentPageImage:[UIImage imageNamed:@"current"]];
    
    //设置分页控件的位置，默认为PositionBottomCenter
    _carouselView.pagePosition = PositionBottomCenter;
    
    /**
     *  修改图片描述控件的外观，不需要修改的传nil
     *
     *  参数一 字体颜色，默认为白色
     *  参数二 字体，默认为13号字体
     *  参数三 背景颜色，默认为黑色半透明
     */
    UIColor *bgColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    UIFont *font = [UIFont systemFontOfSize:15];
    UIColor *textColor = [UIColor whiteColor];
    [_carouselView setDescribeTextColor:textColor font:font bgColor:bgColor];
    __weak typeof(self) weakSelf =self;
    _carouselView.imageClickBlock = ^(NSInteger index){
        if (weakSelf.imageBlock) {
            weakSelf.imageBlock(modelArray[index]);
        }
    };
    
    [self addSubview:_carouselView];
}

-(void)setValueWithLBTModel:(NSArray *)modelArray
{
    for (UIView *subView in self.subviews) {
        if ([subView.class isSubclassOfClass:[ZHScrollView class]] || [subView.class isSubclassOfClass:[UIPageControl class]]) {
            [subView removeFromSuperview];
        }
    }
    if (modelArray.count == 0) {
        return ;
    }
    
    NSMutableArray * imageArray = [NSMutableArray array];
    for (int i = 0 ; i < modelArray.count ; i ++) {
        HomeLBTModel * model = [[HomeLBTModel alloc]init];
        model = modelArray[i];
        [imageArray addObject:ModelNull(model.picUrl)];
    }
    
//    ZHScrollView * lunboView = [[ZHScrollView alloc]initWithFrame:CGRectMake(Gato_0, 0, Gato_Width * 3 / 2 / 1.5 , Gato_Height_548_(99)  ) WithImage:imageArray];
//    [self addSubview:lunboView];
    
    self.carouselView = [[XRCarouselView alloc] initWithFrame:CGRectMake(Gato_0, 0, Gato_Width * 3 / 2 / 1.5 , Gato_Height_548_(99) )];
    
    
    //设置占位图片,须在设置图片数组之前设置,不设置则为默认占位图
    _carouselView.placeholderImage = [UIImage imageNamed:@"nav_essay"];
    
    //设置图片数组及图片描述文字
    _carouselView.imageArray = imageArray;
    _carouselView.describeArray = nil;
    
    //用代理处理图片点击
    _carouselView.delegate = self;
    
    //设置每张图片的停留时间，默认值为5s，最少为2s
    _carouselView.time = 2;
    
    //设置分页控件的图片,不设置则为系统默认
    //    [_carouselView setPageImage:[UIImage imageNamed:@"other"] andCurrentPageImage:[UIImage imageNamed:@"current"]];
    
    //设置分页控件的位置，默认为PositionBottomCenter
    _carouselView.pagePosition = PositionBottomCenter;
    
    /**
     *  修改图片描述控件的外观，不需要修改的传nil
     *
     *  参数一 字体颜色，默认为白色
     *  参数二 字体，默认为13号字体
     *  参数三 背景颜色，默认为黑色半透明
     */
    UIColor *bgColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    UIFont *font = [UIFont systemFontOfSize:15];
    UIColor *textColor = [UIColor whiteColor];
    [_carouselView setDescribeTextColor:textColor font:font bgColor:bgColor];
    __weak typeof(self) weakSelf = self;
    _carouselView.imageClickBlock = ^(NSInteger index){
        if (weakSelf.imageBlock) {
            weakSelf.imageBlock(modelArray[index]);
        }
    };
    
    [self addSubview:_carouselView];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //清除缓存
    [XRCarouselView clearDiskCache];
    
}


#pragma mark XRCarouselViewDelegate
- (void)carouselView:(XRCarouselView *)carouselView clickImageAtIndex:(NSInteger)index {
    
}


-(void)InternetForZuHeView
{
    
    
    
}


-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width, 1));
    //下分割线
    UIColor *color = Gato_(240,240,240);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 0.1, rect.size.width  , Gato_Height_548_(1)));
}

#pragma mark 暂无数据使用默认图片
- (void)awakeFromNib {
    [super awakeFromNib];
    [self addAllViews];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}




@end
