//
//  TimeWeekViewController.m
//  Cyueyue
//
//  Created by fami_Lbb on 16/9/30.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import "TimeWeekViewController.h"
#define collectViewH 1400
#define collectViewX 48

@interface TimeWeekViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)NSArray *arrayAllTime;
@property (nonatomic,strong)NSArray *arrayTime;

@property (strong , nonatomic) NSIndexPath * m_lastAccessed;
//手势
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@end

@implementation TimeWeekViewController
static NSString * const reuseIdentifier = @"Cell";


//可滑动区域
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.scrollView.contentSize = CGSizeMake(0, collectViewH);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    view.backgroundColor = [UIColor whiteColor];
    self.view  = view;
    
    
    for (int i = 0; i < self.arrayTime.count; i++) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10 + i * 80, 40, 20)];
        label.text = self.arrayTime[i];
        label.font = [UIFont systemFontOfSize:14];
        [self.scrollView addSubview:label];
    }
    
    [self inputCollectionView];
    [self.scrollView addSubview:self.collectionView];
    [self.view addSubview:self.scrollView];

}

- (void)inputCollectionView{
    
    //设置布局实例对象
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    CGFloat W = (kScreen_Width - collectViewX - 10 - 6)/7;
    flowLayout.itemSize = CGSizeMake(W, 39);
    flowLayout.minimumLineSpacing = 1;
    flowLayout.minimumInteritemSpacing = 1;
    //flowLayout.sectionInset = UIEdgeInsetsMake(30, 20, 30, 20);
    
    //设置集合视图
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(collectViewX, 20,kScreen_Width - collectViewX - 5, collectViewH) collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    //编辑模式下允许多选
    collectionView.allowsMultipleSelection = YES;
    
    //集合视图注册
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    self.panGesture = panGesture;
    [collectionView addGestureRecognizer:panGesture];

    self.collectionView = collectionView;

}

-(void)panGesture:(UIGestureRecognizer*)gestureRecognizer
{
    float pointerX = [gestureRecognizer locationInView:self.collectionView].x;
        NSLog(@"pointerX = %f",pointerX);
    float pointerY = [gestureRecognizer locationInView:self.collectionView].y;
    
    NSLog(@"pointerY = %f",pointerY);

    
    for(UICollectionViewCell* cell1 in self.collectionView.visibleCells) {
        float cellLeftTop = cell1.frame.origin.x;
        //        NSLog(@"cellLeftTop = %f",cellLeftTop);
        float cellRightTop = cellLeftTop + cell1.frame.size.width;
        float cellLeftBottom = cell1.frame.origin.y;
        float cellRightBottom = cellLeftBottom + cell1.frame.size.height;
        
        if (pointerX >= cellLeftTop && pointerX <= cellRightTop && pointerY >= cellLeftBottom && pointerY <= cellRightBottom) {
            NSIndexPath* touchOver = [self.collectionView indexPathForCell:cell1];
            if (self.m_lastAccessed != touchOver) {
                
                cell1.backgroundColor = cTopicBlue;
                
                if (cell1.selected) {
                    [self deselectCellForCollectionView:self.collectionView atIndexPath:touchOver];
                }
                else
                {
                    [self selectCellForCollectionView:self.collectionView atIndexPath:touchOver];
                }
            }
            self.m_lastAccessed = touchOver;
        }
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        self.m_lastAccessed = nil;
        self.collectionView.scrollEnabled = YES;
    }
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = (UICollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    cell.backgroundColor = cTopicBlue;
    
    NSLog(@"indexPath.item = %ld",(long)indexPath.item);
}


/*Cell已经选择时回调*/
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = (UICollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];

}
/*Cell未选择时回调*/
-(void)selectCellForCollectionView:(UICollectionView*)collection atIndexPath:(NSIndexPath*)indexPath
{
    [collection selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    
    [self collectionView:collection didSelectItemAtIndexPath:indexPath];
    
}

-(void)deselectCellForCollectionView:(UICollectionView*)collection atIndexPath:(NSIndexPath*)indexPath
{
    [collection deselectItemAtIndexPath:indexPath animated:YES];
    [self collectionView:collection didDeselectItemAtIndexPath:indexPath];
    
}


//返回item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 238;
}

//返回分区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//返回item
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UICollectionViewCell *Cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    Cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return Cell;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}



- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        //        _scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        //不反弹
        _scrollView.bounces = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollEnabled = YES;
        _scrollView.userInteractionEnabled = YES;
    }
    return _scrollView;
}

- (NSArray *)arrayAllTime{
    if (!_arrayAllTime) {
        _arrayAllTime = @[@"7:00",@"7:30",@"8:00",@"8:30",@"9:00",@"9:30",@"10:00",@"10:30",@"11:00",@"11:30",@"12:00",@"12:30",@"13:00",@"13:30",@"14:00",@"14:30",@"15:00",@"15:30",@"16:00",@"16:30",@"17:00",@"17:30",@"18:00",@"18:30",@"19:00",@"19:30",@"20:00",@"20:30",@"21:00",@"21:30",@"22:00",@"22:30",@"23:00",@"23:30",@"24:00"];
    }
    return _arrayAllTime;
}

- (NSArray *)arrayTime{
    if (!_arrayTime) {
        _arrayTime = @[@"7:00",@"8:00",@"9:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00",@"19:00",@"20:00",@"21:00",@"22:00",@"23:00",@"24:00"];
    }
    return _arrayTime;
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
