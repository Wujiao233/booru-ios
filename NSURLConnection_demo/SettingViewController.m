//
//  SettingViewController.m
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/3/14.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"
#import "SiteMethodMapper.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>{
//    NSMutableArray * siteArray;
}
@property (weak, nonatomic) IBOutlet UINavigationBar *_selfNavigationBar;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Setting"];
    self.title = @"Setting";   
    [self drawTableView];
    self._selfNavigationBar.topItem.title = @"Setting";
    //self.automaticallyAdjustsScrollViewInsets = NO;
//    siteArray = [[NSMutableArray alloc]initWithArray:@[@"1",@"0"]];
    // Do any additional setup after loading the view.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){
        [[NSUserDefaults standardUserDefaults]setObject:[tableView cellForRowAtIndexPath:indexPath].textLabel.text forKey:@"site"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [AppDelegate setSite:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
    }else if(indexPath.section == 1){
        [[NSUserDefaults standardUserDefaults]setObject:[tableView cellForRowAtIndexPath:indexPath].textLabel.text forKey:@"imageLevel"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [AppDelegate setImageLevel:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:[tableView cellForRowAtIndexPath:indexPath].textLabel.text forKey:@"limit"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [AppDelegate setLimit:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
    }
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    indexSet=[[NSIndexSet alloc]initWithIndex:2];
    [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];

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
    if(section == 0)return [[[SiteMethodMapper getSiteMethodMapper] getSiteMapKeys] count];
    if(section == 1)return 2;
    return 3;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (section) {
        case 0:
            cell.textLabel.text = [[SiteMethodMapper getSiteMethodMapper] getSiteMapKeys][row];
            // if(row == 0)cell.textLabel.text = @"Konachan";
            // if(row == 1)cell.textLabel.text = @"Gelbooru";
            // if(row == 2)cell.textLabel.text = @"Yande";
//            if([siteArray[row] isEqual:@"1"]){
//                cell.accessoryType = UITableViewCellAccessoryCheckmark;
//                [AppDelegate setSite:cell.textLabel.text];
//            }
            if([cell.textLabel.text isEqualToString:[AppDelegate getSite]]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        case 1:
            if(row == 0)cell.textLabel.text = @"Low";
            if(row == 1)cell.textLabel.text = @"High";
            if([cell.textLabel.text isEqualToString:[AppDelegate getImageLevel]]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        case 2:
            if(row == 0)cell.textLabel.text = @"20";
            if(row == 1)cell.textLabel.text = @"50";
            if(row == 2)cell.textLabel.text = @"100";
            if([cell.textLabel.text isEqualToString:[AppDelegate getLimit]]){
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
        return @"查询站点";
    }else if(section == 1){
        return @"预览质量";
    }else{
        return @"每页加载数量";
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
