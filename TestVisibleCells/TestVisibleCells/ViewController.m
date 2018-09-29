//
//  ViewController.m
//  TestVisibleCells
//
//  Created by niuyulong on 2018/9/29.
//  Copyright © 2018年 niuyulong. All rights reserved.
//  监听runloop [通过为RunLoop添加监听器, 查看RunLoop的运行](https://www.jianshu.com/p/7421a62376db)

#import "ViewController.h"
#import "TestTableView.h"
#import "TestCollectionView.h"



@interface ViewController () <
UITableViewDataSource,UITableViewDelegate,
UICollectionViewDelegate,UICollectionViewDataSource
>
@property(nonatomic, strong) TestTableView *tableView;
@property(nonatomic, strong) NSArray *data;
@property(nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ViewController
#pragma mark - Life Cycle 生命周期
#pragma mark └ Dealloc
// - (void)dealloc {}
#pragma mark └ Init
- (void)viewDidLoad {
    [super viewDidLoad];
    //     测试UITableView，则解开以下代码注释
    [self addTableView];
    
    //  测试UICollectionView，则解开以下代码注释
//    [self addCollectionView];
    
    [self addRunLoopObserver];
    NSLog(@"%@", [NSRunLoop currentRunLoop].currentMode); // 查看当前的RunLoop运行状态
    NSLog(@"%@",[NSThread currentThread]);
}

- (void)addTableView {
    self.tableView = [[TestTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.view sendSubviewToBack:self.tableView];
}
- (void)addCollectionView {
    [self.view addSubview:self.collectionView];
    [self.view sendSubviewToBack:self.collectionView];
}
#pragma mark - Event Response 事件响应
- (IBAction)btn:(id)sender {
    NSLog(@"%s",__func__);
    
    // 创建模拟数据
    NSInteger count = 1;//random() % 20;
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        [arrayM addObject:@(i)];
    }
    self.data = arrayM;

    if (self.tableView.superview) {
        [self testTableView];
    }
    else if (self.collectionView.superview) {
        [self testCollectionView];
    }
}

- (void)testTableView {
    
    [self.tableView reloadData];
    NSLog(@"reloadData 执行完成");
    
    NSArray *array = [self.tableView visibleCells];
    NSLog(@"visibleCells----:%@",@(array.count));
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *array = [self.tableView visibleCells];
        NSLog(@"visibleCells====:%@",@(array.count));
    });
}

- (void)testCollectionView {
    
    [self.collectionView reloadData];
    
    NSLog(@"reloadData 执行完成");
    NSLog(@"visibleCells---%@",@([self.collectionView visibleCells].count));
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger count = [self.collectionView visibleCells].count;
        NSLog(@"visibleCells===%@",@(count));
    });
    
    //    [self.collectionView layoutIfNeeded];
    //    NSLog(@"visibleCells三三三三%@",@([self.collectionView visibleCells].count));
}
#pragma mark - Delegate Realization 委托方法
#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"%s",__func__);
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%s",__func__);
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s",__func__);
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    // 增加渲染复杂度
    for (int i = 0; i<100; i++) {
        cell.contentView.layer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
        cell.contentView.layer.cornerRadius = i/10.0;
        cell.contentView.clipsToBounds = YES;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",@(indexPath.row)];
    NSLog(@"%s=====",__func__);
    return cell;
}

#pragma mark - CollectionView
#pragma mark └ UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor yellowColor];
    return cell;
}

#pragma mark └ UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 100);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

#pragma mark - Custom Method    自定义方法
#pragma mark └ RunLoop 时机监听
// 添加一个监听者
- (void)addRunLoopObserver {
    
    // 1. 创建监听者
    /**
     *  创建监听者
     *
     *  allocator  分配存储空间
     *  activities 要监听的状态
     *  repeats    是否持续监听
     *  order      优先级, 默认为0
     *  observer   观察者
     *  activity   监听回调的当前状态
     */
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        /*
         kCFRunLoopEntry = (1UL << 0),          进入工作
         kCFRunLoopBeforeTimers = (1UL << 1),   即将处理Timers事件
         kCFRunLoopBeforeSources = (1UL << 2),  即将处理Source事件
         kCFRunLoopBeforeWaiting = (1UL << 5),  即将休眠
         kCFRunLoopAfterWaiting = (1UL << 6),   被唤醒
         kCFRunLoopExit = (1UL << 7),           退出RunLoop
         kCFRunLoopAllActivities = 0x0FFFFFFFU  监听所有事件
         */
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"进入");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"即将处理Timer事件");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"即将处理Source事件");
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"即将休眠");
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"被唤醒");
                break;
            case kCFRunLoopExit:
                NSLog(@"退出RunLoop");
                break;
            default:
                break;
        }
    });
    
    // 2. 添加监听者
    /**
     *  给指定的RunLoop添加监听者
     *
     *  @param rl#>       要添加监听者的RunLoop
     *  @param observer#> 监听者对象
     *  @param mode#>     RunLoop的运行模式, 填写默认模式即可
     */
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
}

- (void)getCurrentRunLoopMode{
    // 每次定时器触发, 都去查看当前的RunLoop的运行mode
    NSLog(@"%@", [NSRunLoop currentRunLoop].currentMode);
}

#pragma mark - Custom Accessors 自定义属性
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10.0f;
        flowLayout.minimumInteritemSpacing = 0.0f;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[TestCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = self.view.backgroundColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollsToTop = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    }
    return _collectionView;
}
@end
