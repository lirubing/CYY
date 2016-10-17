//
//  MyProfile.m
//  Cyueyue
//
//  Created by fami_Lbb on 16/8/22.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import "MyProfile.h"

@interface MyProfile ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIImage *img;
@property (nonatomic,assign)BOOL imgMP;
@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)NSString *fillLableText;
@property (nonatomic,strong)NSArray *arrayFill;
@property (nonatomic,strong)UILabel *tagView;
@property (nonatomic,strong)UIImageView *imgCard;
@end

@implementation MyProfile
static NSString *const cellID = @"cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
#warning 接入数据库后判断名片是否存在，做出相应的操作
    NSLog(@"%id",self.imgMP);

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view = view;
    self.title = @"我的资料";
    [self addNavgationButton];
    [self.view addSubview:self.tableView];
}

#pragma mark --导航栏左按钮--
- (void)addNavgationButton{
    
    ILBarButtonItem *barButtonLeft = [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"返回白"] selectedImage:[UIImage imageNamed:@"返回白"] target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = barButtonLeft;
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---UITableViewDelegate---
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        
        return 90;
        
    }else
        
        return 14;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {

        return 278;
        
    }else
    
        return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return nil;
    }else
        
        return @"名片";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        [self addAlertController];
    }else if (indexPath.section == 0 && indexPath.row == 0){
        [self modifyNumber];
    }else if (indexPath.section == 0 && indexPath.row == 1){
        [self fillLabel];
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"电话";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            self.label = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width - 137, 12, 100, 20)];
            self.label.text = @"13426098768";
            self.label.font = [UIFont systemFontOfSize:14];
            self.label.textColor = [UIColor grayColor];
            [cell.contentView addSubview:self.label];
            
        }else{
            cell.textLabel.text = @"标签";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:self.tagView];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
    }else{
        
        self.imgCard = [[UIImageView alloc]initWithFrame:CGRectMake((kScreen_Width - 308)/2, 43, 308, 192)];
        self.imgCard.userInteractionEnabled = YES;
        if (!self.imgMP) {
            self.imgCard.image = [UIImage imageWithSize:CGSizeMake(308, 192) borderColor:[UIColor grayColor] borderWidth:1];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 55, 18)];
            label.center = CGPointMake(308/2, 192/2);
            label.text = @"添加名片";
            label.textColor = [UIColor lightGrayColor];
            label.font = [UIFont systemFontOfSize:13];
            UIImageView *imV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15.8, 15.8)];
            imV.center = CGPointMake(label.frame.origin.x - 11, 192/2);
            imV.image = [UIImage imageNamed:@"添加名片"];
            [self.imgCard addSubview:imV];
            [self.imgCard addSubview:label];
        }else{
            self.imgCard.image = self.img;
        }
        
        [cell.contentView addSubview:self.imgCard];
        
    }
    
    
    return cell;
}


//选取相机或照片
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
    /* 此处info 有六个值
     UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     UIImagePickerControllerOriginalImage; // a UIImage 原始图片
     UIImagePickerControllerEditedImage; // a UIImage 裁剪后图片
     UIImagePickerControllerCropRect; // an NSValue (CGRect)
     UIImagePickerControllerMediaURL; // an NSURL
     UIImagePickerControllerReferenceURL // an NSURL that references an asset in the AssetsLibrary framework
     UIImagePickerControllerMediaMetadata // an NSDictionary containing metadata from a captured photo
     */
    self.imgMP = YES;
    self.img = image;
    [self.tableView reloadData];
    
}

//修改手机号的输入框
- (void)modifyNumber{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"修改手机号" message:nil preferredStyle:
                                  UIAlertControllerStyleAlert];
    // 添加输入框 (注意:在UIAlertControllerStyleActionSheet样式下是不能添加下面这行代码的)
    [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入新的手机号";
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        // 通过数组拿到textTF的值
        NSLog(@"ok, %@", [[alertVc textFields] objectAtIndex:0].text);
        
        self.label.text = [[alertVc textFields] objectAtIndex:0].text;
        [self.tableView reloadData];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    // 添加行为
    [alertVc addAction:action2];
    [alertVc addAction:action1];
    [self presentViewController:alertVc animated:YES completion:nil];
    
}

//添加标签
- (void)fillLabel{
    
    FillLabelViewController *fillLabel = [[FillLabelViewController alloc]init];
    fillLabel.block = ^(NSString *string){
        
        self.fillLableText = nil;
        self.fillLableText = string;
        [self getFillLableArrayWithString];
    };
    [self.navigationController pushViewController:fillLabel animated:YES];
}

//将标签分离开来存入数组
- (void)getFillLableArrayWithString{
    
//    NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:10];
//    // NSStringEnumerationByWords：将string按空格分开，并且会自动清理首尾的空格
//    // 这个方法会把中间多余的空格也清理掉，会变成一个空格
//    [self.fillLableText enumerateSubstringsInRange:NSMakeRange(0, self.fillLableText.length) options:NSStringEnumerationByWords usingBlock:
//     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
//    {
//        [arr addObject:substring];
//    }];
    
    NSArray *resultArr1 = [self.fillLableText componentsSeparatedByString:@" "];
    NSMutableArray *mutArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < resultArr1.count; i++) {
        
        NSString *str = resultArr1[i];
        if (str.length > 0) {
            [mutArr addObject:str];
        }
        
    }
    self.arrayFill = [mutArr mutableCopy];
    
    [self setupFillLable];
    
    [self.tableView reloadData];
}

- (void)setupFillLable{
    
    [self.tagView removeFromSuperview];
    self.tagView = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 280, 35)];
    CGFloat positionX = 0.0;
    CGFloat positionY = 0.0;
    CGFloat bgViewWidth = 300-20;
    UIFont *btnTitleFont = [UIFont systemFontOfSize:13];

    for(int i = 0;i < self.arrayFill.count;i++)
    {
        //下面的方法
        CGFloat btnWidth = [self textWidth:self.arrayFill[i] Font:btnTitleFont height:25];
        

        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(positionX, positionY, btnWidth, 25)];
        label.text = self.arrayFill[i];
        label.textColor = [UIColor whiteColor];
        label.font = btnTitleFont;
        label.textAlignment = UITextAlignmentCenter;
        label.backgroundColor = cTopicBlue;
        label.layer.masksToBounds = YES;
        label.userInteractionEnabled = YES;
        label.layer.cornerRadius = 4;
        positionX += (btnWidth+5);
        
        if(positionX + btnWidth > bgViewWidth){
            label.alpha = 0;
        }
        
        [self.tagView addSubview:label];
    }
    
}

/*
 *获取文字所占宽度
 *@param text 文本内容，计算式包括了换行空格等
 *@param font 字体
 *@param height:指定高度下计算，若不设限使用CGFLOAT_MAX
 */
- (CGFloat)textWidth:(NSString *)text Font:(UIFont *)font height:(CGFloat)height
{
    if(!iOS7)
    {
        return [text sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, height) lineBreakMode:NSLineBreakByCharWrapping].width;
    }
    else{
        if(text.length <= 0)
        {
            return 0;
        }
        UITextView *textView = [[UITextView alloc]init];
        textView.text = text;
        textView.font = font;
        CGSize size = [textView sizeThatFits:CGSizeMake(CGFLOAT_MAX, height)];
        return size.width;
    }
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
        
    }
    return _tableView;
}

- (NSArray *)arrayFill{
    if (!_arrayFill) {
        _arrayFill = [NSArray array];
    }
    return _arrayFill;
}

- (UIImage *)img{
    if (!_img) {
        _img = [UIImage new];
    }
    return _img;
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
