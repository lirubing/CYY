//
//  FriendHomeVC.h
//  Cyueyue
//
//  Created by fami_Lbb on 16/9/6.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendHomeVC : UIViewController<FSCalendarDataSource,FSCalendarDelegate>

@property (nonatomic,strong)FSCalendar *calendar;
@property (nonatomic,strong)NSString *strName;
@property (nonatomic,strong)NSString *strPhone;

@end
