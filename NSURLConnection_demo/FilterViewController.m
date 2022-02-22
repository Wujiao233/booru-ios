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
    NSMutableArray * sizeArray;
    NSMutableArray * centArray;
    NSString * keyword_censore;
    NSString * keyword_ratting;
    NSString * keyword_sizetype;
    NSInteger heightLimit;
    NSInteger widthLimit;
    
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
    }else if(indexPath.section == 1){
        if(indexPath.row != 0){
            keyword_censore = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        }else{
            keyword_censore = @"";
        }
        [self refreshTagsKeyword];
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }else if(indexPath.section == 2){
        if(indexPath.row == 0){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改高度限制" message:@"Width:>=" preferredStyle:UIAlertControllerStyleAlert];
            //增加确定按钮；
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //获取第1个输入框；
                UITextField *textField = alertController.textFields.firstObject;
                NSLog(@"Tag = %@",textField.text);
                self->widthLimit = [textField.text integerValue];
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
                [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            }]];
            //增加取消按钮；
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
            //定义第一个输入框；
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"输入0禁用";
                textField.keyboardType = UIKeyboardTypeNumberPad;
            }];
            [self presentViewController:alertController animated:true completion:nil];
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改高度限制" message:@"Height:>=" preferredStyle:UIAlertControllerStyleAlert];
            //增加确定按钮；
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //获取第1个输入框；
                UITextField *textField = alertController.textFields.firstObject;
                NSLog(@"Tag = %@",textField.text);
                self->heightLimit = [textField.text integerValue];
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
                [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            }]];
            //增加取消按钮；
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
            //定义第一个输入框；
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"输入0禁用";
                textField.keyboardType = UIKeyboardTypeNumberPad;
            }];
            [self presentViewController:alertController animated:true completion:nil];
        }
    }else{
        if(indexPath.row != 0){
            keyword_sizetype = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        }else{
            keyword_sizetype = @"All";
        }
        [self refreshTagsKeyword];
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Filter"];
    ratingArray = [[NSMutableArray alloc]initWithObjects:@"1",@"0",@"0",@"0", nil];
    centArray = [[NSMutableArray alloc]initWithObjects:@"1",@"0",@"0", nil];
    sizeArray =[[NSMutableArray alloc]initWithObjects:@"1",@"0",@"0", nil];
//    keyword = [[AppDelegate getTags] lowercaseString];
    keyword_ratting = [AppDelegate getRating];
    keyword_censore = [AppDelegate getCensore];
    keyword_sizetype = [AppDelegate getSizeType];
    heightLimit = [AppDelegate getHeightLimit];
    widthLimit = [AppDelegate getWidthLimit];
    [self refreshTagsKeyword];
    [self drawTableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(refreshData)]];
    // Do any additional setup after loading the view.
    
}

-(void)refreshData{
    [AppDelegate setRating:keyword_ratting];
    [AppDelegate setCensore:keyword_censore];
    [AppDelegate setSizeType:keyword_sizetype];
    [AppDelegate setHeightLimit:heightLimit];
    [AppDelegate setWidthLimit:widthLimit];
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
    if(section == 0)return 4;
    if(section == 2)return 2;
    return 3;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
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
    
    for(int i=0;i<sizeArray.count;i++){
        sizeArray[i] = @"0";
    }
    
    if([keyword_sizetype isEqualToString:@"Width >= Height"]){
        sizeArray[1] = @"1";
    }else if([keyword_sizetype isEqualToString:@"Height > Width"]){
        sizeArray[2] = @"1";
    }else{
        sizeArray[0] = @"1";
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
            case 2:
                if(row == 0)cell.textLabel.text = [NSString stringWithFormat:@"Width:%@ %ldpx",@">=",self->widthLimit];
                if(row == 1)cell.textLabel.text = [NSString stringWithFormat:@"Height:%@ %ldpx",@">=",self->heightLimit];
                break;
            case 3:
                if(row == 0)cell.textLabel.text =  @"All";
                if(row == 1)cell.textLabel.text =  @"Width >= Height";
                if(row == 2)cell.textLabel.text =  @"Height > Width";
                if([sizeArray[row] isEqualToString:@"1"]){
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
            default:
                break;
        }
//    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return @"分级选择";
    }else if(section == 1){
        return @"审核";
    }else if(section == 2){
        return @"尺寸限制";
    }else{
        return @"宽高比较";
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
