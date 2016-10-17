//
//  TimeLineViewController.m
//  Cyueyue
//
//  Created by fami_Lbb on 16/9/30.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import "TimeLineViewController.h"
#define tabViewX 53
#define tabViewH 890
#define eventViewX 13
#define eventViewWidth kScreen_Width - 13 - tabViewX

#warning 点击已添加事件，修改 2.将删除事件写入后台

@interface TimeLineViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSArray *arrayAllTime;
@property (nonatomic,strong)NSArray *arrayTime;

@property (nonatomic,strong)UILabel *contentLab;
@property (nonatomic,strong)UILabel *addressLab;

@property (nonatomic,strong)UIView *eventView;
//标记当前要删除的tag
@property (nonatomic,assign)NSInteger deteleIndex;

@property (nonatomic,strong)PersonToContactModel *deteleModel;

//添加时间时的tag初始值；
@property (nonatomic,assign)NSInteger eventIndex;
@end

@implementation TimeLineViewController

static NSString *const cellID = @"cellID";

//可滑动区域
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.scrollView.contentSize = CGSizeMake(0, tabViewH);
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];

    for (int i = 0; i < 30; i++) {
        UIView *view = [self.view viewWithTag:1000 + i];
        
        UIView *viewY = [self.view viewWithTag:2000 + i];
        [view removeFromSuperview];
        [viewY removeFromSuperview];
    }
    
    self.eventIndex = 0;
    
    [self drawEventView];
    [self drawYueEventView];
    
    
    //scrollview 滑动到顶端
    CGPoint offset = self.scrollView.contentOffset;
    offset.y = - self.scrollView.contentInset.top;
    [self.scrollView setContentOffset:offset animated:YES];
    
    
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    view.backgroundColor = [UIColor whiteColor];
    self.view  = view;
    

    for (int i = 0; i < self.arrayTime.count; i++) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 10 + i * 50, 40, 20)];
        label.text = self.arrayTime[i];
        label.font = [UIFont systemFontOfSize:14];
        [self.scrollView addSubview:label];
    }
    
    
    [self.scrollView addSubview:self.tableView];
    
    [self.view addSubview:self.scrollView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishAddAction:) name:@"NSNotficationFinishAddAction" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteEvent) name:@"NSNotficationDelete" object:nil];

    
#warning 从后台取数据
//    [self.allDateArr removeAllObjects];
//    
//    for (int i = 0; i < 5; i++) {
//        
//        PersonToContactModel *model = [[PersonToContactModel alloc]init];
//        model.beginTime = [NSString stringWithFormat:@"%d:00",7+i];
//        model.endTime = [NSString stringWithFormat:@"%d:00",8+i];
//        model.content = @"去吃烧烤啊哈哈哈哈哈哈哈哈😊";
//        model.addressStr = @"北京市西城区天南门";
//        
//        [self.allDateArr addObject:model];
//        
//    }
//    
//    [self drawEventView];
//
//    
//    [self.friendYueArr removeAllObjects];
//
//    for (int i = 0; i < 3; i++) {
//        
//        PersonToContactModel *model = [[PersonToContactModel alloc]init];
//        model.beginTime = [NSString stringWithFormat:@"%d:00",13+i];
//        model.endTime = [NSString stringWithFormat:@"%d:00",14+i];
//        
//        for (int i = 0; i < 10; i++) {
//            
//            YueFirendModel *mode = [[YueFirendModel alloc]init];
//            mode.friendName = [NSString stringWithFormat:@"张含韵%d",i];
//            mode.friendEvent = [NSString stringWithFormat:@"来看我的演唱会啊啊啊啊%d",i];
//            mode.friendAddress = [NSString stringWithFormat:@"青龙胡同%d号",i];
//            
//            [model.yueFriendArr addObject:mode];
//        }
//        
//        [self.friendYueArr addObject:model];
//    }
//    
//    PersonToContactModel *model = [[PersonToContactModel alloc]init];
//    model.beginTime = [NSString stringWithFormat:@"%d:00",18];
//    model.endTime = [NSString stringWithFormat:@"%d:00",20];
//    
//    for (int i = 0; i < 5; i++) {
//        
//        YueFirendModel *mode = [[YueFirendModel alloc]init];
//        mode.friendName = [NSString stringWithFormat:@"张哈%d",i];
//        mode.friendEvent = [NSString stringWithFormat:@"啊哈哈哈哈演唱会啊啊啊啊%d",i];
//        mode.friendAddress = [NSString stringWithFormat:@"青哈哈龙胡同%d号",i];
//        
//        [model.yueFriendArr addObject:mode];
//    }
//
//    [self.friendYueArr addObject:model];
    

//    [self drawYueEventView];
    
    
}


//绘制事件
- (void)drawEventView{
    
    
    for (int i = 0; i < self.allDateArr.count; i++) {
        
        PersonToContactModel *model = [[PersonToContactModel alloc]init];
        model = self.allDateArr[i];
        
        [self setEventActionWithModel:model WithIndex:self.eventIndex];
        
        self.eventIndex++;
    }
    
}
//绘制约我的事件
- (void)drawYueEventView{
    
    for (int i = 0; i < self.friendYueArr.count; i++) {
        
        PersonToContactModel *model = [[PersonToContactModel alloc]init];
        model = self.friendYueArr[i];
        
        [self setYueEventActionWithModel:model WithIndex:i];
        
    }
    
}


//添加事件
- (void)finishAddAction:(NSNotification *)nf{
    
    NSString *content = nf.userInfo[@"content"];
    NSString *address = nf.userInfo[@"address"];
    NSString *beginTime = nf.userInfo[@"beginTime"];
    NSString *endTime = nf.userInfo[@"endTime"];
    NSString *editOn = nf.userInfo[@"editOn"];
    
    PersonToContactModel *model = [[PersonToContactModel alloc]init];
    model.content = content;
    model.addressStr = address;
    model.beginTime = beginTime;
    model.endTime = endTime;
    
    //如果是编辑
    if ([editOn isEqualToString:@"YES"]) {
        [self deleteEvent];
    }
    
    
#warning 先添加到页面上。存到数据库
    [self.allDateArr addObject:model];
    [self setEventActionWithModel:model WithIndex:self.eventIndex];
    self.eventIndex++;
}

//删除事件
- (void)deleteEvent{
    
    for (UIView *view in self.tableView.subviews) {
        
        if (view.tag == self.deteleIndex) {
            
            UILabel *beginT = [view.subviews objectAtIndex:2];
            
            for (int i = 0; i < self.allDateArr.count; i++) {
                
                PersonToContactModel *model = self.allDateArr[i];
                if ([beginT.text isEqualToString:model.beginTime]) {
                    
                    [self.allDateArr removeObject:model];
                }
            }
            
            [view removeFromSuperview];
        }
    }
    
    
//    [self.tableView reloadData];
    
#warning 将删除事件写入后台
    
    
}

//写入事件的绘制
- (void)setEventActionWithModel:(PersonToContactModel *)model WithIndex:(NSInteger)index{
    
    NSInteger beginIndex = 0;
    NSInteger endIndex = 0;
    
    for (int i = 0; i < self.arrayAllTime.count; i++) {
        if ([model.beginTime isEqualToString:self.arrayAllTime[i]]) {
            beginIndex = i;
        }
        
        if ([model.endTime isEqualToString:self.arrayAllTime[i]]) {
            endIndex = i;
        }
        
    }
    
    //高度减1为了区别开来临近的事件
    UIView *eventView = [[UIView alloc]initWithFrame:CGRectMake(eventViewX, 20 + beginIndex*25,eventViewWidth, (endIndex - beginIndex) * 25 - 1)];
    eventView.backgroundColor = cCustom(181, 203, 248, 1);
    eventView.tag = 1000 + index;
//    NSLog(@"-=-=-=-=-=-=%ld",eventView.tag);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editAction:)];
    [eventView addGestureRecognizer:tap];
    
    UILabel *contentLab = [[UILabel alloc]init];
    contentLab.frame = CGRectMake(10, 5, eventViewWidth, 20);
    contentLab.text = model.content;
    contentLab.font = [UIFont systemFontOfSize:15];
    
    UILabel *addressLab = [[UILabel alloc]init];
    addressLab.frame = CGRectMake(10, 25, eventViewWidth, 20);
    addressLab.font = [UIFont systemFontOfSize:12];
    addressLab.text = model.addressStr;
    addressLab.alpha = 1;
    
    UILabel *beginTimeLab = [[UILabel alloc]init];
    beginTimeLab.text = model.beginTime;
    
    UILabel *endTimeLab = [[UILabel alloc]init];
    endTimeLab.text = model.endTime;
    
    if (eventView.frame.size.height <= 30) {
        
        addressLab.alpha = 0;
    }
    
    [eventView addSubview:contentLab];
    [eventView addSubview:addressLab];
    [eventView addSubview:beginTimeLab];
    [eventView addSubview:endTimeLab];
    
    [self.tableView addSubview:eventView];

}

//绘制约我的视图
- (void)setYueEventActionWithModel:(PersonToContactModel *)model WithIndex:(NSInteger)index{

    NSInteger beginIndex = 0;
    NSInteger endIndex = 0;
    
    for (int i = 0; i < self.arrayAllTime.count; i++) {
        if ([model.beginTime isEqualToString:self.arrayAllTime[i]]) {
            beginIndex = i;
        }
        
        if ([model.endTime isEqualToString:self.arrayAllTime[i]]) {
            endIndex = i;
        }
        
    }
    
    //高度减1为了区别开来临近的事件
    UIView *eventView = [[UIView alloc]initWithFrame:CGRectMake(eventViewX, 20 + beginIndex*25,eventViewWidth, (endIndex - beginIndex) * 25 - 1)];
    eventView.backgroundColor = cCustom(255, 211, 206, 1);
    eventView.tag = 2000 + index;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(yueList:)];
    [eventView addGestureRecognizer:tap];
    
    [self.tableView addSubview:eventView];
    
}


#pragma mark ------点击试图进行编辑------
- (void)editAction:(UIGestureRecognizer*)gestureRecognizer{
    //获取当前点击的内容
    UIView *view = gestureRecognizer.view;
    UILabel *labelCon = view.subviews.firstObject;
    UILabel *labelAdd = [view.subviews objectAtIndex:1];
    UILabel *beginT = [view.subviews objectAtIndex:2];
    UILabel *endT = view.subviews.lastObject;
    
    self.deteleIndex = view.tag;
    
//    NSLog(@"%@____%@---%@----%@",labelCon.text,labelAdd.text,beginT.text,endT.text);
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"EditNotfication" object:nil userInfo:@{@"content":labelCon.text,@"address":labelAdd.text,@"beginTime":beginT.text,@"endTime":endT.text}];
    
}

//约我的好友列表
- (void)yueList:(UIGestureRecognizer *)gestureRecognizer{
    
    //获取当前点击的内容
    UIView *view = gestureRecognizer.view;
    self.deteleIndex = view.tag;
    
    NSInteger index = 0;
    index = self.deteleIndex - 2000;
    PersonToContactModel *model = self.friendYueArr[index];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"YueListNotfication" object:nil userInfo:@{@"friendList":model}];
    
}




#pragma mark ----UITableViewDelegate----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayTime.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        return 20;
    }
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"%ld",indexPath.row);
    
    //自己的日程可编辑
    if (self.onEdit) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationNotificationAddAction" object:nil userInfo:@{@"beginTime":self.arrayTime[indexPath.row - 1]}];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    


    cell.textLabel.text = @"";
    return cell;
    
}

- (void)dealloc{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    self.scrollView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
//        _scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        //不反弹
        _scrollView.bounces = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollEnabled = YES;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.scrollsToTop = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(tabViewX, 0, kScreen_Width - 60,tabViewH) style:UITableViewStylePlain];
//        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
        
    }
    return _tableView;
}

- (NSArray *)arrayAllTime{
    if (!_arrayAllTime) {
        _arrayAllTime = @[@"7:00",@"7:30",@"8:00",@"8:30",@"9:00",@"9:30",@"10:00",@"10:30",@"11:00",@"11:30",@"12:00",@"12:30",@"13:00",@"13:30",@"14:00",@"14:30",@"15:00",@"15:30",@"16:00",@"16:30",@"17:00",@"17:30",@"18:00",@"18:30",@"19:00",@"19:30",@"20:00",@"20:30",@"21:00",@"21:30",@"22:00",@"22:30",@"23:00",@"23:30",@"24:00"];
    }
    return _arrayAllTime;
}

- (NSArray *)arrayTime{
    if (!_arrayTime) {
        _arrayTime = @[@"7:00",@"8:00",@"9:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00",@"19:00",@"20:00",@"21:00",@"22:00",@"23:00",@"24:00"];
    }
    return _arrayTime;
}

- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [[UILabel alloc]init];
        _contentLab.font = [UIFont systemFontOfSize:14];
    }
    return _contentLab;
}

- (UILabel *)addressLab{
    if (!_addressLab) {
        _addressLab = [[UILabel alloc]init];
        _addressLab.font = [UIFont systemFontOfSize:12];
    }
    return _addressLab;
}

- (NSMutableArray *)allDateArr{
    if (!_allDateArr) {
        _allDateArr = [[NSMutableArray alloc]init];
    }
    return _allDateArr;
}

- (NSMutableArray *)friendYueArr{
    
    if (!_friendYueArr) {
        _friendYueArr = [[NSMutableArray alloc]init];
    }
    return _friendYueArr;
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
