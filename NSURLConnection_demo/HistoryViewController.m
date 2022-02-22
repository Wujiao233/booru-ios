//
//  HistoryViewController.m
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/3/27.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import "HistoryViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"

@interface HistoryViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray * _dataArray;
    UITableView * _selfTable;
}
@property (weak, nonatomic) IBOutlet UINavigationBar *_selfNavigationBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *_selfNavigationItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation HistoryViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _dataArray =  [[NSUserDefaults standardUserDefaults]valueForKey:@"History"];
    [_selfTable reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawTableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self._selfNavigationBar.topItem.title = @"History";
    UIBarButtonItem * deleteBtn = [[UIBarButtonItem alloc]initWithTitle:@"DeleteAll" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAllBtnClick)];
    self.navigationItem.rightBarButtonItem = deleteBtn;
    self._selfNavigationItem.rightBarButtonItem = deleteBtn;
}

- (void)deleteAllBtnClick{
    _dataArray = @[];
    [[NSUserDefaults standardUserDefaults]setObject:_dataArray forKey:@"History"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [_selfTable reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [AppDelegate setTags:_dataArray[indexPath.row]];
    [self.tabBarController setSelectedIndex:0];
    [((ViewController *)((UINavigationController *)self.tabBarController.childViewControllers[0]).topViewController) doSearch];
}

-(void)drawTableView{
//    UITableView *tview = [[UITableView alloc] initWithFrame:CGRectMake(0,64,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
//    [self.view addSubview:tview];
    _selfTable = self.tableView;
    // tview.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  24)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}



@end
