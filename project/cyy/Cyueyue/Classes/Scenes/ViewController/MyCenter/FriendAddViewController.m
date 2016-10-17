//
//  FriendAddViewController.m
//  Cyueyue
//
//  Created by fami_Lbb on 16/8/24.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import "FriendAddViewController.h"

@interface FriendAddViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableViwe;
@property (nonatomic,strong)NSMutableArray *array;
@property (nonatomic,strong)UISearchBar *search;
@end

@implementation FriendAddViewController

static NSString *const cellID = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height- 64)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view = view;
    self.title = @"添加好友";
    
    self.array = [@[@"sds",@"dcdc",@"dcdc"]copy];
    [self.view addSubview:self.tableViwe];
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

//点击tableview回收键盘
- (void)hideKeyBound{
    
    [self.tableViwe endEditing:YES];
}

#pragma mark ---tableViewDelegate---
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
 
    if (self.array.count == 0) {
        
        return 1;
        
    }else
        
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 1;
    }
    return self.array.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        return @"搜索结果";
    }else
    
        return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        
        return 40;
        
    }else
    
        return 14;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"点击点击");
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.section == 0) {
        
        self.search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
        self.search.center = CGPointMake(kScreen_Width / 2, 24);
        self.search.placeholder = @"手机号";
        //设置背景图是为了去掉上下黑线
        self.search.backgroundImage = [[UIImage alloc]init];
        [cell.contentView addSubview:self.search];
        
    }else{
    
        cell.textLabel.text = self.array[indexPath.row];
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width - 33, 10, 20, 20)];
    imgV.image = [UIImage imageNamed:@"加好友"];
        [cell.contentView addSubview:imgV];
    
    }

    return cell;
}




- (UITableView *)tableViwe{
    if (!_tableViwe) {
        
        _tableViwe = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBound)];
        tap.cancelsTouchesInView = NO;//设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
        [_tableViwe addGestureRecognizer:tap];
        
        _tableViwe.delegate = self;
        _tableViwe.dataSource = self;
        _tableViwe.userInteractionEnabled = YES;
        [_tableViwe registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    }
    return _tableViwe;
}

- (NSMutableArray *)array{
    if (!_array) {
        _array = [NSMutableArray arrayWithCapacity:20];
    }
    return _array;
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
