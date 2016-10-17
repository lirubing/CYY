//
//  PasswordViewController.m
//  Cyueyue
//
//  Created by fami_Lbb on 16/8/18.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import "PasswordViewController.h"

@interface PasswordViewController ()

@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,strong)UITextField *box;
@property(nonatomic,strong)UITextField *password;
@property(nonatomic,strong)UITextField *passAgian;
@property (nonatomic,strong)UIButton *timeBut;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign)NSInteger countTim;

@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawView];
}


#pragma ------------draw-------------
- (void)drawView{
    
    
    UIImageView *backImg = [[UIImageView alloc]initWithFrame:CGRectMake(25, 35, 10, 20)];
    backImg.image = [UIImage imageNamed:@"返回黑"];
    backImg.userInteractionEnabled = YES;
    [self.view addSubview:backImg];
    
    UIButton *buttBack = [[UIButton alloc]initWithFrame:CGRectMake(20, 30, 40, 40)];
    [buttBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttBack];
    
    
    CGRect rect1 = CGRectMake(66, kScreen_Height * 0.181, kScreen_Width - 66 * 2, 30);
    [self inputImage:@"手机" UITextField:self.box TextField:@"手机号" frame:rect1];
    
    CGRect rect2 = CGRectMake(66, kScreen_Height * 0.267,kScreen_Width - 66 * 2, 30);
    [self inputImage:@"验证码" UITextField:self.password TextField:@"验证码" frame:rect2];
    
    CGRect rect3 = CGRectMake(66, kScreen_Height * 0.353,kScreen_Width - 66 * 2, 30);
    [self inputImage:@"密码" UITextField:self.passAgian TextField:@"设置密码" frame:rect3];
    
    UIButton *buttonRegis = [[UIButton alloc]initWithFrame:CGRectMake(66, kScreen_Height * 0.456, kScreen_Width - 66 * 2, 40)];
    [buttonRegis setTitle:@"提交" forState:UIControlStateNormal];
    buttonRegis.backgroundColor = cTopicBlue;
    buttonRegis.titleLabel.font = [UIFont systemFontOfSize:16];
    [buttonRegis addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:buttonRegis];
    
}



- (void)inputImage:(NSString *)imgName  UITextField:(UITextField *)textfield TextField:(NSString *)place frame:(CGRect)rect{
    UIColor *colGray = cLight;
    
    UIImageView *img = [[UIImageView alloc]init];
    img.frame = CGRectMake(0, 0, 35, 20);
    if ([imgName isEqualToString:@"验证码"]) {
        img.frame = CGRectMake(0, 0, 35, 14.2);
    }else if ([imgName isEqualToString:@"密码"]){
        img.frame = CGRectMake(0, 0, 35, 18);
    }
    
    img.contentMode = UIViewContentModeScaleAspectFit;
    img.image = [UIImage imageNamed:imgName];
    
    
    textfield = [[UITextField alloc]init];
    textfield.frame = rect;
    textfield.placeholder = place;
    [textfield setValue:colGray forKeyPath:@"_placeholderLabel.textColor"];
    textfield.font = [UIFont systemFontOfSize:13];
    textfield.textColor = [UIColor blackColor];
    textfield.leftView = img;
    textfield.leftViewMode=UITextFieldViewModeAlways;
    
    if ([imgName isEqualToString:@"密码"]) {
        
        textfield.secureTextEntry = YES;
    }
    
    if ([imgName isEqualToString:@"验证码"]) {
        
        textfield.rightView = self.timeBut;
        textfield.rightViewMode=UITextFieldViewModeAlways;
    }
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = cLight;
    view.frame = CGRectMake(textfield.frame.origin.x, CGRectGetMaxY(textfield.frame), textfield.frame.size.width, 1);
    
    [self.view addSubview:textfield];
    [self.view addSubview:view];
}


#pragma -------action-------
- (void)backAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



//!!!: 登录注册的提示完善
- (void)registerAction{
    
    //    if (self.box.text.length > 0 && self.password.text.length > 0 && self.passAgian.text.length > 0 &&[self.password.text isEqualToString:self.passAgian.text]) {
    
    //        [[ChatHelpers shareChatHelpes].dic setObject:self.password.text forKey:self.box.text];
    //
    //        [[TKAlertCenter defaultCenter]postAlertWithMessage:@"注册成功，请登录！"];
    
    //    }
    
    //    [[TKAlertCenter defaultCenter]postAlertWithMessage:@"输入有误！"];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}

- (void)securityCode{
    
    self.countTim = 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeCounter:) userInfo:nil repeats:YES];
    
    
}

- (void)timeCounter:(NSTimer *)timer{
    
    self.countTim--;
    if (self.countTim == 0) {
        
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
        
        [self.timeBut setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.timeBut.userInteractionEnabled = YES;
        
    }else{
        
        [self.timeBut setTitle:[NSString stringWithFormat:@"(%ld)获取验证码",self.countTim] forState:UIControlStateNormal];
        self.timeBut.userInteractionEnabled = NO;
    }
    
}



- (UIButton *)timeBut{
    if (!_timeBut) {
        
        UIColor *color = cLight;
        _timeBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _timeBut.frame = CGRectMake(self.password.frame.size.width - 100, 0, 100, 18);
        [_timeBut setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_timeBut setTitleColor:color forState:UIControlStateNormal];
        _timeBut.titleLabel.font = [UIFont systemFontOfSize:13];
        //button文本右对齐
        _timeBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_timeBut addTarget:self action:@selector(securityCode) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _timeBut;
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
