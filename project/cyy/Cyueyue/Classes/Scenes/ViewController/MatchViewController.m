//
//  matchViewController.m
//  Cyueyue
//
//  Created by fami_Lbb on 16/9/28.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import "MatchViewController.h"
#define timeLineY 86


@interface MatchViewController ()

@property (nonatomic,strong)TimeWeekViewController *timeWeekVC;

@property (nonatomic,assign)NSInteger timeLinY;

@property (nonatomic,strong)YueCarbonViewController *yueCarbonView;

@end

@implementation MatchViewController

//添加日历
- (void)loadView{
    
    UIView *view = [[UIView alloc]initWithFrame:kScreen_Bounds];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view = view;
    
    self.timeLinY = timeLineY;
    
    CGFloat height = [[UIDevice currentDevice].model hasPrefix:@"iPad"] ? 480 : 330;
    FSCalendar *calendar = [[FSCalendar alloc]initWithFrame:CGRectMake(40, -40, kScreen_Width - 40, height)];
    
//    calendar.layer.shadowOpacity = 0.4;// 阴影透明度
//    calendar.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影的颜色
//    calendar.layer.shadowRadius = 3;// 阴影扩散的范围控制
//    calendar.layer.shadowOffset = CGSizeMake(0, 2);// 阴影的范围
    
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.scopeGesture.enabled = NO;
    calendar.showsScopeHandle = NO;
    calendar.appearance.todayColor = cYellow;
    calendar.appearance.selectionColor = cTopicBlue;
    calendar.appearance.weekdayFont = [UIFont systemFontOfSize:13];
    calendar.backgroundColor = [UIColor whiteColor];
    
    self.timeWeekVC = [[TimeWeekViewController alloc]init];
    CGRect frame = CGRectMake(0, self.timeLinY, kScreen_Width, kScreen_Height - self.timeLinY - 64 - 46);
    self.timeWeekVC.scrollView.frame = frame;
    
    [self addChildViewController:self.timeWeekVC];
    [self.view addSubview:self.timeWeekVC.view];
    
    [view addSubview:calendar];
    self.calendar = calendar;
    
    UIView *coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 81, kScreen_Width,0.5)];
    coverView.backgroundColor = cLight;
    
    coverView.layer.shadowOpacity = 1;// 阴影透明度
    coverView.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影的颜色
    coverView.layer.shadowRadius = 3;// 阴影扩散的范围控制
    coverView.layer.shadowOffset = CGSizeMake(1, 2);// 阴影的范围

    [self.view addSubview:coverView];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //日历的基础设置
    [self.calendar setCurrentPage:[NSDate date] animated:YES];
    self.title = [NSString stringWithFormat:@"%@月 %ld",[self month:self.calendar.today],[self year:self.calendar.today]];
    self.calendar.scope = FSCalendarScopeWeek;
    
    //左按钮
    [self addNavgationLeftButton];
    [self inputBottonView];
    
    //填写框
    [self drawSuspenView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setLocation) name:@"LocationNot" object:nil];
}

#pragma mark --导航栏左按钮--
- (void)addNavgationLeftButton{
    
    ILBarButtonItem *barButton = [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"返回白"] selectedImage:[UIImage imageNamed:@"返回白"] target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = barButton;
    
}

//约的按钮
- (void)inputBottonView{
   
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


- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

//约
- (void)yueAction:(id)sender{
   
    self.yueCarbonView.view.alpha = 1;

}

#pragma mark  -------填写框相关------
- (void)drawSuspenView{
    //填写框
    self.yueCarbonView = [[YueCarbonViewController alloc]init];
    self.yueCarbonView.view.userInteractionEnabled = YES;
    self.yueCarbonView.view.alpha = 0;
    
    [self addChildViewController:self.yueCarbonView];
    [self.view addSubview:self.yueCarbonView.view];
}

//定位
- (void)setLocation{
    
    NSLog(@"location");
    LocationViewController *locationVC = [[LocationViewController alloc]init];
    locationVC.block =^(NSString *string){
        self.yueCarbonView.location.text = string;
    };
    
    [self.navigationController pushViewController:locationVC animated:YES];
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
    
//    //点击的天数要加一天才是实际点击的天数
//    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
//    
//    NSString *dateString = [NSString stringWithFormat:@"%ld-%ld-%ld",components.year,components.month,components.day];
//    //设置转换格式
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    //NSString转NSDate
//    NSDate *dateNew=[formatter dateFromString:dateString];
//    
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
