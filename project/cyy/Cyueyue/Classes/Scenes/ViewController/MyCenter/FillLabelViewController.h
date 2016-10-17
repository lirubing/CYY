//
//  FillLabelViewController.h
//  Cyueyue
//
//  Created by fami_Lbb on 16/9/1.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^BLOCK)(NSString *);
@interface FillLabelViewController : UIViewController
@property (nonatomic,copy)BLOCK block;
@end
