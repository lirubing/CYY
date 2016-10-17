//
//  LoginViewController.m
//  Cyueyue
//
//  Created by fami_Lbb on 16/8/18.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "PasswordViewController.h"
#import "AppDelegate.h"
#import "LBRootViewController.h"
@interface LoginViewController ()

//@property (nonatomic,strong)UIImageView *imgView;

@property (nonatomic,strong)UIButton *buttAgree;

@property (nonatomic,assign)BOOL boolDelegate;

@property (nonatomic,strong)UITextField *userTF;

@property (nonatomic,strong)UITextField *passTF;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.boolDelegate = YES;
    
    //绘图
    [self draw];
    
    
}

- (void)draw{
    
    UIColor *colGray = cLight;
    
    UIImageView *imgIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 120, 181)];
    imgIcon.contentMode = UIViewContentModeScaleAspectFit;
    imgIcon.center = CGPointMake(self.view.frame.size.width / 2,kScreen_Height * 0.204);
    imgIcon.image = [UIImage imageNamed:@"创约约"];
    [self.view addSubview:imgIcon];
    
    
    CGRect number = CGRectMake(0, 0, kScreen_Width - 68 * 2, 30);
    CGPoint point = CGPointMake(kScreen_Width / 2 , kScreen_Height * 0.454);
    
    self.userTF = [[UITextField alloc]init];
    [self inputImage:@"手机" UITextField:self.userTF TextField:@"请填写注册的手机号" frame:number CGPoint:point];
    
    CGRect password = CGRectMake(0, 0, kScreen_Width - 68 * 2, 30);
    CGPoint point1 = CGPointMake(kScreen_Width / 2 , kScreen_Height * 0.545);
    
    self.passTF = [[UITextField alloc]init];
    [self inputImage:@"密码" UITextField:self.passTF TextField:@"密码" frame:password CGPoint:point1];
    
    
    //登录按钮
    UIButton *logButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width - 68 * 2, 40)];
    logButton.center = CGPointMake(kScreen_Width / 2, kScreen_Height * 0.652);
    logButton.layer.masksToBounds = YES;
    logButton.layer.cornerRadius = 2;
    logButton.backgroundColor = cTopicBlue;
    [logButton setTitle:@"登录" forState:UIControlStateNormal];
    logButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [logButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:logButton];
    
    
    UIButton *registerButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 52, 18)];
    registerButton.center = CGPointMake(16 + 26, kScreen_Height *0.739);
    [registerButton setTitle:@"注册账号" forState:UIControlStateNormal];
    [registerButton setTitleColor:colGray forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [registerButton addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    
    
    UIButton *forgetButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0, 52, 18)];
    forgetButton.center = CGPointMake(kScreen_Width - 16 - 26, kScreen_Height *0.739);
    [forgetButton setTitleColor:colGray forState:UIControlStateNormal];
    
    [forgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    forgetButton.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [forgetButton addTarget:self action:@selector(forgetrAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetButton];
    
}



- (void)inputImage:(NSString *)imgName UITextField:(UITextField *)textField TextField:(NSString *)place frame:(CGRect)rect CGPoint:(CGPoint)point{
    
    UIColor *colGray = cLight;
    
    UIImageView *img = [[UIImageView alloc]init];
    img.contentMode = UIViewContentModeScaleAspectFit;
    img.frame = CGRectMake(0, 0, 30, 20);
    img.image = [UIImage imageNamed:imgName];
    
    textField.frame = rect;
    textField.center = point;
    textField.placeholder = place;
    [textField setValue:colGray forKeyPath:@"_placeholderLabel.textColor"];
    
    textField.font = [UIFont systemFontOfSize:13];
    textField.textColor = [UIColor blackColor];
    textField.leftView = img;
    textField.leftViewMode=UITextFieldViewModeAlways;
    if ([imgName isEqualToString:@"密码"]) {
        textField.secureTextEntry = YES;
    }
    
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = cLight;
    view.frame = CGRectMake(textField.frame.origin.x, CGRectGetMaxY(textField.frame), textField.frame.size.width, 1);
    
    [self.view addSubview:textField];
    [self.view addSubview:view];
    
}


#pragma -----------action----------

- (void)loginAction{
#warning 接入登录入口

    if ([self.userTF.text isEqualToString:@"1"] && [self.passTF.text isEqualToString:@"1"]) {
        
        [[TKAlertCenter defaultCenter]postAlertWithMessage:@"登陆成功"];
        
        //将账号密码存储到本地
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:self.userTF.text forKey:@"用户名"];
        [user setObject:self.passTF.text forKey:@"密码"];
        [user setBool:YES forKey:@"是否登录"];
        [user synchronize];
        
        AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        YRSideViewController *sideVC = [appDel sideVC];
        sideVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:sideVC animated:YES completion:nil];
        
    }
    
}



- (void)registerAction{
    
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    registerVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:registerVC animated:YES completion:nil];
    
    
}


- (void)forgetrAction{
    
    PasswordViewController *pass = [[PasswordViewController alloc]init];
    pass.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:pass animated:YES completion:nil];
    
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
