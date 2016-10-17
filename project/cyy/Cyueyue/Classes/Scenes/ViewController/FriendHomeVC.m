
//
//  FriendHomeVC.m
//  Cyueyue
//
//  Created by fami_Lbb on 16/9/6.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import "FriendHomeVC.h"
#define timeLineY 128
#warning yue的时候把当前用户和好友userID传入后台得到match结果

@interface FriendHomeVC ()

//side
@property (nonatomic,strong)YRSideViewController *sideVC;
@property (nonatomic,strong)SideViewController *mySide;
@property (nonatomic,strong)UIButton *butName;

//时间线
@property (nonatomic,strong)TimeLineViewController *timeLineC;
@property (nonatomic,assign)NSInteger timeLinY;

@end

@implementation FriendHomeVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
    }
    return self;
}



//添加日历
- (void)loadView{
    
    UIView *view = [[UIView alloc]initWithFrame:kScreen_Bounds];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view = view;
    
    self.timeLinY = timeLineY;

    CGFloat height = [[UIDevice currentDevice].model hasPrefix:@"iPad"] ? 480 : 330;
    FSCalendar *calendar = [[FSCalendar alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, height)];
    
    calendar.layer.shadowOpacity = 0.5;// 阴影透明度
    calendar.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影的颜色
    calendar.layer.shadowRadius = 3;// 阴影扩散的范围控制
    calendar.layer.shadowOffset = CGSizeMake(1, 1);// 阴影的范围
    
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.scopeGesture.enabled = YES;
    calendar.showsScopeHandle = NO;
    calendar.appearance.todayColor = cYellow;
    calendar.appearance.selectionColor = cTopicBlue;
    calendar.appearance.weekdayFont = [UIFont systemFontOfSize:13];
    calendar.backgroundColor = [UIColor whiteColor];
    
    //添加时间轴列表
    self.timeLineC = [[TimeLineViewController alloc]init];
    self.timeLineC.onEdit = NO;
    CGRect frame = CGRectMake(0, self.timeLinY, kScreen_Width, kScreen_Height - self.timeLinY - 64 - 46);
    self.timeLineC.scrollView.frame = frame;
    
    [self addChildViewController:self.timeLineC];
    
    [self.view addSubview:self.timeLineC.view];
    [view addSubview:calendar];
    self.calendar = calendar;

    [self drawIntroduce];
}

#pragma mark ---好友简介的显示和好友资料的入口---

- (void)drawIntroduce{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 40)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(19, 9, 10, 21)];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:self.strName forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rofileAction) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    
    
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button.frame), 7, 15, 13)];
    imgV.image = [UIImage imageNamed:@"名片"];
    
    UIButton *backgroup = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button.frame), 5, kScreen_Width/2 - 50, 29)];
    backgroup.backgroundColor = [UIColor clearColor];
    [backgroup setTitle:@"" forState:UIControlStateNormal];
    [backgroup addTarget:self action:@selector(rofileAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imgPhone = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width - 46, 10, 30, 22)];
    imgPhone.userInteractionEnabled = YES;
    imgPhone.image = [UIImage imageNamed:@"拨打"];
    imgPhone.contentMode = UIViewContentModeScaleAspectFit;
    
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(phoneAction)];
    [imgPhone addGestureRecognizer:tap];
    
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(19, 41, kScreen_Width - 38, 1)];
    viewLine.backgroundColor = cCustom(231, 230, 230, 1);
    
    [view addSubview:button];
    [view addSubview:imgV];
    [view addSubview:backgroup];
    [view addSubview:imgPhone];
    [view addSubview:viewLine];
    
    [self.calendar addSubview:view];
    
    
    UIView *bottonView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreen_Height - 64 - 60, kScreen_Width, 60)];
    bottonView.backgroundColor = [UIColor whiteColor];
    
    UIButton *aboutBut = [[UIButton alloc]initWithFrame:CGRectMake(kScreen_Width - 110, 7, 100, 46)];
    aboutBut.backgroundColor = cYellow;
    aboutBut.layer.masksToBounds = YES;
    aboutBut.layer.cornerRadius = 5;
    [aboutBut setTitle:@"约" forState:UIControlStateNormal];
    [aboutBut addTarget:self action:@selector(yueAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [bottonView addSubview:aboutBut];
    [self.view addSubview:bottonView];
}

//跳转到好友的资料列表页
- (void)rofileAction{
    FriendMaterialViewController *materVC = [[FriendMaterialViewController alloc]init];
    materVC.strName = self.strName;
    materVC.strPhone = self.strPhone;
    [self.navigationController pushViewController:materVC animated:YES];
}

//拨打电话
- (void)phoneAction{
    
    NSMutableString *str = [[NSMutableString alloc]initWithFormat:@"tel:%@",self.strPhone ];
    UIWebView *callWebView = [[UIWebView alloc]init];
    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];

    [self.view addSubview:callWebView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    //日历的基础设置
    [self.calendar setCurrentPage:[NSDate date] animated:YES];
    self.title = [NSString stringWithFormat:@"%@月 %ld",[self month:self.calendar.today],[self year:self.calendar.today]];
    self.calendar.scope = FSCalendarScopeWeek;
    
    
    //导航栏左按钮
    [self addNavgationLeftButton];
}


#pragma mark --导航栏左按钮--
- (void)addNavgationLeftButton{
    
    ILBarButtonItem *barButton = [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"返回白"] selectedImage:[UIImage imageNamed:@"返回白"] target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = barButton;
    
}

- (void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//match
- (void)yueAction:(id)sender{
    
    MatchViewController *matchVC = [[MatchViewController alloc]init];
    [self.navigationController pushViewController:matchVC animated:YES];
}
#pragma mark --日历改变当前页面执行的方法--
//这里做了一个小操作，在原有的基础上，滑动的时候默认点击当月的第一天
- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar{
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *reportDate = [format stringFromDate:calendar.currentPage];
    NSDate *date = [format dateFromString:reportDate];
    //原日历的基础上推后一天，默认每月1号
    NSDate *newDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date timeIntervalSinceReferenceDate])];
    reportDate = [format stringFromDate:newDate];
    [self.calendar selectDate:newDate];
    self.title = [NSString stringWithFormat:@"%@月 %ld",[self month:newDate],[self year:newDate]];
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date{
    
    self.title = [NSString stringWithFormat:@"%@月 %ld",[self month:date],[self year:date]];
    
}

//当前日期的月份
- (NSString *)month:(NSDate *)date{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    //阿拉伯数字转中文汉字
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterRoundHalfDown;
    NSString *month = [formatter stringFromNumber:[NSNumber numberWithInteger:components.month]];
    
    return month;
}

//当前日期的年份
- (NSUInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    
    return components.year;
}

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
    [UIView animateWithDuration:0.3 animations:^{
        self.timeLinY = bounds.size.height + 7;
        CGRect frame = self.timeLineC.scrollView.frame;
        frame.origin.y = self.timeLinY;
        frame.size.height = kScreen_Height - frame.origin.y - 64 - 46;
        
        self.timeLineC.scrollView.frame = frame;
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
