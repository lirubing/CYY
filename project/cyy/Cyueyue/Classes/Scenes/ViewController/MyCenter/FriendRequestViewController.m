//
//  FriendRequestViewController.m
//  Cyueyue
//
//  Created by fami_Lbb on 16/8/24.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import "FriendRequestViewController.h"

@interface FriendRequestViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *array;
@end

@implementation FriendRequestViewController
static NSString *const cellID = @"cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height- 64)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view = view;
    self.title = @"新的好友";
    
    self.array = [@[@"王五",@"李四",@"张三"] copy];
    
    [self.view addSubview:self.tableView];

    [self addNavgationButton];
}

#pragma mark --导航栏左按钮--
- (void)addNavgationButton{
    
    ILBarButtonItem *barButtonLeft = [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"返回白"] selectedImage:[UIImage imageNamed:@"返回白"] target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = barButtonLeft;
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---UITableViewDelegate---
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.textLabel.text = self.array[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width - 53, 9.5, 40, 25)];
    label.text = @"接受";
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = UITextAlignmentCenter;
    
    label.textColor = [UIColor whiteColor];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 5;
    label.backgroundColor = cTopicBlue;
    [cell.contentView addSubview:label];
    
    return cell;
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
        
    }
    return _tableView;
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
