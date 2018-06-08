

#import <UIKit/UIKit.h>

typedef void(^pageCurrent)(NSInteger page);
typedef void(^bannerBlock)(NSInteger row);

@interface ZHScrollView : UIScrollView
//声明一个初始化方法，传入frame，以及存放图片命的数组
//如果图片时网络图片，直接传入存在url字符串的数组，image初始化的时候直接可用SDWebImage进行
- (instancetype)initWithFrame:(CGRect)frame WithImage:(NSArray *)image;

//纪录当前显示在屏幕上图片在数组里面的下标
@property (nonatomic, assign)NSInteger index;
@property (nonatomic, copy) pageCurrent block;
@property (nonatomic, copy) bannerBlock bannerBlock;

@end
