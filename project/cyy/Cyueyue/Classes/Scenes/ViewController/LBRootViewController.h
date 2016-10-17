//
//  LBRootViewController.h
//  Cyueyue
//
//  Created by fami_Lbb on 16/7/25.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBRootViewController : UIViewController<FSCalendarDataSource,FSCalendarDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong)FSCalendar *calendar;

@end
