//
//  YueCarbonViewController.m
//  Cyueyue
//
//  Created by fami_Lbb on 16/10/9.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import "YueCarbonViewController.h"

@interface YueCarbonViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>
@property (nonatomic,strong)UIView *addView;
@property (nonatomic,strong)UIButton *finish;
@property (nonatomic,strong)UITapGestureRecognizer *tap;
@end

#warning 1.判断是否发送成功
@implementation YueCarbonViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
        self.view.backgroundColor = cCustom(0, 0, 0, 0.3);
        //添加退出填写框的手势
        self.tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        self.tap.delegate = self;
        [self.view addGestureRecognizer:self.tap];
        
        [self setupSubView];
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupSubView{
    
    UIView* addView = [[UIView alloc]initWithFrame:CGRectMake(41, (kScreen_Height - 250 - 64)/2, kScreen_Width - 82, 250)];
    addView.backgroundColor = [UIColor whiteColor];
    self.addView = addView;
    self.addView.backgroundColor = [UIColor whiteColor];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, self.addView.frame.size.width - 40, 20)];
    label.text = @"附加消息";
    label.font = [UIFont systemFontOfSize:14];
    
    UITextField* content = [[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(label.frame) + 30, label.frame.size.width, 37)];
    content.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 37)];
    content.leftViewMode = UITextFieldViewModeAlways;
    
    content.backgroundColor = [UIColor groupTableViewBackgroundColor];
    content.placeholder = @"输入内容";
    content.font = [UIFont systemFontOfSize:13];
    
    UITextField * location = [[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(content.frame) + 20, label.frame.size.width, 37)];
    location.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //解决文字紧贴边缘的问题
    location.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 37)];
    location.leftViewMode = UITextFieldViewModeAlways;
    location.delegate = self;
    location.placeholder = @"位置";
    location.font = [UIFont systemFontOfSize:13];
    self.location = location;
    
    self.finish = [[UIButton alloc]initWithFrame:CGRectMake(20, self.addView.frame.size.height - 50, 75, 30)];
    self.finish.backgroundColor = cTopicBlue;
    self.finish.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.finish setTitle:@"发送" forState:UIControlStateNormal];
    self.finish.layer.masksToBounds = YES;
    self.finish.layer.cornerRadius = 2;
    [self.finish addTarget:self action:@selector(finishAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.addView addSubview:label];
    [self.addView addSubview:content];
    [self.addView addSubview:location];
    [self.addView addSubview:self.finish];
    
    [self.view addSubview:self.addView];
   
}

#pragma mark ----UITextFieldDelegate----
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"LocationNot" object:nil];
}

//点击试图使填写框消失
- (void)tapAction{
    
    self.view.alpha = 0;
    [self.view endEditing:YES];
}

//回收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.addView endEditing:YES];
}

//判断收拾的执行者，防止子视图执行父试图的手势方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    // 输出点击的view的类名
    //    NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    if ([touch.view isDescendantOfView:self.addView]) {
        return NO;
    }
    
    return YES;
}


#pragma mark ----!!!!!!!!!!!!!!!发送事件----
- (void)finishAction:(id)sender{
  
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"成功"];
    
    self.view.alpha = 0;
    [self.view endEditing:YES];

}



- (void)dealloc{
    self.tap.delegate = nil;
    self.location.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
