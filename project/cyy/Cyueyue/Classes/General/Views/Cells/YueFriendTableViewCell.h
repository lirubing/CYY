//
//  YueFriendTableViewCell.h
//  Cyueyue
//
//  Created by fami_Lbb on 16/10/9.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YueFirendModel.h"

@interface YueFriendTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *friendName;
@property (weak, nonatomic) IBOutlet UILabel *friendEvent;
@property (weak, nonatomic) IBOutlet UILabel *friendAddress;

@property (nonatomic,strong)YueFirendModel *model;

@end
