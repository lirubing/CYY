//
//  LocationViewController.m
//  Cyueyue
//
//  Created by fami_Lbb on 16/9/12.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import "LocationViewController.h"
#import "TableViewCellAddress.h"

#warning 待优化部分，1.将定位写入单例，定位出直接显示现在定位

@interface LocationViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate,CLLocationManagerDelegate>

@property (nonatomic,strong)UISearchBar *searchBar;
@property (nonatomic,strong)BMKPoiSearch *poisearcher;
@property (nonatomic,strong)NSMutableArray *arraySearch;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *historyArray;
@property (nonatomic,assign)BOOL searchOrhis;
//百度地图定位
@property (nonatomic,strong)BMKLocationService *locService;
@property (nonatomic,strong)BMKGeoCodeSearch *geocodesearch;
@property (nonatomic,strong)UIAlertController *alertC;

//系统定位权限
@property (nonatomic,strong)CLLocationManager *manager;

@property (nonatomic,strong)NSString *addressStr;
@end

@implementation LocationViewController

static NSString *const cellID = @"cell";

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    //设置cell线的问题
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.view = view;
    
    ///百度定位
    //开启定位
    self.locService = [[BMKLocationService alloc]init];//定位功能的初始化
    self.locService.delegate = self;//设置代理位self
    //启动LocationService
    [self.locService startUserLocationService];//启动定位服务
    self.geocodesearch = [[BMKGeoCodeSearch alloc] init];
    //编码服务的初始化(就是获取经纬度,或者获取地理位置服务)
    self.geocodesearch.delegate = self;//设置代理为self
    //开始编码
//    [self onClickReverseGeocode];

    
    //显示历史记录
    self.searchOrhis = YES;
    //请求历史记录
    [self requestHistory];
    
    [self drawSearchView];
    [self.view addSubview:self.tableView];
    
    
    //代理方法检测定位允许状态
    self.manager = [[CLLocationManager alloc] init];
    
    //使用的时候获取定位信息
    [self.manager requestWhenInUseAuthorization];
    
    self.manager.delegate = self;
    CLAuthorizationStatus CLstatus = [CLLocationManager authorizationStatus];
    [self locationManager:self.manager didChangeAuthorizationStatus:CLstatus];

    
    
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    _poisearcher.delegate = nil; // 不用时，置nil
    _manager.delegate = nil;
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    _locService.delegate = nil;
    _geocodesearch.delegate = nil;
    _searchBar.delegate = nil;
    
    self.navigationController.navigationBar.hidden = NO;

}

#pragma mark -----定位当前位置------
//发送反编码请求的.
-(void)onClickReverseGeocode{
    
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};//初始化
    if (_locService.userLocation.location.coordinate.longitude!= 0
        && _locService.userLocation.location.coordinate.latitude!= 0) {
        //如果还没有给pt赋值,那就将当前的经纬度赋值给pt
        pt = (CLLocationCoordinate2D){_locService.userLocation.location.coordinate.latitude,
            _locService.userLocation.location.coordinate.longitude};
    }
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];//初始化反编码请求
    reverseGeocodeSearchOption.reverseGeoPoint = pt;//设置反编码的店为pt
    BOOL flag = [self.geocodesearch reverseGeoCode:reverseGeocodeSearchOption];//发送反编码请求.并返回是否成功
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
    
}

//编码成功后返回的数据
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        
        NSString* titleStr;
        NSString* showmeg;
        titleStr = @"反向地理编码";
        showmeg = [NSString stringWithFormat:@"%@",item.title];
        
        self.addressStr = showmeg;
        if (self.addressStr.length > 0) {
            [self searchBarCancelButtonClicked:self.searchBar];
        }

//        [self.tableView reloadData];
        NSLog(@"当前定位是：%@",showmeg);
        
    }else{
        [[TKAlertCenter defaultCenter]postAlertWithMessage:@"定位失败"];
    }
}

//请求历史搜索数据
- (void)requestHistory{
    
    NSArray* hisArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"historyList"];
    //倒序输出
    NSArray *reverseArray = [[hisArr reverseObjectEnumerator] allObjects];
    [self.historyArray addObjectsFromArray:reverseArray];
    
}


#pragma mark ---去设置里开启权限---
- (void)setAlertWithTitle:(NSString *)title message:(NSString *)message actionWithDeleteTitle:(NSString *)deleteAction actionWithDeleteTitle:(NSString *)finishAction{
    
    self.alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [self.alertC addAction:[UIAlertAction actionWithTitle:deleteAction style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        [self.alertC dismissViewControllerAnimated:YES completion:nil];
        
        
    }]];
    
    [self.alertC addAction:[UIAlertAction actionWithTitle:finishAction style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        //跳转到设置
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            
            [[UIApplication sharedApplication] openURL:url];
            
        }
        
    }]];
    
    [self presentViewController:self.alertC animated:YES completion:nil];
    
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"Always Authorized");
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"AuthorizedWhenInUse");
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"Denied");
             [self setAlertWithTitle:@"提示" message:@"请在iPhone的“设置-隐私-定位服务”选项中，允许我们访问你的定位。" actionWithDeleteTitle:@"取消" actionWithDeleteTitle:@"去设置"];
            break;
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"not Determined");
            
             [self setAlertWithTitle:@"提示" message:@"请在iPhone的“设置-隐私-定位服务”选项中，允许我们访问你的定位。" actionWithDeleteTitle:@"取消" actionWithDeleteTitle:@"去设置"];
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"Restricted");
             [self setAlertWithTitle:@"提示" message:@"请在iPhone的“设置-隐私-定位服务”选项中，允许我们访问你的定位。" actionWithDeleteTitle:@"取消" actionWithDeleteTitle:@"去设置"];
            
            break;
        default:
            break;
    }
    
}

#pragma mark -----UISearchBar------

- (void)drawSearchView{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 64)];
    view.backgroundColor = cTopicBlue;
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 20, kScreen_Width, 44)];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"搜索位置";
    self.searchBar.backgroundImage = [[UIImage alloc] init];
    self.searchBar.barTintColor = [UIColor whiteColor];
    self.searchBar.showsCancelButton = YES;
    self.searchBar.tintColor = [UIColor whiteColor];
    
    [self.searchBar becomeFirstResponder];
    //设置圆角和边框颜色
    UITextField *searchField = [self.searchBar valueForKey:@"searchField"];
    if (searchField) {
        [searchField setBackgroundColor:[UIColor whiteColor]];
        searchField.tintColor = cTopicBlue;
        searchField.layer.cornerRadius = 14.0f;
        searchField.layer.borderColor = [UIColor colorWithRed:108/255.0 green:147/255.0 blue:226/255.0 alpha:1].CGColor;
        searchField.layer.borderWidth = 1;
        searchField.layer.masksToBounds = YES;
    }
    
    //设置按钮文字
    [self fm_setCancelButtonTitle:@"取消"];
    
    [view addSubview:self.searchBar];
    [self.view addSubview:view];
}

- (void)fm_setCancelButtonTitle:(NSString *)title {
    if (iOS9) {
        [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitle:title];
    }else {
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:title];
    }
}
//点击取消
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [self.searchBar resignFirstResponder];
    //传参
    self.block(self.addressStr);
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
//当输入框文字变化的方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [self.arraySearch removeAllObjects];
    
    if (searchText.length == 0) {
        self.searchOrhis = YES;
        [self.tableView reloadData];
        
    }else{
        
        self.searchOrhis = NO;
    }
    
    _poisearcher = [[BMKPoiSearch alloc] init];
    _poisearcher.delegate = self;
    
    BMKCitySearchOption *citySearch = [[BMKCitySearchOption alloc] init];
    citySearch.pageCapacity = 20;
    
    //将当前定位所在城市作为初始
    if (self.addressStr.length > 0) {
        citySearch.city = [self.addressStr substringFromIndex:5] ;
    }else{
        citySearch.city = @"北京";
    }
    citySearch.keyword = searchText;
    
    BOOL flag = [_poisearcher poiSearchInCity:citySearch];
    
    if (flag) {
        NSLog(@"城市内检索发送成功");
    } else {
        
        [self.tableView reloadData];
        NSLog(@"城市内检索发送失败");
    }
    

}

//成功检索后返回结果的方法
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode {
    
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        
        if (poiResult.poiInfoList.count > 0) {
            for (int i = 0; i < poiResult.poiInfoList.count; i++) {
                BMKPoiInfo *poiInfo = [poiResult.poiInfoList objectAtIndex:i];
                NSLog(@"name  %@", poiInfo.name) ;
                NSLog(@"add  %@", poiInfo.address) ;
                
                PersonToContactModel *model = [PersonToContactModel new];
                model.mapName = poiInfo.name;
                model.mapAddress = poiInfo.address;
                
                [self.arraySearch addObject:model];
            }
            
        }
        
        [self.tableView reloadData];
        
    } else {
    
        [self.tableView reloadData];
        
    }
}

#pragma mark -----UITableViewDelegate-----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.searchOrhis) {
        return self.historyArray.count + 1;
    }else
        
    return self.arraySearch.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (self.searchOrhis) {
        return 30;
    }else
        
    return 0.1f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.searchOrhis) {
        
        return @"  历史搜索";
    }
    
    return @" ";
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.searchOrhis) {
        
        if (indexPath.row == 0) {
            
            //定位
            [self onClickReverseGeocode];
            
        }else{
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            dic = self.historyArray[indexPath.row - 1];
            NSString *key = dic.allKeys[0];
            [self setDateWithModelForUserDefaults:[dic objectForKey:key] andAddress:key];
            
            self.addressStr = [dic objectForKey:key];
            
            //传参
            [self searchBarCancelButtonClicked:self.searchBar];

        }
        
    }else{
        
        PersonToContactModel *model = [PersonToContactModel new];
        model = self.arraySearch[indexPath.row];
        [self setDateWithModelForUserDefaults:model.mapName andAddress:model.mapAddress];
        self.addressStr = model.mapName;
        //传参
        [self searchBarCancelButtonClicked:self.searchBar];
    }
    
}

//将最近点击数据存入本地
- (void)setDateWithModelForUserDefaults:(NSString *)mapName andAddress:(NSString *)mapAddress{
    
    NSArray *arrH = [[NSArray alloc]init];
    arrH = [[NSUserDefaults standardUserDefaults] objectForKey:@"historyList"];
    
    NSMutableArray *mutArr = [[NSMutableArray alloc]initWithArray:arrH];
    
    if (mutArr.count > 0) {
        
            for (int i = 0; i < mutArr.count; i++) {
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                dic = mutArr[i];
                NSArray *keys = dic.allKeys;
                
                for (int i = 0; i < keys.count; i++) {
                    
                    if ([mapAddress isEqualToString:keys[i]]) {
                        [mutArr removeObject:dic];
                    }
                }
                
            }
    }
    
    //地址是唯一的，名字是不唯一的
    NSMutableDictionary *dicN = [[NSMutableDictionary alloc]init];
    [dicN setObject:mapName forKey:mapAddress];
    
    [mutArr addObject:dicN];
    
    //将账号密码存储到本地
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:[mutArr mutableCopy] forKey:@"historyList"];
    [user synchronize];
    
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"historyList"];

    NSLog(@"%@",arr);
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TableViewCellAddress *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    

    if (self.searchOrhis) {
        
        if (indexPath.row == 0) {
            
            cell.mapName.text = @"当前定位";
            cell.mapAddress.text = @"点击进行定位";
            cell.imgView.image = [UIImage imageNamed:@"定位"];
    
        }else{

            NSMutableDictionary *dicH = [[NSMutableDictionary alloc]init];
            //注意数组越界
            dicH = self.historyArray[indexPath.row - 1];
            cell.mapAddress.text = dicH.allKeys[0];
            cell.mapName.text = [dicH objectForKey:dicH.allKeys[0]];
            cell.imgView.image = [UIImage imageNamed:@"定位"];
        }
        
    }else{
        
    cell.model = self.arraySearch[indexPath.row];
    
    }
    return cell;
}

//滑动的时候回收键盘
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}


#pragma mark ---lazyLoad---
- (NSMutableArray *)arraySearch{
    if (!_arraySearch) {
        _arraySearch = [[NSMutableArray alloc]initWithCapacity:10];
    }
    return _arraySearch;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height - 64) style:UITableViewStyleGrouped];
        [_tableView registerNib:[UINib nibWithNibName:@"TableViewCellAddress" bundle:nil] forCellReuseIdentifier:cellID];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)historyArray{
    if (!_historyArray) {
        _historyArray = [[NSMutableArray alloc]initWithCapacity:10];
    }
    return _historyArray;
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
