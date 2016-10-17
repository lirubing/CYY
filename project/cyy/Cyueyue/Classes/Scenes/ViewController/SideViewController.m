//
//  SideViewController.m
//  Cyueyue
//
//  Created by fami_Lbb on 16/7/25.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import "SideViewController.h"


@interface SideViewController ()
@property (nonatomic,strong)NSArray *arrContent;
@property (nonatomic,strong)YRSideViewController *YRSide;
@end

@implementation SideViewController
static NSString *const tabCell = @"tabCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = cCustom(47, 49, 53, 1);
    
    self.arrContent = @[@"我的日程",@"我的好友",@"我的资料",@"设置",@"退出登录"];
    
    [self darwView];
}

- (void)darwView{
    
    for (int i = 0; i < self.arrContent.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 80, 25);
        button.center = CGPointMake(88, 91 + 73 * i);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setTitle:self.arrContent[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        [button addTarget:self action:@selector(selectorAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 18)];
        imgView.center = CGPointMake(25, 91 + 73 * i);
        imgView.image = [UIImage imageNamed:self.arrContent[i]];
        imgView.contentMode = UIViewContentModeScaleAspectFit;

        [self.view addSubview:imgView];
    }
    
    
}

- (void)selectorAction:(UIButton *)button{
    
    self.YRSide =  [[LBHelpers shareLBHeloper] getRootViewController];
    [self.YRSide hideSideViewController:YES];
    
    UINavigationController *homeVC = (UINavigationController *)self.YRSide.rootViewController;
    
    if ([button.titleLabel.text isEqualToString:@"我的日程"]) {
        
        
        
    }else if ([button.titleLabel.text isEqualToString:@"我的好友"]){
        
        FriendViewController *frideVC = [[FriendViewController alloc]init];
        [homeVC pushViewController:frideVC animated:YES];
        
    }else if ([button.titleLabel.text isEqualToString:@"我的资料"]){
        MyProfile *myPro = [[MyProfile alloc]init];
        [homeVC pushViewController:myPro animated:YES];
        
    }else if ([button.titleLabel.text isEqualToString:@"设置"]){
        PreferencesViewController *preferent = [[PreferencesViewController alloc]init];
        [homeVC pushViewController:preferent animated:YES];
        
    }else if ([button.titleLabel.text isEqualToString:@"退出登录"]){
        
        [self outback];
    }
    
}

//退出登录
- (void)outback{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:nil forKey:@"userName"];
    [user setObject:nil forKey:@"passWord"];
    [user setBool:NO forKey:@"isOrno"];
    [user synchronize];
    
    LoginViewController *login = [[LoginViewController alloc]init];
    login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.YRSide presentViewController:login animated:YES completion:nil];
}

- (void)dealloc{
    
    
    
}

- (NSArray *)arrContent{
    if (!_arrContent) {
        _arrContent = [NSArray array];
    }
    return _arrContent;
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
