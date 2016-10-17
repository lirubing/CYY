//
//  YueFriendTableViewCell.m
//  Cyueyue
//
//  Created by fami_Lbb on 16/10/9.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import "YueFriendTableViewCell.h"

@implementation YueFriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(YueFirendModel *)model{
    
    self.friendName.text = model.friendName;
    self.friendEvent.text = model.friendEvent;
    self.friendAddress.text = model.friendAddress;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
