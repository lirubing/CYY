//
//  TimeLineViewController.h
//  Cyueyue
//
//  Created by fami_Lbb on 16/9/30.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeLineViewController : UIViewController

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)UIScrollView *scrollView;

//当前所在的日期
@property (nonatomic,strong)NSDate *dayTime;

@property (nonatomic,assign)BOOL onEdit;

@property (nonatomic,strong)NSMutableArray *allDateArr;

@property (nonatomic,strong)NSMutableArray *friendYueArr;

@end
