//
//  LBHelpers.h
//  Cyueyue
//
//  Created by fami_Lbb on 16/8/18.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBHelpers : NSObject
@property (nonatomic,strong)NSArray *addressContent;
@property (nonatomic,strong)NSArray *addressList;

+ (LBHelpers *)shareLBHeloper;
/** 该字符串是否是手机号 */
- (BOOL)isPhoneNumber:(NSString *)str;

//获取首页
- (YRSideViewController *)getRootViewController;
//获取通讯录好友
- (void)getPersonToContact;

//判断区间
- (BOOL)isBetweenAddFromHour:(NSInteger)AddFromHour
               AddFromMinute:(NSInteger)addFromMinute
               BeginFromHour:(NSInteger)beginFromHour
             BeginFromMinute:(NSInteger)beginFromMinute
                 EndFromHour:(NSInteger)endFromHour
               EndFromMinute:(NSInteger)endFromMinute;


@end
