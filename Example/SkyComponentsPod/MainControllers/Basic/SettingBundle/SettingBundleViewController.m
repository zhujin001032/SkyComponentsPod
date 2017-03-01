//
//  SettingBundleViewController.m
//  SkyComponentsPod
//
//  Created by Mark Yang on 3/30/16.
//  Copyright © 2016 Jason.He. All rights reserved.
//

#import "SettingBundleViewController.h"

typedef NS_ENUM(NSInteger, PreferenceKey) {
    PreferenceKey_Name = 0,
    PreferenceKey_Favorite,
    PreferenceKey_Marriage,
    PreferenceKey_Level,
    PreferenceKey_Count,
};

#pragma mark -

@interface SettingBundleViewController ()

@property (nonatomic, strong) NSUserDefaults *defaults;
@property (nonatomic, strong) UISwitch       *swMarried;
@property (nonatomic, strong) NSDictionary   *dicFavorite;

@end

#pragma mark -

@implementation SettingBundleViewController

- (void)dealloc
{
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter removeObserver:self];
}//

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self setTitle:@"设置目录"];
        _dicFavorite = @{@"football":@"足球",
                         @"basketball":@"篮球",
                         @"pingpong":@"乒乓球"};
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}//

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter addObserver:self
                   selector:@selector(handleAppEnterForegroundNotification:)
                       name:UIApplicationWillEnterForegroundNotification
                     object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)handleAppEnterForegroundNotification:(NSNotification *)noti
{
    [self.tableView reloadData];
}//

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return PreferenceKey_Count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:identifier];
    }
    [cell setAccessoryView:nil];

    NSString *strText = @"";
    NSString *strDetail = @"";
    switch (indexPath.row) {
        case PreferenceKey_Name: {
            strText = @"姓名";
            strDetail = [_defaults objectForKey:@"name_preference"];
            break;
        }
        case PreferenceKey_Favorite: {
            strText = @"爱好";
            strDetail = [_defaults objectForKey:@"favorite_preference"];
            if (strDetail.length < 1) {
                strDetail = @"football";
            }
            strDetail = _dicFavorite[strDetail];
            break;
        }
        case PreferenceKey_Marriage: {
            strText = @"婚姻状况";
            BOOL isMarried = [_defaults boolForKey:@"marriage_preference"];
            if (!_swMarried) {
                _swMarried = [[UISwitch alloc] init];
                [_swMarried addTarget:self
                               action:@selector(swMarriedValueChanged:)
                     forControlEvents:UIControlEventValueChanged];
            }
            [cell setAccessoryView:_swMarried];
            [_swMarried setOn:isMarried];
            
            break;
        }
        case PreferenceKey_Level: {
            strText = @"等级";
            NSString *strLV = [_defaults objectForKey:@"level_slider_preference"];
            strDetail = [NSString stringWithFormat:@"%@", @([strLV integerValue])];
//            NSInteger intLV = [_defaults integerForKey:@"level_slider_preference"];
//            strDetail = [NSString stringWithFormat:@"%@", @(intLV)];
            break;
        }
        default:
            break;
    }
    
    [cell.textLabel setText:strText];
    [cell.detailTextLabel setText:strDetail];
    
    return cell;
}

#pragma mark -

- (void)swMarriedValueChanged:(id)sender
{
    [_defaults setBool:_swMarried.on forKey:@"marriage_preference"];
}//

@end
