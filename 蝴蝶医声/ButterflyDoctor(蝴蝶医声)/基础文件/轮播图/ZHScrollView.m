



#import "GatoBaseHelp.h"
#import "ZHScrollView.h"
#import "UIImageView+WebCache.h"


#import "UIView+MJExtension.h"

#define buttonTag 4011756

@interface ZHScrollView ()<UIScrollViewDelegate>
//存放图片明的数组，
@property (nonatomic, strong)NSArray *dataArr;
//轮播图上面的第一张图片
@property (nonatomic, strong)UIImageView *firstImageV;
//轮播图上面的第二张图片,及默认显示在屏幕上的
@property (nonatomic, strong)UIImageView *currentImageV;
//轮播图最后一张图片，
@property (nonatomic, strong) UIImageView *nextImageV;
@property (nonatomic, strong) NSTimer *timer;

@end


@implementation ZHScrollView
- (instancetype)initWithFrame:(CGRect)frame WithImage:(NSArray *)image
{
    if (self = [super initWithFrame:frame]) {
        //由于下面代理方法里面要切换图片，所以我们要用全局变量保存起来
        self.dataArr = image;
        //添加控件
        [self addAllViews];
    }
    return self;
}

- (void)addAllViews
{
//    NSLog(@"%d", self.index);
    //设置scrollView的属性
    self.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
    self.contentOffset = CGPointMake(self.bounds.size.width, 0);
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.delegate = self;
    self.index = 0;
    //初始化imageview，设置frame，并且添加到scrollView上面
//    self.firstImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.dataArr[self.dataArr.count - 1]]];
    

    
    
    if (self.dataArr.count == 0) {
        return;
    }
//    self.currentImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.dataArr[self.index]]];
    
    
    
    self.currentImageV = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
    self.currentImageV.userInteractionEnabled = YES;
    [self.currentImageV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(currentDidclicked)]];
    self.currentImageV.frame = CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
    [self.currentImageV sd_setImageWithURL:[NSURL URLWithString:self.dataArr[0]] placeholderImage:nil options:SDWebImageRetryFailed];
//    [self.currentImageV sd_setImageWithURL:[NSURL URLWithString:( self.dataArr[self.index]).picUrl]];
    [self addSubview:self.currentImageV];

//    self.nextImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.dataArr[self.index + 1]]];



    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = self.currentImageV.frame;
    
    button.tag = 0 + buttonTag;
    [button addTarget:self action:@selector(buttonImageRow) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    if (self.dataArr.count<2) {
        return;
    }
    
    
    self.firstImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    
    //    self.firstImageV.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [self.firstImageV sd_setImageWithURL:[NSURL URLWithString:(self.dataArr[self.dataArr.count - 1])] placeholderImage:[UIImage imageNamed:@" "] options:SDWebImageRetryFailed];
    [self addSubview:self.firstImageV];
    
     [self startTimer];
    
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = self.firstImageV.frame;
    button1.tag = 1 + buttonTag;
    [button1 addTarget:self action:@selector(buttonImageRow) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button1];
    
    
    
    if (self.dataArr.count < 3) {
        return;
    }
    
    self.nextImageV = [[UIImageView alloc] initWithFrame:CGRectMake(2*self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
    [self.nextImageV sd_setImageWithURL:[NSURL URLWithString:(self.dataArr[self.index + 1])] placeholderImage:[UIImage imageNamed:@" "] options:SDWebImageRetryFailed];
//    self.nextImageV.frame = CGRectMake(2*self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
    [self addSubview:self.nextImageV];
    
    
    UIButton * button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = self.firstImageV.frame;
    button2.tag = 2 + buttonTag;
    [button2 addTarget:self action:@selector(buttonImageRow) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button2];
    
}


#pragma mark 图片点击事件
-(void)currentDidclicked{

}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
//    NSLog(@"fkdlsfkdlfjds");
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.timer invalidate];
    self.timer = nil;
}






- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.block) {
        self.block(self.index);
    }
}
-(void)buttonImageRow
{
    if (self.bannerBlock) {
        self.bannerBlock(self.index);
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    
    [self startTimer];
//     NSLog(@"%ld", self.index);
    //如果偏移量小于scrollView的宽，表示第一张图片已经有一部分显示在屏幕上了
    if (scrollView.contentOffset.x < self.bounds.size.width) {
        //这个时候我们要修改当前index，及当前现实图片的下标，index＝0，表示显示数组里面的第一张图片，那么上一张就是最后一张，else及表示上一张是index－1；
        if (self.index == 0) {
            self.index = self.dataArr.count - 1;
        } else {
            self.index --;
        }
    }
    //如果偏移量小于scrollView的宽，表示第三张图片已经有一部分显示在屏幕上了
    if (scrollView.contentOffset.x > self.bounds.size.width) {
        //这个时候我们要修改当前index，及当前现实图片的下标，index＝0count－1，表示显示数组里面的最后一张图片，那么下一张就是第一张，else及表示上一张是index＋1
        if (self.index == self.dataArr.count - 1) {
            self.index = 0;
        } else {
            self.index ++;
        }
    }
    
//    NSLog(@"%ld", self.index);
    
    
//    self.currentImageV = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.dataArr[self.index] ofType:nil]]];
    
    //切换当前默认显示在屏幕上面的图片，根据index，
    
    [self.currentImageV sd_setImageWithURL:[NSURL URLWithString:(self.dataArr[self.index])] placeholderImage:[UIImage imageNamed:@" "] options:SDWebImageRetryFailed];
//    self.currentImageV.image = [UIImage imageNamed:self.dataArr[self.index]];
    
    //如果index＝0.说明上一张是count－1，以及最后一张，else 上一张是index－1张
    if (self.index == 0) {
        [self.firstImageV sd_setImageWithURL:[NSURL URLWithString:(self.dataArr[self.dataArr.count - 1])] placeholderImage:[UIImage imageNamed:@" "] options:SDWebImageRetryFailed];
        
//        self.firstImageV.image = [UIImage imageNamed:self.dataArr[self.dataArr.count - 1]];
    } else {
        [self.firstImageV sd_setImageWithURL:[NSURL URLWithString:(self.dataArr[self.index - 1])] placeholderImage:[UIImage imageNamed:@" "] options:SDWebImageRetryFailed];
//        self.firstImageV.image = [UIImage imageNamed:self.dataArr[self.index - 1]];
    }
    //如果index＝count－1.说明下一张是0，以及第一张，else 下一张是index＋1张
    if (self.index == self.dataArr.count - 1) {
        [self.nextImageV sd_setImageWithURL:[NSURL URLWithString:(self.dataArr[0])] placeholderImage:[UIImage imageNamed:@" "] options:SDWebImageRetryFailed];
//        self.nextImageV.image = [UIImage imageNamed:self.dataArr[0]];
    } else {
        [self.nextImageV sd_setImageWithURL:[NSURL URLWithString:(self.dataArr[self.index + 1])] placeholderImage:[UIImage imageNamed:@" "] options:SDWebImageRetryFailed];

//        self.nextImageV.image = [UIImage imageNamed: self.dataArr[self.index + 1]];
    }
    //将scrollview的偏移量切回来
    
    self.contentOffset = CGPointMake(self.bounds.size.width, 0);
//     NSLog(@"%ld", self.index);
    
    
    
}

#pragma mark timer methods

- (void)startTimer
{
    self.timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    // 添加到运行循环
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}


- (void)updateTimer
{

//    NSInteger page = self.index % 3;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        CGPoint point = self.contentOffset;
        point.x += [UIScreen mainScreen].bounds.size.width;
        self.contentOffset = point;
        
    }];
    
    
    
    if (self.index == self.dataArr.count - 1) {
        self.index = 0;
    } else {
        self.index ++;
    }
    if (self.dataArr.count == 0 || self.index > self.dataArr.count - 1) {
        return;
    }
    
    //切换当前默认显示在屏幕上面的图片，根据index，
    
    [self.currentImageV sd_setImageWithURL:[NSURL URLWithString:( self.dataArr[self.index])] placeholderImage:[UIImage imageNamed:@" "] options:SDWebImageRetryFailed];
    
//    self.currentImageV.image = [UIImage imageNamed:self.dataArr[self.index]];
    
    //如果index＝0.说明上一张是count－1，以及最后一张，else 上一张是index－1张
    if (self.index == 0) {
        
        [self.firstImageV sd_setImageWithURL:[NSURL URLWithString:( self.dataArr[self.dataArr.count - 1])] placeholderImage:[UIImage imageNamed:@" "] options:SDWebImageRetryFailed];
        
//        self.firstImageV.image = [UIImage imageNamed:self.dataArr[self.dataArr.count - 1]];
    } else {
        
        [self.firstImageV sd_setImageWithURL:[NSURL URLWithString:( self.dataArr[self.index - 1])] placeholderImage:[UIImage imageNamed:@" "] options:SDWebImageRetryFailed];
        
//        self.firstImageV.image = [UIImage imageNamed:self.dataArr[self.index - 1]];
    }
    //如果index＝count－1.说明下一张是0，以及第一张，else 下一张是index＋1张
    if (self.index == self.dataArr.count - 1) {
        [self.nextImageV sd_setImageWithURL:[NSURL URLWithString:(self.dataArr[0])] placeholderImage:[UIImage imageNamed:@" "] options:SDWebImageRetryFailed];
//        self.nextImageV.image = [UIImage imageNamed:self.dataArr[0]];
    } else {
        
        [self.nextImageV sd_setImageWithURL:[NSURL URLWithString:( self.dataArr[self.index + 1])] placeholderImage:[UIImage imageNamed:@" "] options:SDWebImageRetryFailed];
//        self.nextImageV.image = [UIImage imageNamed: self.dataArr[self.index + 1]];
    }
    //将scrollview的偏移量切回来
    
    self.contentOffset = CGPointMake(self.bounds.size.width, 0);

    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
