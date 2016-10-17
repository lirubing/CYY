//
//  LocationViewController.h
//  Cyueyue
//
//  Created by fami_Lbb on 16/9/12.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BLOCK)(NSString *);
@interface LocationViewController : UIViewController

//回调函数传地址
@property (nonatomic,copy)BLOCK block;

@end
