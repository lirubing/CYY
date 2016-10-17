//
//  YueFirendViewController.m
//  Cyueyue
//
//  Created by fami_Lbb on 16/10/9.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import "YueFirendViewController.h"

@interface YueFirendViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic,strong)UIView *addView;
@property (nonatomic,strong)UITapGestureRecognizer *tap;

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *Listarr;
@end

@implementation YueFirendViewController

static NSString *const cellTable = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    self.view.backgroundColor = cCustom(0, 0, 0, 0.3);
    
    self.addView = [[UIView alloc]init];
    self.addView.frame = CGRectMake(41, (kScreen_Height - 300 - 64)/2, kScreen_Width - 82, 300);
    self.addView.backgroundColor = [UIColor yellowColor];
    
    //添加退出填写框的手势
    self.tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    self.tap.delegate = self;
    [self.view addGestureRecognizer:self.tap];
    
    [self.addView addSubview:self.tableView];
    [self.view addSubview:self.addView];

}

- (void)setModel:(PersonToContactModel *)model{
    
    self.Listarr = model.yueFriendArr;
    [self.tableView reloadData];
}

- (void)dealloc{
    
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    self.tap.delegate = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)tapAction{
    
    self.view.alpha = 0;
    
}

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


#pragma mark ----UITableView----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"约我的好友";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.Listarr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 74;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选定状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FirendActionNotfication" object:nil];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YueFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellTable forIndexPath:indexPath];

    YueFirendModel *model = self.Listarr[indexPath.row];
    cell.model = model;
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)Listarr{
    if (!_Listarr) {
        _Listarr = [[NSMutableArray alloc]init];
    }
    return _Listarr;
}
- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.addView.frame.size.width, self.addView.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"YueFriendTableViewCell" bundle:nil] forCellReuseIdentifier:cellTable];
        
    }
    
    return _tableView;
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
