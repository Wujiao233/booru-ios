//
//  WaterFlowViewController.m
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/3/6.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import "WaterFlowViewController.h"
#import "BGWaterFlowView.h"
#import "BGCollectionViewCell.h"
#import "AppDelegate.h"
#import "HUPhotoBrowser.h"
#import "FilterViewController.h"
#import "MBProgressHUD.h"
#import "TagsEditViewController.h"
#import "BooruNetwork.h"
#import <SVProgressHUD/SVProgressHUD.h>

static const CGFloat delayTiemSecond = 3.0;
//static const NSInteger BGPageCount = 100;
static NSString * const BGCollectionCellIdentify = @"BGCollectionCellIdentify";

@interface WaterFlowViewController () <BGWaterFlowViewDataSource, BGRefreshWaterFlowViewDelegate>{
    BGRefreshWaterFlowView *waterFlowViewLocal;
}
//@property (nonatomic, strong) BGWaterFlowView *waterFlowView;
@property (nonatomic, strong) NSArray *dataArr;
/**
 *  源数据
 */
@property (nonatomic, strong) NSMutableArray *sourceArr; //URL
@property (nonatomic, strong) NSMutableArray *dataList; //Sample_URL
@property (nonatomic, strong) NSMutableDictionary *cellHeightDic; //
@property (nonatomic, strong) NSMutableArray *sourceWidth;
@property (nonatomic, strong) NSMutableArray *sourceHeight;
@property (nonatomic, strong) NSMutableArray *sourceTags;
@property (nonatomic, strong) NSMutableArray *fileSize; //Size
@property (nonatomic, assign) int page;


@end

@implementation WaterFlowViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (![[self.navigationController viewControllers] containsObject:self])
    {
        NSLog(@"用户点击了返回按钮");
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.hidesBottomBarWhenPushed=YES;
}

-(CGFloat)getStateBarHeight{
    return [[UIApplication sharedApplication] statusBarFrame].size.height +self.navigationController.navigationBar.frame.size.height;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(self.isFromFilter == YES){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self loadNewRefreshData:waterFlowViewLocal];
        self.isFromFilter = NO;
        self.title = [AppDelegate getOriTags];
    }
}

-(Boolean)checkSizeTypeWithWidth:(double)width AndHeight:(double)height{
    if([[AppDelegate getSizeType] isEqualToString:@"Height > Width"]){
        if(height > width){
            return true;
        }
        return false;
    }else if([[AppDelegate getSizeType] isEqualToString:@"Width >= Height"]){
        if(width >= height){
            return true;
        }
        return false;
    }
    return true;
}

-(id)initWithDict:(NSMutableArray *)dict{
    if ( self = [super init] ){
        self.sourceArr = [NSMutableArray new];
        self.sourceWidth =  [NSMutableArray new];
        self.sourceHeight =  [NSMutableArray new];
        self.dataList =  [NSMutableArray new];
        self.cellHeightDic = [NSMutableDictionary new];
        self.sourceTags = [NSMutableArray new];
        self.fileSize = [NSMutableArray new];
        for(int i=0;i<dict.count;i++){
            if(![self checkSizeTypeWithWidth:[[NSString stringWithFormat:@"%@",dict[i][@"actual_preview_width"]] doubleValue] AndHeight:[[NSString stringWithFormat:@"%@",dict[i][@"actual_preview_height"]] doubleValue]]){
                continue;
            }
            if([dict[i][@"file_url"] hasPrefix:@"http"]){
                [self.sourceArr addObject:[NSString stringWithFormat:@"%@",dict[i][@"file_url"]]];
            }else{
                [self.sourceArr addObject:[NSString stringWithFormat:@"http:%@",dict[i][@"file_url"]]];
            }
            if([dict[i][@"preview_url"] hasPrefix:@"http"]){
                [self.dataList addObject:[NSString stringWithFormat:@"%@",dict[i][@"preview_url"]]];
            }else{
                [self.dataList addObject:[NSString stringWithFormat:@"http:%@",dict[i][@"preview_url"]]];
            }
            [self.sourceWidth addObject:dict[i][@"actual_preview_width"]];
            [self.sourceHeight addObject:dict[i][@"actual_preview_height"]];
            [self.sourceTags addObject:dict[i][@"tags"]];
            [self.fileSize addObject:dict[i][@"file_size"]];
        }
    }
    NSLog(@"%@",self.fileSize);
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [AppDelegate getOriTags];
    self.page = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewRefreshDataFinished:) name:@"waterFlow" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMoreRefreshDataFinished:) name:@"waterFlowMore" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTagsInfo:) name:@"needShowTags" object:nil];
    waterFlowViewLocal = [[BGRefreshWaterFlowView alloc] initWithFrame:CGRectMake(0,[self getStateBarHeight], self.view.bounds.size.width, self.view.bounds.size.height - [self getStateBarHeight])];
    UIBarButtonItem * tagsButton = [[UIBarButtonItem alloc]initWithTitle:@"Tags" style:UIBarButtonItemStylePlain target:self action:@selector(showTagsInfo)];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc]initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(barRightButton_Click)];
    self.navigationItem.rightBarButtonItems = @[barButton,tagsButton];
    //设置代理
    waterFlowViewLocal.dataSource = self;
    waterFlowViewLocal.delegate = self;
    //设置瀑布流列数
    waterFlowViewLocal.columnNum = [AppDelegate getLineNumber];
    //设置cell与cell之间的水平间距
    waterFlowViewLocal.horizontalItemSpacing = 10;
    //设置cell与cell之间的垂直间距
    waterFlowViewLocal.verticalItemSpacing = 10;
    waterFlowViewLocal.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.view addSubview:waterFlowViewLocal];
    //注册Cells
    [waterFlowViewLocal registerClass:[BGCollectionViewCell class] forCellWithReuseIdentifier:BGCollectionCellIdentify];
    
    
    [self performSelector:@selector(finishLoading) withObject:waterFlowViewLocal afterDelay:0.3];
    
    
    
    // Do any additional setup after loading the view.
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self changeFrames:nil];
}

-(void)changeFrames:(NSNotification *)notification{
    NSString *device = [[UIDevice currentDevice].model substringToIndex:4];
    if ([device isEqualToString:@"iPho"]){
        if ([[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortrait
            || [[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortraitUpsideDown){
            NSLog(@"portrait");
            [AppDelegate setLineNumber:2];
            [waterFlowViewLocal setFrame:CGRectMake(0,[self getStateBarHeight], self.view.bounds.size.height, self.view.bounds.size.width - [self getStateBarHeight])];
            waterFlowViewLocal.columnNum = [AppDelegate getLineNumber];
            [waterFlowViewLocal reloadData];
        }
        else
        {
            NSLog(@"landscape");
            [AppDelegate setLineNumber:4];
            [waterFlowViewLocal setFrame:CGRectMake(0,[self getStateBarHeight] - 44, self.view.bounds.size.height, self.view.bounds.size.width - [self getStateBarHeight] + 44)];
            waterFlowViewLocal.columnNum = [AppDelegate getLineNumber];
            [waterFlowViewLocal reloadData];
        }
        NSLog(@"view is %@",self);
        NSLog(@"%f,%f",[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
    }else{
        if ([[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortrait
            || [[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortraitUpsideDown){
            NSLog(@"portrait");
            [AppDelegate setLineNumber:4];
            [waterFlowViewLocal setFrame:CGRectMake(0,[self getStateBarHeight], self.view.bounds.size.height, self.view.bounds.size.width - [self getStateBarHeight])];
            waterFlowViewLocal.columnNum = [AppDelegate getLineNumber];
            [waterFlowViewLocal reloadData];
        }
        else
        {
            NSLog(@"landscape");
            [AppDelegate setLineNumber:6];
            [waterFlowViewLocal setFrame:CGRectMake(0,[self getStateBarHeight], self.view.bounds.size.height, self.view.bounds.size.width - [self getStateBarHeight])];
            waterFlowViewLocal.columnNum = [AppDelegate getLineNumber];
            [waterFlowViewLocal reloadData];
        }
        NSLog(@"view is %@",self);
        NSLog(@"%f,%f",[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
    }
    
}

-(void)showTagsInfo{
    //没有图片的情况
    if([self.sourceArr count] <= 0){
        NSString *msg = @"没有找到Tag";
        [SVProgressHUD showInfoWithStatus:msg];
    }else{
        NSInteger index = arc4random() % self.sourceTags.count;
        NSArray * tmpArray = [self.sourceTags[index] componentsSeparatedByString:@" "];
        TagsEditViewController * con = [[TagsEditViewController alloc]initWithDict:tmpArray];
        self.isFromFilter = YES;
        [self.navigationController pushViewController:con animated:YES];
    }
}

-(void)showTagsInfo:(NSNotification*)obj{
    NSDictionary * dict = obj.userInfo;
    NSInteger index = [dict[@"index"] intValue];
//    NSLog(@"%@",self.sourceTags[index]);
    NSArray * tmpArray = [self.sourceTags[index] componentsSeparatedByString:@" "];
    TagsEditViewController * con = [[TagsEditViewController alloc]initWithDict:tmpArray];
    self.isFromFilter = YES;
    [self.navigationController pushViewController:con animated:YES];
}

- (void)barRightButton_Click{
    self.isFromFilter = YES;
    FilterViewController * con = [FilterViewController new];
    [self.navigationController pushViewController:con animated:YES];
}

#pragma mark - BGWaterFlowViewDataSource
- (NSInteger)waterFlowView:(BGWaterFlowView *)waterFlowView numberOfItemsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UICollectionViewCell *)waterFlowView:(BGWaterFlowView *)waterFlowView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BGCollectionViewCell *cell = [waterFlowView dequeueReusableCellWithReuseIdentifier:BGCollectionCellIdentify forIndexPath:indexPath];
    cell.urlStr = self.dataList[indexPath.row];
//    cell.urlStr = @"https://www.baidu.com/img/baidu_jgylogo3.gif";
    [cell setNeedsLayout];
    return cell;
}

- (CGFloat)waterFlowView:(BGWaterFlowView *)waterFlowView heightForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *heightNumber = self.cellHeightDic[indexPath];
    if(heightNumber){
        return heightNumber.floatValue;
    }
    else{
        CGFloat cellHeight =[self.sourceHeight[indexPath.row] intValue] / ([self.sourceWidth[indexPath.row] intValue] / [self returnPictureMaxWidth]);
        self.cellHeightDic[indexPath] = @(cellHeight * 2 / [AppDelegate getLineNumber]);
        return cellHeight * 2 / [AppDelegate getLineNumber];
    }
}

- (void)waterFlowView:(BGWaterFlowView *)waterFlowView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@", indexPath);
    BGCollectionViewCell *cell = [waterFlowView dequeueReusableCellWithReuseIdentifier:BGCollectionCellIdentify forIndexPath:indexPath];
    cell.urlStr = self.dataList[indexPath.row];
    [cell setNeedsLayout];
//    NSString * url = [NSString stringWithFormat:@"http:%@",self.sourceArr[indexPath.row]];

//    [HUPhotoBrowser showFromImageView:nil withURLStrings:self.sourceArr placeholderImage:[UIImage imageNamed:@"placeholder"] atIndex:indexPath.row dismiss:nil];
    [HUPhotoBrowser showFromImageView:nil withURLStrings:self.sourceArr fileSize:self.fileSize placeholderImage:[UIImage imageNamed:@"placeholder"] atIndex:indexPath.row dismiss:nil];
}

#pragma mark - BGRefreshWaterFlowViewDelegate method
- (void)pullDownWithRefreshWaterFlowView:(BGRefreshWaterFlowView *)refreshWaterFlowView{
    [self performSelector:@selector(loadNewRefreshData:) withObject:refreshWaterFlowView afterDelay:delayTiemSecond];
}

- (void)pullUpWithRefreshWaterFlowView:(BGRefreshWaterFlowView *)refreshWaterFlowView {
    [self performSelector:@selector(loadMoreRefreshData:) withObject:refreshWaterFlowView afterDelay:delayTiemSecond];
}

- (void)loadNewRefreshData :(BGRefreshWaterFlowView *)refreshWaterFlowView{
    self.page = 1;
    [BooruNetwork getPostFromServerWithTag:[AppDelegate getTags] Page:1 WithNotificationId:@"waterFlow"];
}

-(void)loadNewRefreshDataFinished:(NSNotification*)obj{
    NSMutableArray * dict = (NSMutableArray *)obj.userInfo;
    [self.sourceArr removeAllObjects];
    [self.dataList removeAllObjects];
    [self.cellHeightDic removeAllObjects];
    [self.sourceTags removeAllObjects];
    [self.sourceWidth removeAllObjects];
    [self.sourceHeight removeAllObjects];
    for(int i=0;i<dict.count;i++){
        if(![self checkSizeTypeWithWidth:[[NSString stringWithFormat:@"%@",dict[i][@"actual_preview_width"]] doubleValue] AndHeight:[[NSString stringWithFormat:@"%@",dict[i][@"actual_preview_height"]] doubleValue]]){
             continue;
        }
        if([dict[i][@"file_url"] hasPrefix:@"http"]){
            [self.sourceArr addObject:[NSString stringWithFormat:@"%@",dict[i][@"file_url"]]];
        }else{
            [self.sourceArr addObject:[NSString stringWithFormat:@"http:%@",dict[i][@"file_url"]]];
        }
        if([dict[i][@"preview_url"] hasPrefix:@"http"]){
            [self.dataList addObject:[NSString stringWithFormat:@"%@",dict[i][@"preview_url"]]];
        }else{
            [self.dataList addObject:[NSString stringWithFormat:@"http:%@",dict[i][@"preview_url"]]];
        }
//        [self.sourceArr addObject:[NSString stringWithFormat:@"http:%@",dict[i][@"file_url"]]];
//        [self.dataList addObject:[NSString stringWithFormat:@"http:%@",dict[i][@"preview_url"]]];
        [self.sourceWidth addObject:dict[i][@"actual_preview_width"]];
        [self.sourceHeight addObject:dict[i][@"actual_preview_height"]];
        [self.sourceTags addObject:dict[i][@"tags"]];
        [self.fileSize addObject:dict[i][@"file_size"]];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [waterFlowViewLocal reloadData];
        [waterFlowViewLocal pullDownDidFinishedLoadingRefresh];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

-(void)finishLoading{
//    [waterFlowViewLocal reloadData];
    [waterFlowViewLocal pullDownDidFinishedLoadingRefresh];
}

-(CGFloat)returnPictureMaxWidth{
    return ([UIScreen mainScreen].bounds.size.width - (waterFlowViewLocal.columnNum-1)*waterFlowViewLocal.verticalItemSpacing)/2 -waterFlowViewLocal.contentInset.left - waterFlowViewLocal.contentInset.right;
}

- (void)loadMoreRefreshData:(BGRefreshWaterFlowView *)refreshWaterFlowView {
    self.page ++;
    [BooruNetwork getPostFromServerWithTag:[AppDelegate getTags] Page:self.page WithNotificationId:@"waterFlowMore"];
}

-(void)loadMoreRefreshDataFinished:(NSNotification*)obj{
    NSMutableArray * dict = (NSMutableArray * )obj.userInfo;
    if(dict.count == 0){
        waterFlowViewLocal.isLoadMore = NO;
    }else {
        waterFlowViewLocal.isLoadMore = YES;
    }
    for(int i=0;i<dict.count;i++){
        if(![self checkSizeTypeWithWidth:[[NSString stringWithFormat:@"%@",dict[i][@"actual_preview_width"]] doubleValue] AndHeight:[[NSString stringWithFormat:@"%@",dict[i][@"actual_preview_height"]] doubleValue]]){
             continue;
        }
        if([dict[i][@"file_url"] hasPrefix:@"http"]){
            [self.sourceArr addObject:[NSString stringWithFormat:@"%@",dict[i][@"file_url"]]];
        }else{
            [self.sourceArr addObject:[NSString stringWithFormat:@"http:%@",dict[i][@"file_url"]]];
        }
        if([dict[i][@"preview_url"] hasPrefix:@"http"]){
            [self.dataList addObject:[NSString stringWithFormat:@"%@",dict[i][@"preview_url"]]];
        }else{
            [self.dataList addObject:[NSString stringWithFormat:@"http:%@",dict[i][@"preview_url"]]];
        }
//        [self.sourceArr addObject:[NSString stringWithFormat:@"http:%@",dict[i][@"file_url"]]];
//        [self.dataList addObject:[NSString stringWithFormat:@"http:%@",dict[i][@"preview_url"]]];
        [self.sourceWidth addObject:dict[i][@"actual_preview_width"]];
        [self.sourceHeight addObject:dict[i][@"actual_preview_height"]];
        [self.sourceTags addObject:dict[i][@"tags"]];
        [self.fileSize addObject:dict[i][@"file_size"]];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [waterFlowViewLocal reloadData];
        [waterFlowViewLocal pullUpDidFinishedLoadingMore];
    });
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
