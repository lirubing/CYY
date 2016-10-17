
//
//  PersonToContactModel.m
//  Cyueyue
//
//  Created by fami_Lbb on 16/8/23.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import "PersonToContactModel.h"

@implementation PersonToContactModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    NSLog(@"KVC异常处理");
    
}

- (void)setPhones:(NSString *)phones{
   
    //过滤字符串前后的空格
    _phones = [phones stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //过滤中间空格
    _phones = [self.phones stringByReplacingOccurrencesOfString:@" " withString:@""];
}



- (NSString *)description{
    
    return [NSString stringWithFormat:@"%@,%@,%@,%@",_beginTime,_endTime,_mapName,_yueFriendArr];
}


- (NSMutableArray *)yueFriendArr{
    if (!_yueFriendArr) {
        _yueFriendArr = [[NSMutableArray alloc]init];
    }
    return _yueFriendArr;
}


@end
