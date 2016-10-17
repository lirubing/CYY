//
//  FriendMaterialViewController.m
//  Cyueyue
//
//  Created by fami_Lbb on 16/9/7.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import "FriendMaterialViewController.h"

@interface FriendMaterialViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong)UITableView *tableView;
//备注
@property (nonatomic,strong)UITextField *remarkText;
@property (nonatomic,strong)UIImageView *imgPhone;
@property (nonatomic,strong)UISwitch *sWitch;
@property (nonatomic,strong)UIImageView * imgCard;
@property (nonatomic,assign)BOOL imgMP;
@property (nonatomic,strong)UIImage *img;

@end

//好友资料页
@implementation FriendMaterialViewController

static NSString *const Tcell = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view = view;
    self.title = @"好友资料";
    
    self.sWitch.on = YES;
    [self.view addSubview:self.tableView];
    [self addNavgationLeftButton];
    [self drawDeleteView];
}

#pragma mark --导航栏左按钮--
- (void)addNavgationLeftButton{
    
    ILBarButtonItem *barButton = [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"返回白"] selectedImage:[UIImage imageNamed:@"返回白"] target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = barButton;
    
}

- (void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//删除好友
- (void)drawDeleteView{
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, kScreen_Height - 60 - 64, kScreen_Width - 40, 40)];
    button.backgroundColor = cYellow;
    [button setTitle:@"删除好友" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 2;
    [button addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

//删除好友
- (void)deleteAction{
    
    NSLog(@"删除好友");
    
}

//点击tableview回收键盘
- (void)hideKeyBound{
    
    [self.tableView endEditing:YES];
}


//拨打电话
- (void)phoneAction{
    
    NSMutableString *str = [[NSMutableString alloc]initWithFormat:@"tel:%@",self.strPhone ];
    UIWebView *callWebView = [[UIWebView alloc]init];
    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    
    [self.view addSubview:callWebView];
    
}

/*
//调取相机
- (void)addAlertController{
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    
    //创建UIAlertController是为了让用户去选择照片来源,拍照或者相册.
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:0];
    
    //初始化你需要的选择栏
    //蓝色普通栏目
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action)
                                  {
                                      imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                      [self presentViewController:imagePickerController animated:YES completion:^{}];
                                      
                                  }];
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"从相册选择" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
        
    }];
    //取消栏
    UIAlertAction *cancelOne = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
        NSLog(@"取消");
    }];
    
    //用来判断来源 Xcode中的模拟器是没有拍摄功能的
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [alertController addAction:photoAction];
        [alertController addAction:cancelOne];
        [alertController addAction:albumAction];
    }else{
        [alertController addAction:albumAction];
        [alertController addAction:cancelOne];
    }
    
    
    //弹起
    [self presentViewController:alertController animated:YES completion:nil];

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    //选取裁剪后的图片
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
//     此处info 有六个值
//     UIImagePickerControllerMediaType;  an NSString UTTypeImage)
//     UIImagePickerControllerOriginalImage;  a UIImage 原始图片
//     UIImagePickerControllerEditedImage;  a UIImage 裁剪后图片
//     UIImagePickerControllerCropRect;  an NSValue (CGRect)
//     UIImagePickerControllerMediaURL;  an NSURL
//     UIImagePickerControllerReferenceURL  an NSURL that references an asset in the AssetsLibrary framework
//     UIImagePickerControllerMediaMetadata  an NSDictionary containing metadata from a captured photo
// 
    self.imgMP = YES;
    self.img = image;
    [self.tableView reloadData];
    
}
*/


#pragma mark ---UITableViewDelegate---
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 1) {
        return 3;
    }else
        
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 2) {
        return 30;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section == 2) {
        return @"名片";
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2) {
        return 278;
    }
    
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2) {
//        [self addAlertController];

    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Tcell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.contentView.userInteractionEnabled = YES;
    if (indexPath.section == 0) {
        cell.textLabel.text = self.strName;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }else if (indexPath.section == 1 && indexPath.row == 0){
        cell.textLabel.text= @"备注";
        [cell.contentView addSubview:self.remarkText];
    }else if (indexPath.section == 1 && indexPath.row == 1){
        cell.textLabel.text = [NSString stringWithFormat:@"电话号码   %@",self.strPhone];
        [cell.contentView addSubview:self.imgPhone];
    }else if (indexPath.section == 1 && indexPath.row == 2){
        cell.textLabel.text = @"可见我的日程";
        [cell.contentView addSubview:self.sWitch];
    }else if (indexPath.section == 2){
        self.imgCard = [[UIImageView alloc]initWithFrame:CGRectMake((kScreen_Width - 308)/2, 43, 308, 192)];
        self.imgCard.userInteractionEnabled = YES;
        
        if (!self.imgMP) {
            self.imgCard.image = [UIImage imageWithSize:CGSizeMake(308, 192) borderColor:[UIColor grayColor] borderWidth:1];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 55, 18)];
            label.center = CGPointMake(308/2, 192/2);
            label.text = @"暂无名片";
            label.textColor = [UIColor lightGrayColor];
            label.font = [UIFont systemFontOfSize:13];
            [self.imgCard addSubview:label];
            
        }else{
            self.imgCard.image = self.img;
        }
        
        [cell.contentView addSubview:self.imgCard];
    }
    
    return cell;
}
- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, self.view.frame.size.height - 60) style:UITableViewStyleGrouped];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBound)];
        tap.cancelsTouchesInView = NO;//设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
        [_tableView addGestureRecognizer:tap];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:Tcell];
    }
    
    return _tableView;
}

- (UITextField *)remarkText{
   
    if (!_remarkText) {
        _remarkText = [[UITextField alloc]initWithFrame:CGRectMake(56, 9.5, kScreen_Width - 66, 25)];
        _remarkText.placeholder = @"请在此处填写备注";
        _remarkText.font = [UIFont systemFontOfSize:13];
    }
    return _remarkText;
}

- (UIImageView *)imgPhone{
    if (!_imgPhone) {
        self.imgPhone = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width - 46, 10, 30, 22)];
        self.imgPhone.userInteractionEnabled = YES;
        self.imgPhone.image = [UIImage imageNamed:@"拨打"];
        self.imgPhone.contentMode = UIViewContentModeScaleAspectFit;
        
        //添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(phoneAction)];
        [self.imgPhone addGestureRecognizer:tap];
    }
    return _imgPhone;
}

- (UISwitch *)sWitch{
    if (!_sWitch) {
        _sWitch = [[UISwitch alloc]initWithFrame:CGRectMake(kScreen_Width - 61, 6.5, 0, 0)];
        
    }
    return _sWitch;
}


- (UIImage *)img{
    if (!_img) {
        _img = [UIImage new];
    }
    return _img;
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
