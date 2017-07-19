//
//  ViewController.m
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/3/4.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "SearchResultTableViewController.h"
#import "WaterFlowViewController.h"
#import "BooruNetwork.h"
#import "MBProgressHUD.h"
#import "SettingViewController.h"

@interface ViewController ()<UISearchResultsUpdating,UISearchBarDelegate,UITabBarControllerDelegate>{
    NSMutableData* __data;
    __weak IBOutlet UITextField *searchText;
}
@property (nonatomic, strong) UISearchController *searchController;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleTwoLabel;
@property (weak, nonatomic) IBOutlet UIButton *searchAll_Btn;
@property(nonatomic,strong)UIView *searchBarView;

@end

@implementation ViewController


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"Start Editing");
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@"End Editing");
}
- (IBAction)getAllPicsBtn_Click:(UIButton *)sender {
    [AppDelegate setTags:@" "];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BooruNetwork getPostFromServerWithTag:[AppDelegate getTags] Page:1 WithNotificationId:@"searchResult"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.titleLabel.text = [AppDelegate getSite];
//    self.tabBarController.tabBar.hidden = NO;
//    self.hidesBottomBarWhenPushed=NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.hidesBottomBarWhenPushed=YES;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
        self.hidesBottomBarWhenPushed=NO;
}

//UItabBar的切换事件
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController*)viewController
{
    CATransition *animation =[CATransition animation];
    [animation setDuration:0.35f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [animation setType:kCATransitionFade];
    [animation setSubtype:kCATransitionFromRight];
    [tabBarController.view.layer addAnimation:animation forKey:@"reveal"];
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSearchController];
    NSLog(@"Reg Notifaication!");
    self.definesPresentationContext = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initTableViewWithDict:) name:@"searchResult" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSearchResultFinished:) name:@"tagsSearch" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSearchBarKeyWord:) name:@"changeTags" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(changeFrames:)
//                                                 name:UIDeviceOrientationDidChangeNotification
//                                               object:nil];
    NSLog(@"Process Network Connection！！！");
    [self.tabBarController addChildViewController:[WaterFlowViewController new]];
    self.tabBarController.delegate = self;
    
    [self.titleLabel setFrame:CGRectMake(40, [UIScreen mainScreen].bounds.size.height / 2 - 80, [UIScreen mainScreen].bounds.size.width - 80, 44)];
    [self.titleTwoLabel setFrame:CGRectMake(40, [UIScreen mainScreen].bounds.size.height / 2 - 30, [UIScreen mainScreen].bounds.size.width - 80, 44)];
    [self.searchAll_Btn setFrame:CGRectMake(120, [UIScreen mainScreen].bounds.size.height / 2 + 20, [UIScreen mainScreen].bounds.size.width - 240, 24)];
    self.titleLabel.text = [AppDelegate getSite];
    
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self changeFrames:nil];
}

-(void)changeFrames:(NSNotification *)notification{
    if ([[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortrait
        || [[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortraitUpsideDown){
        NSLog(@"portrait");
        [self.searchBarView setFrame:CGRectMake(0,64,[UIScreen mainScreen].bounds.size.width,44)];
        [self.searchController.searchBar removeFromSuperview ];
        self.searchController.searchBar.frame=CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,44);
        [self.searchBarView addSubview:self.searchController.searchBar];
        //        self.frame=CGRectMake(0, 0, height, width);
        [AppDelegate setLineNumber:4];
    }
    else
    {
        NSLog(@"landscape");
        [self.searchBarView setFrame:CGRectMake(0,64,[UIScreen mainScreen].bounds.size.width,44)];
        [self.searchController.searchBar removeFromSuperview ];
        self.searchController.searchBar.frame=CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,44);
        [self.searchBarView addSubview:self.searchController.searchBar];
//        self.frame=CGRectMake(0, 0, width, height);
        [AppDelegate setLineNumber:6];
    }
    NSLog(@"view is %@",self);
    NSLog(@"%f,%f",[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
}


- (IBAction)TestBtn_Click:(UIButton *)sender {
    WaterFlowViewController * con = [WaterFlowViewController new];
    [self.navigationController pushViewController:con animated:YES];
}
-(void)changeSearchBarKeyWord:(NSNotification *)obj{
    NSString * str = (NSString *)obj.userInfo;
    NSString * keyword = self.searchController.searchBar.text;
    NSMutableArray * keyTemp =[NSMutableArray arrayWithArray:[keyword componentsSeparatedByString:@" "]] ;
    keyTemp[keyTemp.count -1] = str;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.searchController.searchBar.text = [NSString stringWithFormat:@"%@ ",[keyTemp componentsJoinedByString:@" "]];
    });
}

- (void)setText:(NSString *)str{
    searchText.text = str;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"Do Search");
    [AppDelegate setTags:self.searchController.searchBar.text];
    // [AppDelegate addHistory:[AppDelegate getOriTags]];
    [MBProgressHUD showHUDAddedTo:self.searchController.view animated:YES];
    [BooruNetwork getPostFromServerWithTag:[AppDelegate getTags] Page:1 WithNotificationId:@"searchResult"];
    
}

-(void)doSearch{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BooruNetwork getPostFromServerWithTag:[AppDelegate getTags] Page:1 WithNotificationId:@"searchResult"];
}

- (void)initSearchController{
    SearchResultTableViewController *resultTVC = [[SearchResultTableViewController alloc]init];
    UINavigationController *resultVC = [[UINavigationController alloc] initWithRootViewController:resultTVC];
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:resultVC];
    self.searchController.searchResultsUpdater = self;
    //self.searchController.dimsBackgroundDuringPresentation = NO;
    //self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.frame = CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,44);
    [_searchController.searchBar setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_searchController.searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0,64,[UIScreen mainScreen].bounds.size.width,44)];
    [searchBarView addSubview: _searchController.searchBar];
    self.searchBarView = searchBarView;
    //    _searchController.searchBar.frame = CGRectMake(0.0, 64.0 , ScreenWidth,44.0);
    [self.view addSubview:searchBarView];
//    [self.view addSubview:self.searchController.searchBar];
    self.searchController.searchBar.delegate = self;
    resultTVC.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1)];
    [self changeFrames:nil];
}

- (void)initTableViewWithDict:(NSNotification*)obj{
    NSMutableArray * dict = (NSMutableArray *)obj.userInfo;
    dispatch_async(dispatch_get_main_queue(), ^{
        WaterFlowViewController * con = [[WaterFlowViewController alloc]initWithDict:dict];
        con.isFromFilter = NO;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD hideHUDForView:self.searchController.view animated:YES];

        [self.navigationController pushViewController:con animated:YES];
        [self.searchController setActive:NO];
    });
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
//    UINavigationController *navController = (UINavigationController *)self.searchController.searchResultsController;
//    SearchResultTableViewController * resultVC = (SearchResultTableViewController *)navController.topViewController;
    NSLog(@"Update!!");
    NSString * keyword = searchController.searchBar.text;
    NSArray * keyTemp = [keyword componentsSeparatedByString:@" "];
    keyword = keyTemp[keyTemp.count -1];
    
    [BooruNetwork getTagInfoFromServerWithKey:keyword AndLimit:20 Code:@"tagsSearch"];
}

- (void)updateSearchResultFinished:(NSNotification *)obj{
    NSMutableArray * dict = (NSMutableArray *)obj.userInfo;
    UINavigationController *navController = (UINavigationController *)self.searchController.searchResultsController;
    SearchResultTableViewController * resultVC = (SearchResultTableViewController *)navController.topViewController;
    if(resultVC.resultsArray == nil){
        resultVC.resultsArray = [NSMutableArray new];
    }else{
        [resultVC.resultsArray removeAllObjects];
    }
    NSLog(@"%@",dict);

    for(int i=0;i<dict.count;i++){
        NSString * str =[NSString stringWithFormat:@"%@ -> %@",dict[i][@"tag"],dict[i][@"inch"]];
        [resultVC.resultsArray addObject:str];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [resultVC.tableView reloadData];
    });

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchBtn_Click:(UIButton *)sender {
    NSLog(@"Do Search");
    [AppDelegate setTags:searchText.text];
    [BooruNetwork getPostFromServerWithTag:[AppDelegate getTags] Page:1 WithNotificationId:@"searchResult"];
}


@end
