//
//  SkyLandingPageTableViewController.m
//  SkyComponentsPod
//
//  Created by SimonLiu on 16/3/18.
//  Copyright © 2016年 Jason.He. All rights reserved.
//

#import "SkyLandingPageTableViewController.h"
#import "SkyADLandingPageView.h"
#import "FirstPageViewController.h"


@interface SkyLandingPageTableViewController ()

@property (nonatomic, strong) NSArray *arrLandingPageTypes;

@end

@implementation SkyLandingPageTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    _arrLandingPageTypes = @[NSLocalizedString(@"静态广告", nil),
                             NSLocalizedString(@"滑动引导", nil),
                             NSLocalizedString(@"动态图片", nil)];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrLandingPageTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"Identify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _arrLandingPageTypes[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FirstPageViewController *firstPageVC = [[FirstPageViewController alloc] init];
    switch (indexPath.row) {
        case 0:
            firstPageVC.landingPageType = LandingPageTypeAD;
            break;
        case 1:
            firstPageVC.landingPageType = LandingPageTypeScroll;
            break;
        case 2:
            firstPageVC.landingPageType = LandingPageTypeGIF;
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:firstPageVC animated:YES];
}


@end
