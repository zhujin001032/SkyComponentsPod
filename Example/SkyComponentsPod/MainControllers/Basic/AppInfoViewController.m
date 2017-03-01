//
//  AppInfoViewController.m
//  SkyComponentsPod
//
//  Created by Mark Yang on 3/17/16.
//  Copyright © 2016 Jason.He. All rights reserved.
//

#import "AppInfoViewController.h"
#import "SVProgressHUD.h"

#define SkyComponentsAppID @"492840294"

static NSString *kTitleKey = @"title";
static NSString *kValueKey = @"value";
static CGFloat kCellHeight = 60.0;

@interface AppInfoViewController () <UISearchBarDelegate,
                                     UISearchControllerDelegate,
                                     UISearchResultsUpdating>

@property (nonatomic, strong) AppInfoManager *appInfoManager;
@property (nonatomic, strong) __block NSDictionary *dicInfo;
@property (nonatomic, strong) NSArray        *arrInfo;
// For Search
@property (nonatomic, strong) NSString              *strAppID;
@property (nonatomic, strong) UISearchController    *searchController;
@property (nonatomic, strong) UITableViewController *searchResultController;

@end

@implementation AppInfoViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self initData];
    }
    
    return self;
}//

- (void)initData
{
    _arrInfo = @[@{kTitleKey:@"APP名称", kValueKey:@"trackCensoredName"},
                 @{kTitleKey:@"分类", kValueKey:@"primaryGenreName"},
                 @{kTitleKey:@"官方首页", kValueKey:@"sellerUrl"},
                 @{kTitleKey:@"货币单位", kValueKey:@"currency"},
                 @{kTitleKey:@"安装包大小(Byte)", kValueKey:@"fileSizeBytes"},
                 @{kTitleKey:@"AppStorep安装包版本", kValueKey:@"version"},
                 @{kTitleKey:@"最新发布日期", kValueKey:@"releaseDate"},
                 @{kTitleKey:@"iOS系统版本最低要求", kValueKey:@"minimumOsVersion"},
                 @{kTitleKey:@"用户年龄最低要求", kValueKey:@"trackContentRating"}];
}//

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadSearchBar];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)loadSearchBar
{
    _searchResultController = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [_searchResultController.tableView setDataSource:self];
    [_searchResultController.tableView setDelegate:self];
    
    _searchController = [[UISearchController alloc] initWithSearchResultsController:_searchResultController];
    [_searchController setSearchResultsUpdater:self];
    [_searchController setDelegate:self];
    [_searchController.searchBar setDelegate:self];
    [_searchController.searchBar sizeToFit];
    [_searchController.searchBar setPlaceholder:@"Input APP ID Like : 492840294"];
    [_searchController.searchBar setText:SkyComponentsAppID];   // For DEBUG
    [_searchController setDimsBackgroundDuringPresentation:NO]; // default is YES
    [self.tableView setTableHeaderView:_searchController.searchBar];
    
    [self setDefinesPresentationContext:YES];
}//

- (void)fetchAppInfo
{
//    NSString *appID = SkyComponentsAppID;
    NSString *appID = _strAppID;
    _appInfoManager = [AppInfoManager sharedManager];
    NSLog(@"======开始从AppStore上获取指定App相关信息======");
    __weak AppInfoViewController *weakSelf = self;
    [SVProgressHUD showWithStatus:@"loading..."];
    [_appInfoManager requestAppVersionInfoInAppStoreWithAppID:appID
                                               withErrorBlock:^(NSError *aError) {
                                                   NSLog(@"Get AppInfo From AppStore Error : %@", aError);
                                                   [SVProgressHUD showErrorWithStatus:[aError localizedDescription]];
                                               }
                                              withFinishBlock:^(NSDictionary *aDicInfo, NSError *aError) {
                                                  if (!aError) {
                                                      NSLog(@"AppInfo : %@", aDicInfo);
                                                      if (aDicInfo[@"results"] && [aDicInfo[@"results"] count] > 0) {
                                                          [weakSelf setDicInfo:aDicInfo[@"results"][0]];
                                                          [weakSelf.tableView reloadData];
                                                          [SVProgressHUD dismiss];
                                                      }
                                                      else {
                                                          [SVProgressHUD showErrorWithStatus:@"未获取到有效信息"];
                                                      }
                                                  }
                                                  else {
                                                      NSLog(@"Get AppInfo From AppStore Error : %@", aError);
                                                      [SVProgressHUD showErrorWithStatus:[aError localizedDescription]];
                                                  }
                                              }];
}//

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:identifier];
    }
    NSString *strTitle= _arrInfo[indexPath.row][kTitleKey];
    [cell.textLabel setText:strTitle];
    if (_dicInfo) {
        NSString *strDetail = _dicInfo[_arrInfo[indexPath.row][kValueKey]];
        [cell.detailTextLabel setText:strDetail];
    }
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}//

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}//

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *strAppID = searchBar.text;
    if (strAppID.length < 1) {
        [searchBar resignFirstResponder];
        
        return;
    }
    _strAppID = strAppID;
    [self fetchAppInfo];
    [searchBar resignFirstResponder];
    [_searchController setActive:NO];
}//

#pragma mark -
#pragma mark UISearchControllerDelegate

- (void)presentSearchController:(UISearchController *)searchController {
    
}

- (void)willPresentSearchController:(UISearchController *)searchController {
    // do something before the search controller is presented
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    // do something after the search controller is presented
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    // do something before the search controller is dismissed
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    // do something after the search controller is dismissed
}

#pragma mark -
#pragma mark UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSLog(@"Text Changed Updating");
    return;
}

@end
