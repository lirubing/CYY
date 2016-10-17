//
//  LocationViewController.m
//  Cyueyue
//
//  Created by fami_Lbb on 16/9/12.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import "LocationViewController.h"

@interface LocationViewController ()<BMKPoiSearchDelegate,UISearchBarDelegate>
@property (nonatomic,strong)UISearchBar *searchBar;
@property (nonatomic,strong)BMKPoiSearch *poisearcher;

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.view = view;
    
    [self drawSearchView];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    _poisearcher.delegate = nil; // 不用时，置nil
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
    [self dismissViewControllerAnimated:YES completion:nil];
}
//当输入框文字变化的方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    _poisearcher = [[BMKPoiSearch alloc] init];
    _poisearcher.delegate = self;
    
    BMKCitySearchOption *citySearch = [[BMKCitySearchOption alloc] init];
    citySearch.pageCapacity = 20;
    citySearch.city = @"北京";
    citySearch.keyword = searchText;
    
    BOOL flag = [_poisearcher poiSearchInCity:citySearch];
    
    if (flag) {
        NSLog(@"城市内检索发送成功");
    } else {
        NSLog(@"城市内检索发送失败");
    }
    

}

//成功检索后返回结果的方法
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode {
    
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        
        if (poiResult.poiInfoList.count > 0) {
            NSLog(@"%@",poiResult.poiInfoList);
            
            for (int i = 0; i < poiResult.poiInfoList.count; i++) {
                BMKPoiInfo *poiInfo = [poiResult.poiInfoList objectAtIndex:i];
                NSLog(@"%@", poiInfo.name) ;
                
            }
        }
        
    } else {
        
    }
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
