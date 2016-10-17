//
//  PersonToContactModel.h
//  Cyueyue
//
//  Created by fami_Lbb on 16/8/23.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YueFirendModel.h"

@interface PersonToContactModel : NSObject
//通讯录相关
//名
@property (nonatomic,strong)NSString *firstName;
//姓
@property (nonatomic,strong)NSString *lastName;
//姓氏的拼音
@property (nonatomic,strong)NSString *lastNamePhoneic;
//电话
@property (nonatomic,strong)NSString *phones;
//公司名
@property (nonatomic,strong)NSString *organization;

//全名
@property (nonatomic,strong)NSString *name;

////////////////////////

//事件相关
@property (nonatomic,strong)NSDate  *dateLabel;
@property (nonatomic,strong)NSString *beginTime;
@property (nonatomic,strong)NSString *endTime;
@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSString *addressStr;

//搜索地址的信息
@property (nonatomic,strong)NSString *mapName;
@property (nonatomic,strong)NSString *mapAddress;
@property (nonatomic,strong)NSString *icon;

@property (nonatomic,strong)NSMutableArray *yueFriendArr;


@end
