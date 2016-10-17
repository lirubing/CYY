//
//  TableViewCellAddress.h
//  Cyueyue
//
//  Created by fami_Lbb on 16/9/19.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCellAddress : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *mapName;
@property (weak, nonatomic) IBOutlet UILabel *mapAddress;
@property (nonatomic,strong)PersonToContactModel *model;

@end
