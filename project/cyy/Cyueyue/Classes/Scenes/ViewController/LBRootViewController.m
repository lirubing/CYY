//
//  LBRootViewController.m
//  Cyueyue
//
//  Created by fami_Lbb on 16/7/25.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import "LBRootViewController.h"
//#import "YRSideViewController.h"
#import "SideViewController.h"
#define timeLineY 86
#warning 添加数据的时候要判断是添加还是修改

@interface LBRootViewController ()
//side
@property (nonatomic,strong)YRSideViewController *sideVC;
@property (nonatomic,strong)SideViewController *mySide;
@property (nonatomic,strong)SuspensionView *suspenView;

@property (nonatomic,strong)YueFirendViewController *yueFirendVC;

@property (nonatomic,strong)UIView *backGroundView;
//时间线
@property (nonatomic,strong)TimeLineViewController *timeLineVC;
@property (nonatomic,assign)NSInteger timeLinY;
//当前所在的日期
@property (nonatomic,strong)NSDate *dayTime;
@end

@implementation LBRootViewController

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
    FSCalendar *calendar = [[FSCalendar alloc]initWithFrame:CGRectMake(0, -40, kScreen_Width, height)];
    
    calendar.layer.shadowOpacity = 0.4;// 阴影透明度
    calendar.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影的颜色
    calendar.layer.shadowRadius = 3;// 阴影扩散的范围控制
    calendar.layer.shadowOffset = CGSizeMake(1, 2);// 阴影的范围
    
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.scopeGesture.enabled = YES;
    calendar.showsScopeHandle = NO;
    calendar.appearance.todayColor = cYellow;
    calendar.appearance.selectionColor = cTopicBlue;
    calendar.appearance.weekdayFont = [UIFont systemFontOfSize:13];
    calendar.backgroundColor = [UIColor whiteColor];
    
    //添加时间轴列表
    self.timeLineVC = [[TimeLineViewController alloc]init];
    CGRect frame = CGRectMake(0, self.timeLinY, kScreen_Width, kScreen_Height - self.timeLinY - 64);
    self.timeLineVC.scrollView.frame = frame;
    
    
    for (int i = 0; i < 5; i++) {
        
        PersonToContactModel *model = [[PersonToContactModel alloc]init];
        model.beginTime = [NSString stringWithFormat:@"%d:00",7+i];
        model.endTime = [NSString stringWithFormat:@"%d:00",8+i];
        model.content = @"去吃烧烤啊哈哈哈哈哈哈哈哈😊";
        model.addressStr = @"北京市西城区天南门";
        
        [self.timeLineVC.allDateArr addObject:model];
    }
    
    
    for (int i = 0; i < 3; i++) {

        PersonToContactModel *model = [[PersonToContactModel alloc]init];
        model.beginTime = [NSString stringWithFormat:@"%d:00",13+i];
        model.endTime = [NSString stringWithFormat:@"%d:00",14+i];

        for (int i = 0; i < 10; i++) {

            YueFirendModel *mode = [[YueFirendModel alloc]init];
            mode.friendName = [NSString stringWithFormat:@"张含韵%d",i];
            mode.friendEvent = [NSString stringWithFormat:@"来看我的演唱会啊啊aaaaaa啊啊%d",i];
            mode.friendAddress = [NSString stringWithFormat:@"青龙胡同%d号",i];
            
            [model.yueFriendArr addObject:mode];
        }

        [self.timeLineVC.friendYueArr addObject:model];
    }
    
    
    
    [self addChildViewController:self.timeLineVC];
    
    [self.view addSubview:self.timeLineVC.view];
    [self.view addSubview:calendar];
    self.calendar = calendar;
    
}

//设置侧滑是否开启
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.sideVC = [[LBHelpers shareLBHeloper] getRootViewController];
    self.sideVC.needSwipeShowMenu = YES;
    
    //自己的日程可编辑
    self.timeLineVC.onEdit = YES;
    
    //页面即将出现的时候刷新日程
    //日历的基础设置
    [self.calendar setCurrentPage:[NSDate date] animated:YES];
    self.title = [NSString stringWithFormat:@"%@月 %ld",[self month:self.calendar.today],[self year:self.calendar.today]];
    self.calendar.scope = FSCalendarScopeWeek;
    
   
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // NSString *nowDate = [self.calendar stringFromDate:[NSDate date] format:@"yyyy-MM-dd"];
    
  //  NSLog(@"%@",nowDate);
    
    //[self.calendar selectDate:[self.calendar dateFromString:nowDate format:@"yyyy-MM-dd"]];
    
    //日历的基础设置
    [self.calendar setCurrentPage:[NSDate date] animated:YES];
    self.title = [NSString stringWithFormat:@"%@月 %ld",[self month:self.calendar.today],[self year:self.calendar.today]];
    self.calendar.scope = FSCalendarScopeWeek;
    
    //当前所在日期
    self.dayTime = self.calendar.today;
    
    //导航栏左按钮
    [self addNavgationLeftButton];
    [self drawSuspenView];
    
    //添加数据
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addAction:) name:@"LocationNotificationAddAction" object:nil];
    //跳转定位
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goLocation) name:@"LocationNotification" object:nil];
    
    //编辑事件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(editEvent:) name:@"EditNotfication" object:nil];
    
    //约我的好友列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendList:) name:@"YueListNotfication" object:nil];
    
    //约好友事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(firendYueAction:) name:@"FirendActionNotfication" object:nil];

}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    //试图即将消失时
    self.sideVC.needSwipeShowMenu = NO;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"LocationNotification" object:nil];
}

#pragma mark --导航栏左按钮--
- (void)addNavgationLeftButton{
   
    ILBarButtonItem *barButton = [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"侧栏"] selectedImage:[UIImage imageNamed:@"侧栏"] target:self action:@selector(sideAction)];
    self.navigationItem.leftBarButtonItem = barButton;
    
}

- (void)sideAction{
   
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    YRSideViewController *sideVC = [appDelegate sideVC];
    [sideVC showLeftViewController:YES];
}

#pragma mark  -------填写框相关------

- (void)drawSuspenView{
    //填写框
    self.suspenView = [[SuspensionView alloc]init];
    self.suspenView.view.userInteractionEnabled = YES;
    self.suspenView.view.alpha = 0;
    [self addChildViewController:self.suspenView];
    [self.view addSubview:self.suspenView.view];
    
    self.yueFirendVC = [[YueFirendViewController alloc]init];
    self.yueFirendVC.view.alpha = 0;
    [self addChildViewController:self.yueFirendVC];
    [self.view addSubview:self.yueFirendVC.view];
}

#warning 添加数据的时候要判断是添加还是修改
- (void)addAction:(NSNotification *)info{
    
    NSString *beginTime = info.userInfo[@"beginTime"];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.suspenView.editOn = NO;
        self.suspenView.view.alpha = 1;
        
        self.suspenView.arrayDate = self.timeLineVC.allDateArr;
        PersonToContactModel *model = [PersonToContactModel new];
        model.dateLabel = self.dayTime;
        model.beginTime = beginTime;
        self.suspenView.model = model;
        
        
        
    }];
    
}

//约我的好友列表
- (void)friendList:(NSNotification *)nf{
    
    self.yueFirendVC.view.alpha = 1;
    self.yueFirendVC.model = nf.userInfo[@"friendList"];
}

//约好友事件





    self.yueFirendVC.view.alpha = 0;

    [UIView animateWithDuration:0.3 animations:^{
        
        self.suspenView.editOn = NO;
        self.suspenView.view.alpha = 1;
        
        PersonToContactModel *model = [PersonToContactModel new];
        model.dateLabel = self.dayTime;
        model.beginTime = @"18:00";
        self.suspenView.model = model;
        
    }];
}



//定位
- (void)goLocation{
    
    NSLog(@"location");
    LocationViewController *locationVC = [[LocationViewController alloc]init];
    locationVC.block =^(NSString *string){
        self.suspenView.location.text = string;
    };
    [self.navigationController pushViewController:locationVC animated:YES];
}

//编辑事件
- (void)editEvent:(NSNotification *)nf{
    
    NSString *content = nf.userInfo[@"content"];
    NSString *address = nf.userInfo[@"address"];
    NSString *beginTime = nf.userInfo[@"beginTime"];
    NSString *endTime = nf.userInfo[@"endTime"];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.suspenView.view.alpha = 1;
        self.suspenView.editOn = YES;
        
        PersonToContactModel *model = [PersonToContactModel new];
        model.dateLabel = self.dayTime;
        model.beginTime = beginTime;
        model.endTime = endTime;
        model.content = content;
        model.addressStr = address;
        self.suspenView.model = model;
        
    }];

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
    
    //点击的天数要加一天才是实际点击的天数
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    
    NSString *dateString = [NSString stringWithFormat:@"%ld-%ld-%ld",components.year,components.month,components.day];
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //NSString转NSDate
    NSDate *dateNew=[formatter dateFromString:dateString];
    self.dayTime = dateNew;
    
#warning  点击天数的时候去请求数据
    
    [self.timeLineVC.friendYueArr removeAllObjects];
    [self.timeLineVC.allDateArr removeAllObjects];
    
    for (int i = 0; i < 5; i++) {
        
        PersonToContactModel *model = [[PersonToContactModel alloc]init];
        model.beginTime = [NSString stringWithFormat:@"%d:00",7+i];
        model.endTime = [NSString stringWithFormat:@"%d:00",8+i];
        model.content = @"烤鱼鱼鱼鱼鱼啊哈哈哈";
        model.addressStr = @"北京市西城区天南门";
        
        [self.timeLineVC.allDateArr addObject:model];
    }
    
    
    for (int i = 0; i < 6; i++) {
        
        PersonToContactModel *model = [[PersonToContactModel alloc]init];
        model.beginTime = [NSString stringWithFormat:@"%d:00",13+i];
        model.endTime = [NSString stringWithFormat:@"%d:00",14+i];
        
        for (int i = 0; i < 10; i++) {
            
            YueFirendModel *mode = [[YueFirendModel alloc]init];
            mode.friendName = [NSString stringWithFormat:@"张哈哈%d",i];
            mode.friendEvent = [NSString stringWithFormat:@"玩电脑就我看你今晚跨年啊啊啊%d",i];
            mode.friendAddress = [NSString stringWithFormat:@"青龙胡同%d号",i];
            
            [model.yueFriendArr addObject:mode];
        }
        
        [self.timeLineVC.friendYueArr addObject:model];
    }
    
    [self.timeLineVC viewWillAppear:YES];
        
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
        self.timeLinY = bounds.size.height - 33;
        CGRect frame = self.timeLineVC.scrollView.frame;
        frame.origin.y = self.timeLinY;
        frame.size.height = kScreen_Height - frame.origin.y - 64;
        
        self.timeLineVC.scrollView.frame = frame;
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
