//
//  ChangPasswordVC.m
//  Cyueyue
//
//  Created by fami_Lbb on 16/9/6.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import "ChangPasswordVC.h"

@interface ChangPasswordVC ()
@property (nonatomic,strong)UITextField *textF1;
@property (nonatomic,strong)UITextField *textF2;
@end

@implementation ChangPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view = view;
    
    self.title = @"修改密码";
    
    [self drawView];
    
    [self addNavgationButton];
}

#pragma mark --导航栏左按钮--
- (void)addNavgationButton{
    
    ILBarButtonItem *barButtonLeft = [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"返回白"] selectedImage:[UIImage imageNamed:@"返回白"] target:self action:@selector(backAction)];
    
    UIBarButtonItem *barRightItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finishAction)];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [barRightItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem = barButtonLeft;
    self.navigationItem.rightBarButtonItem = barRightItem;
    
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

//修改密码
- (void)finishAction{
    
    if (self.textF1.text.length < 6 | self.textF2.text.length < 6) {
        
        [[TKAlertCenter defaultCenter]postAlertWithMessage:@"密码不得少于六位"];
        return;
    }
    
    if (self.textF1.text != self.textF2.text) {
        [[TKAlertCenter defaultCenter]postAlertWithMessage:@"两次密码输入不一致"];
        return;
    }
    
#warning 修改密码后存入后台
    
    [[TKAlertCenter defaultCenter]postAlertWithMessage:@"修改成功"];
    
}


- (void)drawView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 134)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreen_Width - 10, 44)];
    label.text = @"修改密码";
    label.font = [UIFont systemFontOfSize:15];
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 44, kScreen_Width, 1)];
    viewLine.backgroundColor = cCustom(231, 230, 230, 1);
    
     self.textF1 = [[UITextField alloc]initWithFrame:CGRectMake(10, 45, kScreen_Width - 10, 44)];
    self.textF1.placeholder = @"新密码";
    self.textF1.secureTextEntry = YES;
    self.textF1.font = [UIFont systemFontOfSize:13];
    
    UIView *viewLine1 = [[UIView alloc]initWithFrame:CGRectMake(0, 89, kScreen_Width, 1)];
    viewLine1.backgroundColor = cCustom(231, 230, 230, 1);
    
    self.textF2 = [[UITextField alloc]initWithFrame:CGRectMake(10, 90, kScreen_Width - 10, 44)];
    self.textF2.placeholder = @"确认密码";
    self.textF2.secureTextEntry = YES;
    self.textF2.font = [UIFont systemFontOfSize:13];
    
    [view addSubview:label];
    [view addSubview:viewLine];
    [view addSubview:self.textF1];
    [view addSubview:viewLine1];
    [view addSubview:self.textF2];
    [self.view addSubview:view];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
