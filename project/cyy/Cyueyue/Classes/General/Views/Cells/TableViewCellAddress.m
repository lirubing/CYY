//
//  TableViewCellAddress.m
//  Cyueyue
//
//  Created by fami_Lbb on 16/9/19.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import "TableViewCellAddress.h"

@implementation TableViewCellAddress

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
    
}

- (void)setModel:(PersonToContactModel *)model{
    
    self.imgView.image = [UIImage imageNamed:@"定位"];
    self.mapName.text = model.mapName;
    self.mapAddress.text = model.mapAddress;
    
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
