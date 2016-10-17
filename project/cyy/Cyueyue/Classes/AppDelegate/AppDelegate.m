//
//  AppDelegate.m
//  Cyueyue
//
//  Created by fami_Lbb on 16/7/25.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import "AppDelegate.h"
#import "LBRootViewController.h"
#import "LoginViewController.h"

@interface AppDelegate ()
//side
@property (nonatomic,strong)SideViewController *mySide;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //添加侧栏
    [self setSideForRoot];
    self.window.rootViewController = self.sideVC;
    LoginViewController *loginV = [[LoginViewController alloc]init];
    self.window.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self getAddressPer];
    
    [self.window makeKeyAndVisible];
    
    //判断登录状态
    BOOL isOrno = [[NSUserDefaults standardUserDefaults] objectForKey:@"isOrno"];
    if (isOrno) {
        NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
        NSLog(@"已登录 用户：%@",user);
    }else{
        [self.sideVC presentViewController:loginV animated:NO completion:nil];
    }
    
    //百度地图授权
    _mapManager = [[BMKMapManager alloc]init];
    
    // 如果要关注网络及授权验证事件，请设定generalDelegate参数
    BOOL ret = [_mapManager start:baiduMapAK  generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    
    return YES;
}

//绘制侧栏
- (void)setSideForRoot{
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[[LBRootViewController alloc]init]];
    UIColor * colo= cTopicBlue;
    [nav.navigationBar setBarTintColor:colo];
    nav.navigationBar.translucent = NO;
    //导航标题颜色白色
    nav.navigationBar.barStyle = UIBarStyleBlack;
    //设置UIStatusBar中字体的颜色为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.mySide = [[SideViewController alloc]init];
    self.sideVC = [[YRSideViewController alloc]init];
    self.sideVC.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.sideVC.leftViewController = self.mySide;
    self.sideVC.rootViewController = nav;
    
    self.sideVC.leftViewShowWidth= kScreen_Width - 120;
    self.sideVC.needSwipeShowMenu = NO;//默认开启的可滑动展示
    
    [self.sideVC setRootViewMoveBlock:^(UIView *rootView, CGRect orginFrame, CGFloat xoffset) {
        //使用简单的平移动画
        rootView.frame=CGRectMake(xoffset, orginFrame.origin.y, orginFrame.size.width, orginFrame.size.height);
        
    }];
   
}

//获取通讯录授权
- (void)getAddressPer{
    //ios8以上
    //1. 获取授权状态
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    //2. 创建 AddrssBook
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    //3. 没有授权时就授权
    if (status == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            //3.1 判断是否出错
            if (error) {
                return;
            }
            //3.2 判断是否授权
            if (granted) {
                NSLog(@"已经授权");
                
//                CFRelease(addressBook);
                
            } else {
                NSLog(@"没有授权");
            }
        });
    }
    CFRelease(addressBook);
}

//百度地图
- (void)onGetNetworkState:(int)iError
    {
        if (0 == iError) {
            NSLog(@"联网成功");
        }
        else{
            NSLog(@"onGetNetworkState %d",iError);
        }
        
    }
    
- (void)onGetPermissionState:(int)iError
    {
        if (0 == iError) {
            NSLog(@"授权成功");
        }
        else {
            NSLog(@"onGetPermissionState %d",iError);
        }
    }
    
    
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
