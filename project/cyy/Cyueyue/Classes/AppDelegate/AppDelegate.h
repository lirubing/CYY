//
//  AppDelegate.h
//  Cyueyue
//
//  Created by fami_Lbb on 16/7/25.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBRootViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong)YRSideViewController *sideVC;
@property (nonatomic,strong)BMKMapManager* mapManager;

@end

