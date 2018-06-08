//
//  JZAlbumViewController.m
//  aoyouHH
//
//  Created by jinzelu on 15/4/27.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import "JZAlbumViewController.h"
#import "UIImageView+WebCache.h"
#import "PhotoView.h"
#import "NSArray+CSArray.h"
#define screen_width self.view.bounds.size.width
#define screen_height self.view.bounds.size.height
#define Gato_Width [UIScreen mainScreen].bounds.size.width
#define Gato_Height [UIScreen mainScreen].bounds.size.height
@interface JZAlbumViewController ()<UIScrollViewDelegate,PhotoViewDelegate>
{
    CGFloat lastScale;
    NSMutableArray *_subViewList;
}

@end

@implementation JZAlbumViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //
        _subViewList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    lastScale = 1.0;
    self.view.backgroundColor = [UIColor blackColor];

    // TODO: 可以关闭，（只有加载完成后才可以dismiss）
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapView)];
    [self.view addGestureRecognizer:tap];

    [self initScrollView];
    [self addLabels];
    [self setPicCurrentIndex:self.currentIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initScrollView{
//    [[SDImageCache sharedImageCache] cleanDisk];
//    [[SDImageCache sharedImageCache] clearMemory];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    self.scrollView.contentSize = CGSizeMake(self.imagesUrl.count*screen_width, screen_height);
    self.scrollView.delegate = self;
    self.scrollView.contentOffset = CGPointMake(0, 0);
    //设置放大缩小的最大，最小倍数
//    self.scrollView.minimumZoomScale = 1;
//    self.scrollView.maximumZoomScale = 2;
    [self.view addSubview:self.scrollView];
    
    for (int i = 0; i < self.imagesUrl.count; i++) {
        [_subViewList addObject:[NSNull class]];
    }

}

-(void)addLabels{
    self.sliderLabel = [[UILabel alloc] initWithFrame:CGRectMake((Gato_Width - 60)/2, screen_height-64, 60, 30)];
    self.sliderLabel.backgroundColor = [UIColor clearColor];
    self.sliderLabel.textColor = [UIColor whiteColor];
    self.sliderLabel.font = [UIFont systemFontOfSize:20];
    self.sliderLabel.textAlignment = NSTextAlignmentCenter;
    self.sliderLabel.text = [NSString stringWithFormat:@"%ld/%lu",self.currentIndex+1,(unsigned long)self.imagesUrl.count];
    [self.view addSubview:self.sliderLabel];
}

-(void)setPicCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    self.scrollView.contentOffset = CGPointMake(screen_width*currentIndex, 0);
    [self loadPhote:_currentIndex];
    [self loadPhote:_currentIndex+1];
    [self loadPhote:_currentIndex-1];
}

-(void)loadPhote:(NSInteger)index{
    if (index<0 || index >=self.imagesUrl.count) {
        return;
    }
    
    id currentPhotoView = [_subViewList objectAtIndexWithNullDetection:index];
    if (![currentPhotoView isKindOfClass:[PhotoView class]]) {
        //url数组
        for (int i = 0; i< self.imagesUrl.count; i++) {
            CGRect frame = CGRectMake(i*_scrollView.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
            PhotoView *photoV ;
            if ([self.imagesUrl[i] isKindOfClass:[UIImage class]]) {
                photoV = [[PhotoView alloc]initWithFrame:frame withPhotoImage:[self.imagesUrl objectAtIndexWithNullDetection:i]];
            }else
            {
                photoV = [[PhotoView alloc] initWithFrame:frame withPhotoUrl:[self.imagesUrl objectAtIndexWithNullDetection:i]];
            }
            photoV.delegate = self;
            [self.scrollView insertSubview:photoV atIndex:0];
            [_subViewList replaceObjectAtIndex:i withObject:photoV];
        }
        
    }else{
    }
    
}

#pragma mark - PhotoViewDelegate
-(void)TapHiddenPhotoView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)OnTapView{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//手势
-(void)pinGes:(UIPinchGestureRecognizer *)sender{
    if ([sender state] == UIGestureRecognizerStateBegan) {
        lastScale = 1.0;
    }
    CGFloat scale = 1.0 - (lastScale -[sender scale]);
    lastScale = [sender scale];
    self.scrollView.contentSize = CGSizeMake(self.imagesUrl.count*screen_width, screen_height*lastScale);
    CATransform3D newTransform = CATransform3DScale(sender.view.layer.transform, scale, scale, 1);
    
    sender.view.layer.transform = newTransform;
    if ([sender state] == UIGestureRecognizerStateEnded) {
        //
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int i = scrollView.contentOffset.x/screen_width+1;
    [self loadPhote:i-1];
    if (i == 0) {
        self.sliderLabel.text = [NSString stringWithFormat:@"%d / %lu",1,(unsigned long)self.imagesUrl.count];
    }else
    {
        self.sliderLabel.text = [NSString stringWithFormat:@"%d / %lu",i,(unsigned long)self.imagesUrl.count];
    }
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
