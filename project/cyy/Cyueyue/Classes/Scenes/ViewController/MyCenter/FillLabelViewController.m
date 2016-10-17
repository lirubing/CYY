
//
//  FillLabelViewController.m
//  Cyueyue
//
//  Created by fami_Lbb on 16/9/1.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import "FillLabelViewController.h"

@interface FillLabelViewController ()<UITextViewDelegate>
@property (nonatomic,strong)UITextView * textView;
@property (nonatomic,strong)UILabel *labelPlaceHolder;
@end

@implementation FillLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view = view;
    [self darwView];
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

- (void)finishAction{
   
    if (self.textView.text.length > 0) {
    
        [self.navigationController popViewControllerAnimated:YES];
        self.block(self.textView.text);
        NSLog(@"%@",self.textView.text);
    }

}

- (void)darwView{
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 14, kScreen_Width, 100)];
    self.textView.delegate = self;
    self.textView.font = [UIFont systemFontOfSize:15];
    self.labelPlaceHolder = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreen_Width - 20, 40)];
    self.labelPlaceHolder.text = @"请输入标签，如要输入多个标签，请以空格隔开。";
    self.labelPlaceHolder.textColor = [UIColor grayColor];
    self.labelPlaceHolder.contentMode = UIViewContentModeTop;
    self.labelPlaceHolder.font = [UIFont systemFontOfSize:13];
    [self.textView addSubview:self.labelPlaceHolder];
    
    [self.view addSubview:self.textView];
    
}

#pragma mark ---UITextViewDelegate---
- (void)textViewDidChange:(UITextView *)textView{
    
    if (!self.textView.text.length) {
        self.labelPlaceHolder.alpha = 1;
    }else{
        self.labelPlaceHolder.alpha = 0;
    }
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
