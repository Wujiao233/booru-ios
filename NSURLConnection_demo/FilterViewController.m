//
//  FilterViewController.m
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/3/13.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import "FilterViewController.h"
#import "AppDelegate.h"

@interface FilterViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray * ratingArray;
    NSMutableArray * centArray;
    NSString * keyword_censore;
    NSString * keyword_ratting;
    
}

@end

@implementation FilterViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(indexPath.row != 0){
            keyword_ratting = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        }else{
            keyword_ratting = @"";
        }
        [self refreshTagsKeyword];
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }else{
        if(indexPath.row != 0){
            keyword_censore = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        }else{
            keyword_censore = @"";
        }
        [self refreshTagsKeyword];
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Filter"];
    ratingArray = [[NSMutableArray alloc]initWithObjects:@"1",@"0",@"0",@"0", nil];
    centArray = [[NSMutableArray alloc]initWithObjects:@"1",@"0",@"0", nil];
//    keyword = [[AppDelegate getTags] lowercaseString];
    keyword_ratting = [AppDelegate getRating];
    keyword_censore = [AppDelegate getCensore];
    [self refreshTagsKeyword];
    [self drawTableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(refreshData)]];
    // Do any additional setup after loading the view.
    
}

-(void)refreshData{
    [AppDelegate setRating:keyword_ratting];
    [AppDelegate setCensore:keyword_censore];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)drawTableView{
    UITableView *tview = [[UITableView alloc] initWithFrame:CGRectMake(0,64,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStyleGrouped];
    [tview setDelegate:self];
    [tview setDataSource:self];
    [self.view addSubview:tview];
    tview.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  24)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 1)return 3;
    return 4;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (void)refreshTagsKeyword{
//    NSString * keywork = [AppDelegate getTags];
    for (int i=0; i<ratingArray.count; i++) {
        ratingArray[i] = @"0";
    }
    if([keyword_ratting isEqualToString:@"rating:safe"]){
        ratingArray[1] = @"1";
    }else if([keyword_ratting isEqualToString:@"rating:questionable"]){
        ratingArray[2] = @"1";
    }else if([keyword_ratting isEqualToString:@"rating:explicit"]){
        ratingArray[3] = @"1";
    }else{
        ratingArray[0] = @"1";
    }
    
    for(int i=0;i<centArray.count;i++){
        centArray[i] = @"0";
    }
    if([keyword_censore isEqualToString:@"uncensored"]){
        centArray[2] = @"1";
    }else if([keyword_censore isEqualToString:@"censored"]){
        centArray[1] = @"1";
    }else{
        centArray[0] = @"1";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    static NSString *CellIdentifier = @"Cell";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (section) {
            case 0:
                if(row == 0)cell.textLabel.text =  @"All";
                if(row == 1)cell.textLabel.text =  @"rating:safe";
                if(row == 2)cell.textLabel.text =  @"rating:questionable";
                if(row == 3)cell.textLabel.text =  @"rating:explicit";
                if([ratingArray[row] isEqualToString:@"1"]){
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                break;
            case 1:
                if(row == 0)cell.textLabel.text =  @"All";
                if(row == 1)cell.textLabel.text =  @"censored";
                if(row == 2)cell.textLabel.text =  @"uncensored";
                if([centArray[row] isEqualToString:@"1"]){
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                break;
            default:
                break;
        }
//    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return @"分级选择";
    }else{
        return @"审核";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 24;
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
