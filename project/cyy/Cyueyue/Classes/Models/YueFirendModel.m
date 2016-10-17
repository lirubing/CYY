//
//  YueFirendModel.m
//  Cyueyue
//
//  Created by fami_Lbb on 16/10/10.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import "YueFirendModel.h"

@implementation YueFirendModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    NSLog(@"KVC异常处理");
    
}

- (NSString *)description{
    
    return [NSString stringWithFormat:@"%@,%@,%@",_friendName,_friendEvent,_friendAddress];
}

@end
