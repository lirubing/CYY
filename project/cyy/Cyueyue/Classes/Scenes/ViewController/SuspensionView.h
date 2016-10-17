//
//  SuspensionView.h
//  Cyueyue
//
//  Created by fami_Lbb on 16/9/8.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuspensionView : UIViewController
@property (nonatomic,strong)PersonToContactModel *model;
@property (nonatomic,strong)UITextField *location;
@property (nonatomic,assign)BOOL editOn;

@property (nonatomic,strong)NSMutableArray *arrayDate;

@end
