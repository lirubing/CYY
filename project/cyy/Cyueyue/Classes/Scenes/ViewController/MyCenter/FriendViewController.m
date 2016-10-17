//
//  FriendViewController.m
//  Cyueyue
//
//  Created by fami_Lbb on 16/8/22.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import "FriendViewController.h"

@interface FriendViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *mutArray;
@property (nonatomic,strong)UIButton *btnAccessoryView;
@property (nonatomic,strong)UISearchBar *search;
@property (nonatomic,assign)BOOL accessBool;
@property (nonnull,strong)UIView *searView;
@property (nonatomic,strong)NSMutableArray *dateArray;
@property (nonatomic,strong)NSMutableArray *titleArray;
@end

@implementation FriendViewController
static NSString *const Tcell = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.titleArray = nil;
    self.dateArray = nil;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view = view;
    
    self.navigationItem.title = @"好友列表";
    //授权的情况下获取通讯录资料
    [[LBHelpers shareLBHeloper] getPersonToContact];
    
//    [self.dateArray setArray:[LBHelpers shareLBHeloper].addressContent];
//    [self.titleArray setArray:[LBHelpers shareLBHeloper].addressList];
    
    self.dateArray = [[LBHelpers shareLBHeloper].addressContent copy];
    self.titleArray = [[LBHelpers shareLBHeloper].addressList copy];
    
    [self setHeader];
    [self addNavgationButton];
    [self.view addSubview:self.tableview];
    [self addNewFried];
    
    
    
}

#pragma mark --导航栏左按钮--
- (void)addNavgationButton{
    
    ILBarButtonItem *barButtonLeft = [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"返回白"] selectedImage:[UIImage imageNamed:@"返回白"] target:self action:@selector(backAction)];
    ILBarButtonItem *barButtonRight = [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"添加"] selectedImage:[UIImage imageNamed:@"添加"] target:self action:@selector(addAction)];
    
    self.navigationItem.leftBarButtonItem = barButtonLeft;
    self.navigationItem.rightBarButtonItem = barButtonRight;
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addAction{
    
    FriendAddViewController * addConV = [[FriendAddViewController alloc]init];
    [self.navigationController pushViewController:addConV animated:YES];
}

#pragma mark ---绘制UI---

- (void)addNewFried{
    
    UIView *heardView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 50)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [heardView addGestureRecognizer:tap];
    
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(12, 15, 20, 20)];
    imgV.image = [UIImage imageNamed:@"加好友"];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 15, 100, 20)];
    label.text = @"新的朋友";
    label.font = [UIFont systemFontOfSize:15];
    [heardView addSubview:imgV];
    [heardView addSubview:label];
    self.tableview.tableHeaderView = heardView;
    
}

- (void)setHeader{
    
    self.search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kSearchHeight)];
    self.search.placeholder = @"搜索";
    self.search.backgroundImage = [[UIImage alloc]init];
    
    self.search.delegate = self;
    [self.view addSubview:self.search];
   
}


- (void)btnAction{
    
    NSLog(@"handleTaps");
    self.accessBool = NO;
    [self controlAccessoryView:0];
    
}

- (void)tapAction{
    
    FriendRequestViewController *requestVC = [[FriendRequestViewController alloc]init];
    [self.navigationController pushViewController:requestVC animated:YES];
}


//搜索的动画
- (void)controlAccessoryView:(CGFloat)alphaVolue{
    
    [self.btnAccessoryView setAlpha:alphaVolue];
    
    [UIView animateWithDuration:0.2 animations:^{
        if (self.accessBool) {
            CGRect fram = self.view.frame;
            fram.origin.y = 20;
            self.view.frame = fram;
        }else{
            
            CGRect fram = self.view.frame;
            fram.origin.y = 64;
            self.view.frame = fram;
        }
        
    }completion:^(BOOL finished) {
        if (alphaVolue <= 0) {
            [self.search resignFirstResponder];
            [self.search setShowsCancelButton:NO animated:YES];
            self.navigationController.navigationBar.hidden = NO;
            UIColor * color= cTopicBlue;
            [self.navigationController.navigationBar setBarTintColor:color];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];


        }
    }];
    
}

#pragma mark ----UISearchBarDelegate----
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    self.accessBool = YES;
    [self.search setShowsCancelButton:YES animated:YES];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBar.hidden = YES;
    
    [self controlAccessoryView:0.2];
    for (id obj in [searchBar subviews]){
        if ([obj isKindOfClass:[UIView class]]) {
            for (id obj2  in [obj subviews]) {
                if ([obj2 isKindOfClass:[UIButton class]]) {
                    UIButton *btn = (UIButton *)obj2;
                    [btn setTitle:@"取消" forState:UIControlStateNormal];
                }
            }
        }
    }
    
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.accessBool = NO;
    [self controlAccessoryView:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----UITableViewDelegate----


//指定是否能编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

//设定编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"可见";
}

//完成编辑
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"可见可见");
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.titleArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return self.titleArray[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dateArray[section] count];
    
}

//右侧索引栏
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.titleArray;
}



- (double)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 28;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *array = self.dateArray[indexPath.section];
    PersonToContactModel *model = [[PersonToContactModel alloc]init];
    model = array[indexPath.row];
    
    FriendHomeVC *fHome = [[FriendHomeVC alloc]init];
    fHome.strName = model.name;
    fHome.strPhone = model.phones;
    [self.navigationController pushViewController:fHome animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *tableviewCell = [tableView dequeueReusableCellWithIdentifier:Tcell forIndexPath:indexPath];
    tableviewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *array = self.dateArray[indexPath.section];
    PersonToContactModel *model = [[PersonToContactModel alloc]init];
    model = array[indexPath.row];
    tableviewCell.textLabel.text = model.name;
    
    return tableviewCell;
}


#pragma mark -----lazyLoad----

- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.search.frame), kScreen_Width, kScreen_Height - (self.search.frame.origin.y + self.search.frame.size.height) - 64) style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:Tcell];
    }
    return _tableview;
}

- (NSMutableArray *)mutArray{
    if (!_mutArray) {
        _mutArray = [[NSMutableArray alloc]initWithCapacity:10];
    }
    return _mutArray;
}

- (NSMutableArray *)dateArray{
    if (!_dateArray) {
        _dateArray = [NSMutableArray arrayWithCapacity:50];
    }
    return _dateArray;
}

- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithCapacity:27];
    }
    return _titleArray;
}

- (UIButton *)btnAccessoryView{
    
    if (!_btnAccessoryView) {
        _btnAccessoryView= [UIButton buttonWithType:UIButtonTypeSystem];
        _btnAccessoryView.frame = CGRectMake(0, CGRectGetMaxY(self.search.frame), kScreen_Width, kScreen_Height);
        [_btnAccessoryView setBackgroundColor:[UIColor blackColor]];
        _btnAccessoryView.alpha = 0.0f;
        [_btnAccessoryView addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_btnAccessoryView];
    }
    return _btnAccessoryView;
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
