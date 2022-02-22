//
//  TagsEditViewController.m
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/3/13.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import "TagsEditViewController.h"
#import "AppDelegate.h"

@interface TagsEditViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray * targetTags;
@property (nonatomic,strong) NSMutableArray * selfTags;

@end

@implementation TagsEditViewController

-(id)initWithDict:(NSArray *)dict{
    self = [super init];
    if(self){
        self.selfTags = [NSMutableArray new];
        self.targetTags = [NSMutableArray new];
        NSString * keyword = [AppDelegate getOriTags];
        NSArray * tmpArray = [keyword componentsSeparatedByString:@" "];
        for(int i=0;i<tmpArray.count;i++){
            if(![tmpArray[i]  isEqual: @""]){
                [self.selfTags addObject:tmpArray[i]];
            }
        }
        self.targetTags = [[NSMutableArray alloc]initWithArray:dict];
    }
    return self;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    // 删除的操作
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.selfTags removeObjectAtIndex:indexPath.row];
        NSArray *indexPaths = @[indexPath];
        [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:(UITableViewRowAnimationLeft)];
    }
    // 添加的操作
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        if(indexPath.section == 1){
            NSLog(@"手动添加");
            //添加的操作
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入Tag" preferredStyle:UIAlertControllerStyleAlert];
            //增加确定按钮；
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //获取第1个输入框；
                UITextField *userNameTextField = alertController.textFields.firstObject;
                NSLog(@"Tag = %@",userNameTextField.text);
                NSString * keyword = userNameTextField.text;
                NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF == %@", keyword];
                NSArray *results1 = [self.selfTags filteredArrayUsingPredicate:predicate1];
                if(results1.count <= 0){
                    [self.selfTags  addObject:keyword];
                    NSArray *indexPaths = @[ [NSIndexPath indexPathForRow:self.selfTags.count-1 inSection:0 ]];
                    [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:(UITableViewRowAnimationRight)];
                }
            }]];
            
            //增加取消按钮；
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
            
            //定义第一个输入框；
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"Tag";
            }];
            
            [self presentViewController:alertController animated:true completion:nil];
        }else{
            NSString * keyword = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
            NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF == %@", keyword];
            NSArray *results1 = [self.selfTags filteredArrayUsingPredicate:predicate1];
            if(results1.count <= 0){
                [self.selfTags  addObject:keyword];
                NSArray *indexPaths = @[ [NSIndexPath indexPathForRow:self.selfTags.count-1 inSection:0 ]];
                [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:(UITableViewRowAnimationRight)];
            }
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if(indexPath.section == 0){
//            }else{
//
//    }
    if(indexPath.section == 2){
        NSLog(@"手动添加");
        //添加的操作
    }
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Edit Tags"];
    [self drawTableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(refreshData)]];
    
    // Do any additional setup after loading the view.
}

-(void)refreshData{
    [AppDelegate setTags:[self.selfTags componentsJoinedByString:@" "]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)drawTableView{
    UITableView *tview = [[UITableView alloc] initWithFrame:CGRectMake(0,64,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStyleGrouped];
    [tview setDelegate:self];
    [tview setDataSource:self];
    [self.view addSubview:tview];
    tview.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  24)];
    [tview setEditing:YES animated:YES];
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) return UITableViewCellEditingStyleDelete;
    if(indexPath.section == 2) return UITableViewCellEditingStyleInsert;
    return UITableViewCellEditingStyleInsert;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0)return self.selfTags.count;
    else if(section == 2) return self.targetTags.count;
    return 1;
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
            cell.textLabel.text = self.selfTags[row];
            break;
        case 2:
            cell.textLabel.text = self.targetTags[row];
            break;
        case 1:
            cell.textLabel.text = @"手动输入";
            break;
        default:
            break;
    }
    //    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return @"当前Tags";
    }else if(section == 1){
        return @"手动添加";
    }
    return @"本图Tags";
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
