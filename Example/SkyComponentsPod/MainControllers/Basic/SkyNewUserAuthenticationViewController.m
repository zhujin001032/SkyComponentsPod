//
//  SkyNewUserAuthenticationViewController.m
//  SkyComponentsPod
//
//  Created by 何助金 on 16/3/18.
//  Copyright © 2016年 Jason.He. All rights reserved.
//


#import "SkyNewUserAuthenticationViewController.h"

@interface SkyNewUserAuthenticationViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSArray *_dataArray;
    UITextField *_passwordField;
    UITextField *_nameField;
}
@end


@implementation SkyNewUserAuthenticationViewController
static NSString *kUserName  = @"UserName";
static NSString *kPassword  = @"Password";
static NSString *kService   = @"com.msinner.components";
- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataArray = @[@"First install？",@"User Name:",@"Password:"];

    [self addTableView];
    [self addTableViewHeadView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (![SSKeychain passwordForService:kService account:@"UUID"]) {
        NSString *uuidString = [[NSUUID UUID] UUIDString];
        [SSKeychain setPassword:uuidString forService:kService account:@"UUID"];
        
    }
}

- (void) addTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0 ,SCREEN_WIDTH, SCREEN_HEIGHT- 64) style:UITableViewStylePlain];
    
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = [UIColor grayColor];
    [self.view addSubview:_tableView];
}

- (void)addTableViewHeadView
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 115)];
    headView.backgroundColor = [UIColor colorWithWhite:0.741 alpha:1.000];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 100, 30)];
    nameLabel.text = NSLocalizedString(@"User Name:", nil);
    [headView addSubview:nameLabel];
    
    _nameField = [[UITextField alloc]initWithFrame:CGRectMake( nameLabel.mkMaxX + 5, nameLabel.mkY, SCREEN_WIDTH - nameLabel.mkMaxX  - 20, 30)];
    _nameField.borderStyle = UITextBorderStyleRoundedRect;
    [headView addSubview:_nameField];
    
    UILabel *passwordLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, nameLabel.mkMaxY + 5, 100, 30)];
    passwordLabel.text = NSLocalizedString(@"Password:", nil);
    [headView addSubview:passwordLabel];
    
    _passwordField = [[UITextField alloc]initWithFrame:CGRectMake( passwordLabel.mkMaxX + 5, passwordLabel.mkY, SCREEN_WIDTH - passwordLabel.mkMaxX  - 20, 30)];
    _passwordField.borderStyle = UITextBorderStyleRoundedRect;
    [headView addSubview:_passwordField];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(SCREEN_WIDTH - 120, passwordLabel.mkMaxY + 8,  100, 30);
    [saveButton setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
    [saveButton setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor colorWithRed:0.437 green:0.455 blue:0.439 alpha:1.000] forState:UIControlStateHighlighted];
    saveButton.backgroundColor = [UIColor colorWithRed:0.117 green:0.585 blue:1.000 alpha:1.000];
    [saveButton addTarget: self action:@selector(saveButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    saveButton.layer.cornerRadius = 5.0;
    saveButton.layer.masksToBounds = YES;
    [headView addSubview:saveButton];
    
    UIButton *cleanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cleanButton.frame = CGRectMake(20, passwordLabel.mkMaxY + 8,  100, 30);
    [cleanButton setTitle:NSLocalizedString(@"Clean", nil) forState:UIControlStateNormal];
    [cleanButton setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [cleanButton setTitleColor:[UIColor colorWithRed:0.437 green:0.455 blue:0.439 alpha:1.000] forState:UIControlStateHighlighted];
    cleanButton.backgroundColor = [UIColor colorWithRed:0.117 green:0.585 blue:1.000 alpha:1.000];
    [cleanButton addTarget: self action:@selector(cleanButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    cleanButton.layer.cornerRadius = 5.0;
    cleanButton.layer.masksToBounds = YES;
    [headView addSubview:cleanButton];

    
    _tableView.tableHeaderView = headView;
    
}

- (void)saveButtonPress:(UIButton *)sender
{
    
    if (_nameField.text.length && _passwordField.text.length) {
        [SSKeychain setPassword:_nameField.text forService:kService account:kUserName];
        [SSKeychain setPassword:_passwordField.text forService:kService account:kPassword];
        _nameField.text = nil;
        _passwordField.text = nil;
        [self.view endEditing:YES];
        [_tableView reloadData];
    }
    
}

- (void)cleanButtonPress:(UIButton *)sender
{
    [SSKeychain deletePasswordForService:kService account:kPassword];
    [SSKeychain deletePasswordForService:kService account:kUserName];
    _nameField.text = nil;
    _passwordField.text = nil;
    [self.view endEditing:YES];
    [_tableView reloadData];

}

#pragma mark -tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    
    switch (indexPath.row) {
        case 0:{
            if ([SSKeychain passwordForService:kService account:@"UUID"]) {
                cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"NO, UUID :%@", nil), [SSKeychain passwordForService:kService account:@"UUID"]];
            }else
            {
                cell.detailTextLabel.text = NSLocalizedString(@"YES.", nil);
            }
        }
            break;
        case 1:{
            if ([SSKeychain passwordForService:kService account:kUserName]) {
                cell.detailTextLabel.text = [SSKeychain passwordForService:kService account:kUserName];
            }else
            {
                cell.detailTextLabel.text = NSLocalizedString(@"NOT SET", nil);
            }
        }
            break;
        case 2:{
            if ([SSKeychain passwordForService:kService account:kPassword]) {
                cell.detailTextLabel.text = [SSKeychain passwordForService:kService account:kPassword];
            }else
            {
                cell.detailTextLabel.text = NSLocalizedString(@"NOT SET", nil);
            }

        }
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
