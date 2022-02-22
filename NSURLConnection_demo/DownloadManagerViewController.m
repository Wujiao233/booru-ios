//
//  DownloadManagerViewController.m
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/7/21.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import "DownloadManagerViewController.h"
#import "HSDownloadManager.h"

#import "ReactiveCocoa/ReactiveCocoa.h"
#import "ReactiveView.h"
#import "MJRefresh.h"

static DownloadManagerViewModel *vm;

@interface DownloadManagerViewController () <UITableViewDelegate,UITableViewDataSource>{
    UITableViewCell *_templateCell;
}
@property (weak, nonatomic) IBOutlet UINavigationBar *_selfNavigationBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *_selfNavigationItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DownloadManagerViewController

+(DownloadManagerViewModel *)getDownloadManager{
    if(!vm){
        vm = [DownloadManagerViewModel new];
    }
    return vm;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [DownloadManagerViewController getDownloadManager];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self._selfNavigationBar.topItem.title = @"Download Manager";
    [self bindingTableView];
    [[HSDownloadManager sharedInstance]deleteAllFile];
    self._selfNavigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"清除所有" style:UIBarButtonItemStylePlain target:self action:@selector(doClean)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTable) name:@"needRefreshTable" object:nil];
    [self initMjRefresh];
}

-(void)initMjRefresh{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshTable)];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉刷新" forState: MJRefreshStateIdle];
    [header setTitle:@"松手刷新" forState: MJRefreshStatePulling];
    [header setTitle:@"刷新中" forState: MJRefreshStateRefreshing];
    self.tableView.mj_header = header;
}

-(void)refreshTable{
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}

-(void)doClean{
    vm.downloadingList = [NSArray new];
    [[HSDownloadManager sharedInstance]deleteAllFile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.tableView reloadData];
//    [vm addThingTo];
//    [vm download:@"http://att.bbs.duowan.com/forum/201209/19/231856wrv8v6pw8orhr0vb.jpg"];
}

-(void)bindingTableView{
    UINib *nib = [UINib nibWithNibName:@"DownloadBlockTableViewCell" bundle:nil];
    _templateCell = [[nib instantiateWithOwner:nil options:nil]firstObject];
    [self.tableView registerNib:nib forCellReuseIdentifier:_templateCell.reuseIdentifier];
    [RACObserve(vm, downloadingList) subscribeNext:^(id x) {
        [self.tableView reloadData];
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id<ReactiveView> cell = [tableView dequeueReusableCellWithIdentifier:_templateCell.reuseIdentifier];
    [cell bindViewModel:vm.downloadingList[indexPath.row]];
    return (UITableViewCell *)cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return vm.downloadingList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [vm deleteFileWithIndexPath:indexPath];
//    [self.viewModel deleteFamilyMemberByIndexPath:indexPath];
}

- (nullable NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [vm deleteFileWithIndexPath:indexPath];
    }];
    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"重新下载" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [vm restartFileDownloadWithIndexPath:indexPath];
    }];
    action2.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    return @[action,action2];
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
