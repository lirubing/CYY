//
//  SuspensionView.m
//  Cyueyue
//
//  Created by fami_Lbb on 16/9/8.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import "SuspensionView.h"
#define tableViewWidth 85
#define tableViewHeight (kScreen_Height - 300 - 64)/2
#warning 待实现部分，1.将完成时的数据存入后台 可优化部分1.选择时间后自动滑动到当前所选位置 3.判断完成时是填写还是编辑还是约好友




@interface SuspensionView()<UITextFieldDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIView *addView;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIButton *timeBegin;
@property (nonatomic,strong)UIButton *timeEnd;
@property (nonatomic,strong)UIButton *finish;
@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UITextField *content;
@property (nonatomic,strong)UIImageView *imgVBegin;
@property (nonatomic,strong)UIImageView *imgVEnd;
@property (nonatomic,strong)UIImageView *imgViewSel;
@property (nonatomic,assign)BOOL beginOrEnd;
@property (nonatomic,assign)NSInteger beginIndex;
@property (nonatomic,assign)NSInteger endIndex;
@property (nonatomic,strong)UIButton *deteleBut;
@property (nonatomic,strong)UITapGestureRecognizer *tap;

@property (nonatomic,strong)NSMutableArray *arrayTime;
//开始时间在数组中的下标
@property (nonatomic,assign)NSInteger seleNum;
//选中时间的时间
@property (nonatomic,strong)NSString *seleStr;

@property (nonatomic,strong)NSDate  *dateCurret;


@end
@implementation SuspensionView

static NSString *const cellID = @"cellID";
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.addView.frame = CGRectMake(41, (kScreen_Height - 300 - 64)/2, kScreen_Width - 82, 300);
        self.addView.backgroundColor = [UIColor whiteColor];
        
        self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
        self.view.backgroundColor = cCustom(0, 0, 0, 0.3);
        //添加退出填写框的手势
        self.tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        self.tap.delegate = self;
        [self.view addGestureRecognizer:self.tap];
        
        [self setupSubView];

    }
    return self;
}

//赋值
- (void)setModel:(PersonToContactModel *)model{

    _model = model;
    
    if (self.editOn) {
        self.deteleBut.alpha = 1;
    }else{
        self.deteleBut.alpha = 0;
    }
    
    //获取当前开始时机的下标
    for (int i = 0; i < self.arrayTime.count; i++) {
        if ([_model.beginTime isEqualToString:self.arrayTime[i]]) {
            self.seleNum = i;
            //记录时间起始和结束下标，方便判断是否是有效区间
            self.beginIndex = i;
            self.endIndex = i + 1;
        }
    }
    
    //将时间转换成字符串，显示
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *destDateString = [dateFormatter stringFromDate:self.model.dateLabel];
    
    //日期
    self.label.text = destDateString;
    
    //开始时间
    [self.timeBegin setTitle:self.model.beginTime forState:UIControlStateNormal];
    
    if (model.endTime.length == 0) {
        
        //默认结束时间是开始时间的半小时以后
        [self.timeEnd setTitle:self.arrayTime[self.seleNum + 1] forState:UIControlStateNormal];
    }else{
        
        [self.timeEnd setTitle:model.endTime forState:UIControlStateNormal];
        
    }
    
    self.content.text = model.content;
    self.location.text = model.addressStr;
    
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tableView.alpha = 0;
}


- (void)setupSubView{
    
    UIView* addView = [[UIView alloc]initWithFrame:CGRectMake(41, (kScreen_Height - 300 - 64)/2, kScreen_Width - 82, 300)];
    self.addView = addView;
    self.addView.backgroundColor = [UIColor whiteColor];
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, self.addView.frame.size.width - 40, 20)];
    self.label.text = @"";
    self.label.font = [UIFont systemFontOfSize:14];
    
    self.content = [[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.label.frame) + 30, self.label.frame.size.width, 37)];
    self.content.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 37)];
    self.content.leftViewMode = UITextFieldViewModeAlways;
    
    self.content.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.content.placeholder = @"输入内容";
    self.content.font = [UIFont systemFontOfSize:13];
    
    self.location = [[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.content.frame) + 20, self.label.frame.size.width, 37)];
    self.location.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //解决文字紧贴边缘的问题
    self.location.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 37)];
    self.location.leftViewMode = UITextFieldViewModeAlways;
    self.location.delegate = self;
    self.location.placeholder = @"位置";
    self.location.font = [UIFont systemFontOfSize:13];
    
    self.timeBegin = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.location.frame) + 30, 70, 30)];
    [self.timeBegin setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.timeBegin.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.timeBegin setTitle:@"" forState:UIControlStateNormal];
    self.timeBegin.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.timeBegin addTarget:self action:@selector(timeBeginAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.imgVBegin = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.timeBegin.frame),CGRectGetMaxY(self.location.frame) + 30, 15, 30)];
    self.imgVBegin.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.imgVBegin.image = [UIImage imageNamed:@"下箭头"];
    self.imgVBegin.contentMode = UIViewContentModeCenter;
    
    self.timeEnd = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.timeBegin.frame) + 40,  CGRectGetMaxY(self.location.frame) + 30, 70, 30)];
    [self.timeEnd setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.timeEnd.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.timeEnd setTitle:@"" forState:UIControlStateNormal];
    self.timeEnd.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.timeEnd addTarget:self action:@selector(timeEndAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.imgVEnd = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.timeEnd.frame), CGRectGetMaxY(self.location.frame) + 30, 15, 30)];
    self.imgVEnd.image = [UIImage imageNamed:@"下箭头"];
    self.imgVEnd.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.imgVEnd.contentMode = UIViewContentModeCenter;
    
    
     self.finish = [[UIButton alloc]initWithFrame:CGRectMake(20, self.addView.frame.size.height - 50, 75, 30)];
     self.finish.backgroundColor = cTopicBlue;
     self.finish.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.finish setTitle:@"保存" forState:UIControlStateNormal];
     self.finish.layer.masksToBounds = YES;
     self.finish.layer.cornerRadius = 2;
    [self.finish addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.deteleBut = [[UIButton alloc]initWithFrame:CGRectMake(self.addView.frame.size.width - 95 , self.addView.frame.size.height - 50, 75, 30)];
    self.deteleBut.alpha = 0;
    self.deteleBut.backgroundColor = [UIColor redColor];
    self.deteleBut.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.deteleBut setTitle:@"删除" forState:UIControlStateNormal];
    self.deteleBut.layer.masksToBounds = YES;
    self.deteleBut.layer.cornerRadius = 2;
    [self.deteleBut addTarget:self action:@selector(deteleAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.tableView.alpha = 0;

    [self.addView addSubview:self.label];
    [self.addView addSubview:self.content];
    [self.addView addSubview:self.location];
    [self.addView addSubview:self.timeBegin];
    [self.addView addSubview:self.imgVBegin];
    [self.addView addSubview:self.timeEnd];
    [self.addView addSubview:self.imgVEnd];
    [self.addView addSubview:self.finish];
    [self.addView addSubview:self.deteleBut];
    
    
    [self.view addSubview:self.addView];
    [self.view addSubview:self.tableView];
    
}

#pragma mark ----UITextFieldDelegate----
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"LocationNotification" object:nil];
}

//点击试图使填写框消失
- (void)tapAction{
    
    self.view.alpha = 0;
    self.deteleBut.alpha = 0;
    [self.view endEditing:YES];
}

//回收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.addView endEditing:YES];
    self.tableView.alpha = 0;
}

//判断收拾的执行者，防止子视图执行父试图的手势方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    // 输出点击的view的类名
//    NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    if ([touch.view isDescendantOfView:self.addView]) {
        return NO;
    }
    //防止和tableview的点击时间冲突
    if([NSStringFromClass([touch.view class] )isEqualToString:@"UITableViewCellContentView"]) {
        
        return NO;

    }
    
    return YES;
}

#pragma mark ----ButtonAction----
//选择起始时间
- (void)timeBeginAction:(id)sender{
    
    self.beginOrEnd = YES;
    self.seleStr = self.timeBegin.titleLabel.text;
    
    CGRect frame = self.tableView.frame;
    frame.origin.x = self.timeBegin.frame.origin.x + 41;
    self.tableView.frame = frame;
    
    for (int i =0; i < self.arrayTime.count; i++) {
        
        if ([self.seleStr isEqualToString:self.arrayTime[i]]) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }
    }
    
    
    [self.tableView reloadData];
    
    self.tableView.alpha = 1;
    
}

//选择结束时间
- (void)timeEndAction:(id)sender{
    self.beginOrEnd = NO;

    self.seleStr = self.timeEnd.titleLabel.text;

    CGRect frame = self.tableView.frame;
    frame.origin.x = self.timeEnd.frame.origin.x + 41;
    
    for (int i =0; i < self.arrayTime.count; i++) {
        
        if ([self.seleStr isEqualToString:self.arrayTime[i]]) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }
    }
    
    
    self.tableView.frame = frame;
    
    [self.tableView reloadData];

    self.tableView.alpha = 1;
    
}

//完成
- (void)finishAction{
   
    if (self.content.text.length == 0) {
        [[TKAlertCenter defaultCenter]postAlertWithMessage:@"请填写内容"];
        return;
    }
    
    if (self.beginIndex >= self.endIndex) {
        [[TKAlertCenter defaultCenter]postAlertWithMessage:@"请选择有效时间段"];
        return;
    }
    
    
    NSInteger addBeginHour = 0;
    NSInteger addBeginMin = 0;
    
    NSArray *addTimeArrB = [self.timeBegin.titleLabel.text componentsSeparatedByString:@":"];
    addBeginHour = [addTimeArrB[0] integerValue];
    addBeginMin = [addTimeArrB[1] integerValue];
    
    NSInteger addEndHour = 0;
    NSInteger addEndMin = 0;
    
    NSArray *addTimeArrE = [self.timeEnd.titleLabel.text componentsSeparatedByString:@":"];
    addEndHour = [addTimeArrE[0] integerValue];
    addEndMin = [addTimeArrE[1] integerValue];
    
    
    for (int i = 0; i < self.arrayDate.count; i++) {
        PersonToContactModel *model = self.arrayDate[i];
        
        NSInteger fromBeginHour = 0;
        NSInteger fromBeginMin = 0;
        
        NSArray *timeArrB = [model.beginTime componentsSeparatedByString:@":"];
        fromBeginHour = [timeArrB[0] integerValue];
        fromBeginMin = [timeArrB[1] integerValue];

        
        NSInteger fromEndHour = 0;
        NSInteger fromEndMin = 0;
        
        NSArray *timeArrE = [model.endTime componentsSeparatedByString:@":"];
        fromEndHour = [timeArrE[0] integerValue];
        fromEndMin = [timeArrE[1] integerValue];
        
        BOOL comper1 = [[LBHelpers shareLBHeloper] isBetweenAddFromHour:addBeginHour AddFromMinute:addBeginMin BeginFromHour:fromBeginHour BeginFromMinute:fromBeginMin EndFromHour:fromEndHour EndFromMinute:fromEndMin];
        
        BOOL comper2 = [[LBHelpers shareLBHeloper] isBetweenAddFromHour:addEndHour AddFromMinute:addEndMin BeginFromHour:fromBeginHour BeginFromMinute:fromBeginMin EndFromHour:fromEndHour EndFromMinute:fromEndMin];
        
        BOOL comper3 = [[LBHelpers shareLBHeloper] isBetweenAddFromHour:fromBeginHour AddFromMinute:fromBeginMin BeginFromHour:addBeginHour BeginFromMinute:addBeginMin EndFromHour:addEndHour EndFromMinute:addEndMin];
        
        BOOL comper4 = [[LBHelpers shareLBHeloper] isBetweenAddFromHour:fromEndHour AddFromMinute:fromEndMin BeginFromHour:addBeginHour BeginFromMinute:addBeginMin EndFromHour:addEndHour EndFromMinute:addEndMin];
        
//        NSLog(@"%ld--%ld,%ld===%ld,%ld--%ld",addBeginHour,addBeginMin,fromBeginHour,fromBeginMin,fromEndHour,fromEndMin);
        
        
        if (!comper1 | !comper2 | !comper3 | !comper4) {
            
            [[TKAlertCenter defaultCenter]postAlertWithMessage:@"请选择有效时间段"];
            return;
 
        }
    }
    
    
    
#warning 先存到前台，先显示
    self.view.alpha = 0;
    self.deteleBut.alpha = 0;

    [self.view endEditing:YES];
    
    NSString *editStr;
    
    if (self.editOn) {
        editStr = @"YES";
    }else{
        editStr = @"NO";
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotficationFinishAddAction" object:nil userInfo:@{@"content":self.content.text,@"address":self.location.text,@"beginTime":self.timeBegin.titleLabel.text,@"endTime":self.timeEnd.titleLabel.text,@"editOn":editStr}];
    
//    NSLog(@"%@=======%@",self.timeBegin.titleLabel.text,self.timeEnd.titleLabel.text);
    
    
    
}

//删除事件
- (void)deteleAction{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotficationDelete" object:nil userInfo:nil];
    self.view.alpha = 0;
    self.deteleBut.alpha = 0;

}




#pragma mark ----UITableViewDelegate----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayTime.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *time = self.arrayTime[indexPath.row];
    
    if (self.beginOrEnd) {
        [self.timeBegin setTitle:time forState:UIControlStateNormal];
        self.beginIndex = indexPath.row;
    }else{
        [self.timeEnd setTitle:time forState:UIControlStateNormal];
        self.endIndex = indexPath.row;
    }
    
//    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
   
    self.tableView.alpha = 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //隐藏tableview的线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
        self.imgViewSel = [[UIImageView alloc]initWithFrame:CGRectMake(55 , 5, 20, 20)];
        self.imgViewSel.image = [UIImage imageNamed:@"选中"];
        cell.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        [cell.contentView addSubview:self.imgViewSel];
    }
    
    
    
    cell.textLabel.text = self.arrayTime[indexPath.row];
    
    if ([cell.textLabel.text isEqualToString:self.seleStr]) {
        self.imgViewSel.alpha = 1;
    }else{
        self.imgViewSel.alpha = 0;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    
    return cell;
}


- (void)dealloc{
    
    self.location.delegate = nil;
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    self.tap.delegate = nil;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];

}

- (NSMutableArray *)arrayTime{
    if (!_arrayTime) {
        _arrayTime = [[NSMutableArray alloc]initWithCapacity:20];
        _arrayTime = [@[@"7:00",@"7:30",@"8:00",@"8:30",@"9:00",@"9:30",@"10:00",@"10:30",@"11:00",@"11:30",@"12:00",@"12:30",@"13:00",@"13:30",@"14:00",@"14:30",@"15:00",@"15:30",@"16:00",@"16:30",@"17:00",@"17:30",@"18:00",@"18:30",@"19:00",@"19:30",@"20:00",@"20:30",@"21:00",@"21:30",@"22:00",@"22:30",@"23:00",@"23:30",@"24:00"]copy];
    }
    return _arrayTime;
}

- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(self.timeBegin.frame.origin.x + 41, CGRectGetMaxY(self.timeBegin.frame) + 2 + tableViewHeight, tableViewWidth, tableViewHeight) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    }
    
    return _tableView;
}


@end
