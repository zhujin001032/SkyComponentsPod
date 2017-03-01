//
//  OperationAnalyticViewController.m
//  SkyComponentsPod
//
//  Created by Mark Yang on 4/5/16.
//  Copyright © 2016 Jason.He. All rights reserved.
//

#import "OperationAnalyticViewController.h"
#import "SVProgressHUD.h"

static NSString *kEventID   = @"EventID";
static NSString *kEventName = @"EventName";

typedef NS_ENUM(NSInteger, EventID) {
    EventID_One = 0,
    EventID_Two,
    EventID_Three,
    EventID_Count,
};

@interface OperationAnalyticViewController ()

@property (nonatomic, strong) NSArray *arrEvents;

@end

#pragma mark -

@implementation OperationAnalyticViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _arrEvents = @[@{kEventID:@"Event_One", kEventName:@"Event One"},
                       @{kEventID:@"Event_Two", kEventName:@"Event Two"},
                       @{kEventID:@"Event_Three", kEventName:@"Event Three"}];
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
}

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
    return _arrEvents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"EventIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
    }
    NSString *strTitle = _arrEvents[indexPath.row][kEventName];
    [cell.textLabel setText:strTitle];
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *eventID = _arrEvents[indexPath.row][kEventID];
    
    [MobClick event:eventID];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"触发ID%@事件", eventID]];
}//

@end
