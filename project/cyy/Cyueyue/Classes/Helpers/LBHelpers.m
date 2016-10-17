//
//  LBHelpers.m
//  Cyueyue
//
//  Created by fami_Lbb on 16/8/18.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import "LBHelpers.h"
@interface LBHelpers()
//通讯录好友
@property (nonatomic)ABAddressBookRef addressBook;
@property (nonatomic)ABExternalChangeCallback *addressCallback;
@property (nonatomic,strong)NSMutableArray *mutArray;
//存放联系人的数组
@property (nonatomic,strong)NSMutableArray *dateArray;
//标题数组
@property (nonatomic,strong)NSMutableArray *titleArray;

@end

@implementation LBHelpers

+ (LBHelpers *)shareLBHeloper{
    static LBHelpers *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[LBHelpers alloc]init];
    });
    return helper;
}

//
- (YRSideViewController *)getRootViewController{
    
    AppDelegate *appdele = [[UIApplication sharedApplication] delegate];
    YRSideViewController *sideViewController=[appdele sideVC];
    return sideViewController;
}



/** 该字符串是否是手机号 */
- (BOOL)isPhoneNumber:(NSString *)str {
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[156])\\d{8}$";
    NSString * CT = @"^1((33|53|8|7[09])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    BOOL res1 = [regextestmobile evaluateWithObject:str];
    BOOL res2 = [regextestcm evaluateWithObject:str];
    BOOL res3 = [regextestcu evaluateWithObject:str];
    BOOL res4 = [regextestct evaluateWithObject:str];
    
    if (res1 || res2 || res3 || res4 ) {
        return YES;
    } else {
        return NO;
    }
    
}


#pragma mark -----获取手机通讯录的信息并排序-----
- (void)getPersonToContact{
    
    self.mutArray = nil;
    self.dateArray = nil;
    self.titleArray = nil;
    
    //1. 判断是否授权成功, 授权成功才能获取数据
    if ( ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        //2. 创建通讯录
        self.addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        //注册回调函数
        //   ABAddressBookRegisterExternalChangeCallback(self.addressBook, ContactsChangeCallback, nil);
        
        //3. 获取所有联系人
        CFArrayRef peosons = ABAddressBookCopyArrayOfAllPeople(self.addressBook);
        //4. 遍历所有联系人来获取数据(姓名和电话)
        CFIndex count = CFArrayGetCount(peosons);
        for (CFIndex i = 0 ; i < count; i++) {
            
            //创建储存联系人的model类
            PersonToContactModel *model = [[PersonToContactModel alloc]init];
            
            //5. 获取单个联系人
            ABRecordRef person = CFArrayGetValueAtIndex(peosons, i);
            //6. 获取姓名
            NSString *lastName = CFBridgingRelease(ABRecordCopyValue(person,kABPersonLastNameProperty));
            NSString *firstName  = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
            //读取organization公司
            NSString *organization = CFBridgingRelease(ABRecordCopyValue(person, kABPersonOrganizationProperty));
            
            
            //NSString *lastNamePhoneic = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNamePhoneticProperty));
            //读取lastname拼音音标
            //NSString *lastnamePhonetic = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNamePhoneticProperty);
            
            //  NSLog(@"lastName: %@, firstName: %@", lastName, firstName);
            
            model.lastName = lastName;
            model.firstName = firstName;
            
            if (model.lastName.length == 0 && model.firstName.length > 0) {
                model.name = firstName;
            }else if (model.firstName.length == 0 && model.lastName.length > 0){
                model.name = lastName;
            }else if (model.firstName.length > 0 && model.lastName.length > 0){
                model.name = [NSString stringWithFormat:@"%@%@",lastName,firstName];
            }else if (model.lastName.length == 0 && model.firstName.length == 0 && organization.length > 0){
                model.name = organization;
            }
            
            //7. 获取电话
            ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
            //7.1 获取电话的count数
            //            CFIndex phoneCount = ABMultiValueGetCount(phones);
            //            //7.2 遍历所有电话号码
            //            for (CFIndex i = 0; i < phoneCount; i++) {
            //                NSString *label = CFBridgingRelease(ABMultiValueCopyLabelAtIndex(phones, i));
            //                NSString *value = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, i));
            //                // 打印标签和电话号
            //                NSLog(@"label: %@, value: %@",label, value);
            //            }
            
            
            NSString *valuePhone = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, 0));
            model.phones = valuePhone;
            
            if (model.lastName.length == 0 && model.firstName.length == 0 && organization.length == 0){
                model.name = model.phones;
            }
            
            [self.mutArray addObject:model];
            
            //8.1 释放 CF 对象
            CFRelease(phones);
        }
        //8.1 释放 CF 对象
        CFRelease(peosons);
        CFRelease(self.addressBook);
        
    }
    
    
    [self dealDateWithArray];
    
}


//汉字转换拼音取首字母
- (NSString *)returnFirstWordWithString:(NSString *)str
{
    
    if (str.length > 0) {
        
        NSMutableString * mutStr = [NSMutableString stringWithString:str];
        
        //将mutStr中的汉字转化为带音标的拼音（如果是汉字就转换，如果不是则保持原样）
        CFStringTransform((__bridge CFMutableStringRef)mutStr, NULL, kCFStringTransformMandarinLatin, NO);
        //将带有音标的拼音转换成不带音标的拼音（这一步是从上一步的基础上来的，所以这两句话一句也不能少）
        CFStringTransform((__bridge CFMutableStringRef)mutStr, NULL, kCFStringTransformStripCombiningMarks, NO);
        if (mutStr.length > 0) {
            //全部转换为大写    取出首字母并返回
            NSString * res = [[mutStr uppercaseString] substringToIndex:1];
            
            return res;
        }
        else
            //str = nil;
            return @"";
    }
    
    else
        
        return nil;
}

//抽取首字母，排序
- (void)dealDateWithArray{
    
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:10];
    
    for (int i = 0; i < 27; i++) {
        //创建27个数组用来存放A~Z和#开头的联系人
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
        [tmpArray addObject:array];
    }
    
    for (PersonToContactModel *model in self.mutArray) {
        
        //转换成大写字母并读取首字母
        NSString *res = [self returnFirstWordWithString:model.name];
        
        int firstWord = [res characterAtIndex:0];
        if (firstWord >= 65 && firstWord <= 90) {
            //如果首字母是A~Z，直接放到对应数组
            NSMutableArray *array = tmpArray[firstWord - 65];
            [array addObject:model];
        }else{
            
            //如果不是，就放到最后一个代表#的数组
            NSMutableArray *array = [tmpArray lastObject];
            [array addObject:model];
        }
        
    }
    
    //此时数组已经按照首字母排列顺序并分组
    //便利数组删掉空数组
    for (NSMutableArray *mutArr in tmpArray) {
        
        if (mutArr.count != 0) {
            [self.dateArray addObject:mutArr];
            PersonToContactModel *model = mutArr[0];
            
            //转换成大写字母并读取首字母
            NSString *res = [self returnFirstWordWithString:model.name];
            
            int firstWord = [res characterAtIndex:0];
            //取出其中的首字母放入到标题数组，暂时不考虑非A-Z的情况
            if (firstWord >= 65 && firstWord <= 90) {
                [self.titleArray addObject:res];
            }
        }
    }
    
    if (!(self.titleArray.count == self.dateArray.count)) {
        
        [self.titleArray addObject:@"#"];
    }
    
    
}

#pragma mark ----判断时间区间----
- (BOOL)isBetweenAddFromHour:(NSInteger)AddFromHour
               AddFromMinute:(NSInteger)addFromMinute
               BeginFromHour:(NSInteger)beginFromHour
             BeginFromMinute:(NSInteger)beginFromMinute
                 EndFromHour:(NSInteger)endFromHour
               EndFromMinute:(NSInteger)endFromMinute{
    
    
    NSDate *date8 = [self getCustomDateWithHour:beginFromHour Minute:beginFromMinute];
    NSDate *date23 = [self getCustomDateWithHour:endFromHour Minute:endFromMinute];
    
    NSDate *currentDate = [self getCustomDateWithHour:AddFromHour Minute:addFromMinute];
    
    if ([currentDate compare:date8]==NSOrderedDescending && [currentDate compare:date23]==NSOrderedAscending)
    {
        NSLog(@"该时间在 %ld:%ld-%ld:%ld 之间！", (long)beginFromHour,beginFromMinute, (long)endFromHour,endFromMinute);
        
        return NO;
    }
    
    return YES;
}


- (NSDate *)getCustomDateWithHour:(NSInteger)hour Minute:(NSInteger)minute
{
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    
    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    [resultComps setMinute:minute];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [resultCalendar dateFromComponents:resultComps];
}




#pragma mark ----lazyLoad----
- (NSMutableArray *)mutArray{
    if (!_mutArray) {
        
        _mutArray = [[NSMutableArray alloc]initWithCapacity:20];
        
    }
    
    return _mutArray;
}

- (NSMutableArray *)dateArray{
    if (!_dateArray) {
        
        _dateArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _dateArray;
}

- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _titleArray;
}

- (NSArray *)addressContent{
    return [self.dateArray mutableCopy];
}

- (NSArray *)addressList{
    return [self.titleArray mutableCopy];
}


@end
