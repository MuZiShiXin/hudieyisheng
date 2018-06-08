/**
 !! 随便弄了一下，只是为了 目前项目的使用.过几天会 完善
 !! 加入单例等
 
 有问题可以联系 邮箱 asiosldh@163.com
 QQ               872304636
 
 */


#import "PellTableViewSelect.h"

@interface  PellTableViewSelect()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy) NSArray *selectData;
@property (nonatomic,copy) void(^action)(NSInteger index);
@property (nonatomic ,assign) BOOL YMQuHao;//美如那年app  区号
@property (nonatomic,copy) NSArray *rightData;
@property (nonatomic ,strong) UIButton * clectButton;
@end


PellTableViewSelect *BlackBackgroundView;
PellTableViewSelect *backgroundView;
UITableView *tableView;
UIView * view;

@implementation PellTableViewSelect


- (instancetype)init{
    if (self = [super init]) {
        self.YMQuHao = NO;
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}
+ (void)YMaddPellTableViewSelectWithWindowFrame:(CGRect)frame
                                     selectData:(NSArray *)selectData
                                      rightData:(NSArray *)rightData
                                         action:(void(^)(NSInteger index))action animated:(BOOL)animate
{
    if (backgroundView != nil) {
        [PellTableViewSelect hiden];
    }
    
    
    //    UIWindow *win = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    backgroundView = [[PellTableViewSelect alloc] initWithFrame:win.bounds];
    backgroundView.action = action;
    backgroundView.selectData = selectData;
    backgroundView.YMQuHao = YES;
    backgroundView.rightData = rightData;
    
    
    
    
    backgroundView.backgroundColor = [UIColor colorWithHue:0
                                                saturation:0
                                                brightness:0 alpha:0.7];
    [win addSubview:backgroundView];
    
    // TAB
    tableView = [[UITableView alloc] initWithFrame:frame style:0];
    tableView.dataSource = backgroundView;
    tableView.delegate = backgroundView;
    tableView.layer.cornerRadius = 5;//圆角
    tableView.rowHeight = 30;
    
    [win addSubview:tableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundClick)];
    [backgroundView addGestureRecognizer:tap];
    backgroundView.action = action;
    backgroundView.selectData = selectData;
    backgroundView.rightData = rightData;
    
    if (animate == YES) {
        backgroundView.alpha = 0;
        tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, 0);
        [UIView animateWithDuration:0.3 animations:^{
            backgroundView.alpha = 1;
            tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width,frame.size.height);
        }];
    }
}

+ (void)addPellTableViewSelectWithWindowFrame:(CGRect)frame
                                selectData:(NSArray *)selectData
                                       action:(void(^)(NSInteger index))action animated:(BOOL)animate
{
    if (backgroundView != nil) {
        [PellTableViewSelect hiden];
    }
    
//    UIWindow *win = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    //上方白色透明背景
    backgroundView = [[PellTableViewSelect alloc] initWithFrame:win.bounds];
    backgroundView.action = action;
    backgroundView.selectData = selectData;
    
    //下方灰色背景
    BlackBackgroundView = [[PellTableViewSelect alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, win.size.height)];
    BlackBackgroundView.action = action;
    BlackBackgroundView.selectData = selectData;

    

    backgroundView.backgroundColor = [UIColor colorWithHue:0
                                                saturation:0
                                                brightness:0 alpha:0];
    [win addSubview:backgroundView];
    
    [tableView.layer setBorderWidth:1.0f];\
    [tableView.layer setBorderColor:[[UIColor grayColor] CGColor]];
    
    
    BlackBackgroundView.backgroundColor = [UIColor colorWithHue:0
                                                saturation:0
                                                brightness:0 alpha:0.4];
    [win addSubview:BlackBackgroundView];
    
    // TAB
    tableView = [[UITableView alloc] initWithFrame:frame style:0];
    tableView.dataSource = backgroundView;
    tableView.delegate = backgroundView;
    tableView.layer.cornerRadius = 0;//圆角
    tableView.rowHeight = 20;
    
    [win addSubview:tableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundClick)];
    [backgroundView addGestureRecognizer:tap];
    backgroundView.action = action;
    backgroundView.selectData = selectData;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundClick)];
    [BlackBackgroundView addGestureRecognizer:tap1];
    BlackBackgroundView.action = action;
    BlackBackgroundView.selectData = selectData;
    
    
    if (animate == YES) {
        backgroundView.alpha = 0;
        BlackBackgroundView.alpha = 0;
        tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y + 0.2, tableView.frame.size.width, 0);
        [UIView animateWithDuration:0.3 animations:^{
            backgroundView.alpha = 1;
            BlackBackgroundView.alpha = 1;
            tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y + 0.2, tableView.frame.size.width,frame.size.height);
        }];
    }
}


+ (void)addPellViewSelectWithWindowFrame:(CGRect)frame
                              selectData:(NSArray *)selectData
                         backgroundImage:(UIImage *)imagename
                                 button1:(UIButton *)button1
                            button1Frame:(CGRect)button1Frame
                                 button2:(UIButton *)button2
                            button2Frame:(CGRect)button2Frame
                                   label:(UILabel *)label
                              labelFrame:(CGRect)labelFrame
                           markimageView:(UIImageView * )markimageView
                      markimageViewFrame:(CGRect)markimageViewFrame
                                  action:(void(^)(NSInteger index))action animated:(BOOL)animate
{
    if (backgroundView != nil) {
        [PellTableViewSelect hiden];
    }
    UIWindow *win = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    
    backgroundView = [[PellTableViewSelect alloc] initWithFrame:win.bounds];
    backgroundView.action = action;
    backgroundView.selectData = selectData;
    
    
    
    
    
    backgroundView.backgroundColor = [UIColor colorWithHue:0
                                                saturation:0
                                                brightness:0 alpha:0.7];
    [win addSubview:backgroundView];
    
    view = [[UIView alloc]initWithFrame:frame ];
    view.backgroundColor = [UIColor colorWithPatternImage:imagename];
    [win addSubview:view];
    
    
    
    
    button1.frame = button1Frame;
    [view addSubview:button1];
    button2.frame = button2Frame;
    [view addSubview:button2];
    label.frame = labelFrame;
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    markimageView.frame = markimageViewFrame;
    [view addSubview:markimageView];
 
//    // TAB
//    tableView = [[UITableView alloc] initWithFrame:frame style:0];
//    tableView.dataSource = backgroundView;
//    tableView.delegate = backgroundView;
//    tableView.layer.cornerRadius = 10.0f;
//    tableView.rowHeight = 40;
//    [win addSubview:tableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundClick)];
    [backgroundView addGestureRecognizer:tap];
    backgroundView.action = action;
    backgroundView.selectData = selectData;
    
    
    if (animate == YES) {
        backgroundView.alpha = 0;
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 0);
        [UIView animateWithDuration:0.3 animations:^{
            backgroundView.alpha = 1;
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width,frame.size.height);
        }];
    }
}

#pragma mark  frame显示内容的viewFrame  viewFrame frame贴在这个frame 设定全屏会让点击灰色消失功能取消
+ (void)addPellTableViewSelectWithwithView:(UIView *)UIview
                               WindowFrame:(CGRect)frame
                                WithViewFrame:(CGRect)viewFrame
                                selectData:(NSArray *)selectData
                                    action:(void(^)(NSInteger index))action animated:(BOOL)animate;
{
    if (backgroundView != nil) {
        [PellTableViewSelect hiden];
    }
//    UIWindow *win = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    backgroundView = [[PellTableViewSelect alloc] initWithFrame:win.bounds];
    backgroundView.action = action;
    backgroundView.selectData = selectData;
    
    
    
    
    
    backgroundView.backgroundColor = [UIColor colorWithHue:0
                                                saturation:0
                                                brightness:0 alpha:0.3];
    [win addSubview:backgroundView];
    
    view = [[UIView alloc]initWithFrame:viewFrame ];
//    UIview.backgroundColor = [UIColor colorWithPatternImage:imagename];
//    view.backgroundColor = [UIColor redColor];
    [win addSubview:view];
    
    
    
    UIview.frame = frame;
    [view addSubview:UIview];
    

    //    // TAB
    //    tableView = [[UITableView alloc] initWithFrame:frame style:0];
    //    tableView.dataSource = backgroundView;
    //    tableView.delegate = backgroundView;
    //    tableView.layer.cornerRadius = 10.0f;
    //    tableView.rowHeight = 40;
    //    [win addSubview:tableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundClick)];
    [backgroundView addGestureRecognizer:tap];
    backgroundView.action = action;
    backgroundView.selectData = selectData;
    
    
    if (animate == YES) {
        backgroundView.alpha = 0;
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 0);
        [UIView animateWithDuration:0.3 animations:^{
            backgroundView.alpha = 1;
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width,viewFrame.size.height);
        }];
    }
}

+ (void)addPellViewSelectWithWindowFrame:(CGRect)frame
                              selectData:(NSArray *)selectData
                          withimageView1:(UIImageView * )imageView1
                      markimageViewFrame1:(CGRect)markimageViewFrame1
                          withImageView2:(UIImageView *)imageView2
                    markimageViewFrame2:(CGRect)markimageViewFrame2
                             withbutton1:(UIButton * )button1
                        withbuttonframe1:(CGRect)buttonframe1
                             withbutton2:(UIButton *)button2
                        withbuttonframe2:(CGRect)buttonframe2
                                  action:(void(^)(NSInteger index))action animated:(BOOL)animate
{
    if (backgroundView != nil) {
        [PellTableViewSelect hiden];
    }
    UIWindow *win = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    
    backgroundView = [[PellTableViewSelect alloc] initWithFrame:win.bounds];
    backgroundView.action = action;
    backgroundView.selectData = selectData;
    
    
    
    
    
    backgroundView.backgroundColor = [UIColor colorWithHue:0
                                                saturation:0
                                                brightness:0 alpha:0.7];
    [win addSubview:backgroundView];
    
    view = [[UIView alloc]initWithFrame:frame ];
    [win addSubview:view];
    
    
    button1.frame = buttonframe1;
    [view addSubview:button1];
    button2.frame = buttonframe2;
    [view addSubview:button2];
    imageView1.frame = markimageViewFrame1;
    [view addSubview:imageView1];
    imageView2.frame = markimageViewFrame2;
    [view addSubview:imageView2];


    
    //    // TAB
    //    tableView = [[UITableView alloc] initWithFrame:frame style:0];
    //    tableView.dataSource = backgroundView;
    //    tableView.delegate = backgroundView;
    //    tableView.layer.cornerRadius = 10.0f;
    //    tableView.rowHeight = 40;
    //    [win addSubview:tableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundClick)];
    [backgroundView addGestureRecognizer:tap];
    backgroundView.action = action;
    backgroundView.selectData = selectData;
    
    
    if (animate == YES) {
        backgroundView.alpha = 0;
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 0);
        [UIView animateWithDuration:0.3 animations:^{
            backgroundView.alpha = 1;
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width,frame.size.height);
        }];
    }
}

+ (void)addPellTableViewSelectWithwithView:(UIView *)UIview
                               WindowFrame:(CGRect)frame
                             WithViewFrame:(CGRect)viewFrame
                                selectData:(NSArray *)selectData
                   WithBackgroundViewAlpha:(CGFloat)alpha
                                    action:(void(^)(NSInteger index))action animated:(BOOL)animate
{
    if (backgroundView != nil) {
        [PellTableViewSelect hiden];
    }
    //    UIWindow *win = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    backgroundView = [[PellTableViewSelect alloc] initWithFrame:CGRectMake(0, 66, win.frame.size.width, win.frame.size.height)];
    backgroundView.action = action;
    backgroundView.selectData = selectData;
    
    
    
    
    
    backgroundView.backgroundColor = [UIColor colorWithHue:0
                                                saturation:0
                                                brightness:0 alpha:0.7];
    [win addSubview:backgroundView];
    
    view = [[UIView alloc]initWithFrame:viewFrame ];
    //    UIview.backgroundColor = [UIColor colorWithPatternImage:imagename];
    //    view.backgroundColor = [UIColor redColor];
    [win addSubview:view];
    
    
    
    UIview.frame = frame;
    [view addSubview:UIview];
    
    
    //    // TAB
    //    tableView = [[UITableView alloc] initWithFrame:frame style:0];
    //    tableView.dataSource = backgroundView;
    //    tableView.delegate = backgroundView;
    //    tableView.layer.cornerRadius = 10.0f;
    //    tableView.rowHeight = 40;
    //    [win addSubview:tableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundClick)];
    [backgroundView addGestureRecognizer:tap];
    backgroundView.action = action;
    backgroundView.selectData = selectData;
    
    
    if (animate == YES) {
        backgroundView.alpha = 0;
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 0);
        [UIView animateWithDuration:0.3 animations:^{
            backgroundView.alpha = alpha;
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width,viewFrame.size.height);
        }];
    }
}

+ (void)addPellTableViewSelectWithwithView:(UIView *)UIview
                               WindowFrame:(CGRect)frame
                             WithViewFrame:(CGRect)viewFrame
                                selectData:(NSArray *)selectData
                                WithButton:(UIButton *)clectButton
                                    action:(void(^)(NSInteger index))action animated:(BOOL)animate
{
    if (backgroundView != nil) {
        [PellTableViewSelect hiden];
    }
    //    UIWindow *win = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    backgroundView = [[PellTableViewSelect alloc] initWithFrame:win.bounds];
    backgroundView.action = action;
    backgroundView.selectData = selectData;
    backgroundView.clectButton = clectButton;
    
    
    
    
    backgroundView.backgroundColor = [UIColor colorWithHue:0
                                                saturation:0
                                                brightness:0 alpha:0.7];
    [win addSubview:backgroundView];
    
    view = [[UIView alloc]initWithFrame:viewFrame ];
    //    UIview.backgroundColor = [UIColor colorWithPatternImage:imagename];
    //    view.backgroundColor = [UIColor redColor];
    [win addSubview:view];
    
    
    
    UIview.frame = frame;
    [view addSubview:UIview];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundClick)];
    [backgroundView addGestureRecognizer:tap];
    backgroundView.action = action;
    backgroundView.selectData = selectData;
    
    
    if (animate == YES) {
        backgroundView.alpha = 0;
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 0);
        [UIView animateWithDuration:0.3 animations:^{
            backgroundView.alpha = 1;
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width,viewFrame.size.height);
        }];
    }
}

+ (void)tapBackgroundClick
{
    
    
    [PellTableViewSelect hiden];
}

+ (void)hiden
{
    [backgroundView removeFromSuperview];
    [BlackBackgroundView removeFromSuperview];
    [tableView removeFromSuperview];
    [view removeFromSuperview];
    tableView = nil;
    view = nil;
    backgroundView = nil;
    BlackBackgroundView = nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _selectData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"PellTableViewSelectIdentifier";
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:Identifier];
    }
    if (self.YMQuHao == NO) {
        cell.textLabel.text = _selectData[indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }else{
        for (UILabel * label in cell.subviews) {
            if ([label isKindOfClass:[UILabel class]]) {
                 [label removeFromSuperview];
            }
        }
        UILabel * topfgx = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 375, 1)];
        topfgx.backgroundColor = [UIColor grayColor];
        [cell addSubview:topfgx];
        
        UILabel * leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 375,50)];
        leftLabel.text = _selectData[indexPath.row];
        leftLabel.font = [UIFont fontWithName:@"" size:16];
        [cell addSubview:leftLabel];
        
        UILabel * rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        rightLabel.text = _rightData[indexPath.row];
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.font = [UIFont fontWithName:@"" size:16];
        [cell addSubview:rightLabel];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.action) {
        self.action(indexPath.row);
    }
    [PellTableViewSelect hiden];
}
@end
