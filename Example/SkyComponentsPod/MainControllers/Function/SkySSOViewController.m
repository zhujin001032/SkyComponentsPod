//
//  SkySSOViewController.m
//  SkyComponentsPod
//
//  Created by 何助金 on 16/4/5.
//  Copyright © 2016年 Jason.He. All rights reserved.
//

#import "SkySSOViewController.h"
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import "UserInfo.h"
//#import "AccountViewController.h"
#import <MOBFoundation/MOBFoundation.h>
#import <MOBFoundation/MOBFImageService.h>
@interface SkySSOViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArray;
    UITextView *_messageLogView;
}
@property (nonatomic, strong) NSMutableArray  *users;
/**
 *  提示文字标签
 */
@property (nonatomic, strong) UILabel *tipsLabel;

/**
 *  头像视图
 */
@property (nonatomic, strong) UIImageView *avatarImageView;

/**
 *  昵称标签
 */
@property (nonatomic, strong) UILabel *nicknameLabel;

/**
 *  关于标签
 */
@property (nonatomic, strong) UILabel *aboutMeLabel;

@end

@implementation SkySSOViewController
- (instancetype)init
{
    if (self = [super init])
    {
        //设置用户类型为UserInfo，这样可以将自定义的用户信息类与第三方登录进行绑定
        [SSEThirdPartyLoginHelper setUserClass:[UserInfo class]];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注销"
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:self
                                                                                 action:@selector(logoutAccount:)];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataArray = @[@"使用QQ登录",@"使用微信登录",@"使用Facebook登录",@"使用新浪微博登录"];
    [self addUserInfoViews];
    [self addTableView];
}

- (void)addUserInfoViews
{
    //提示
    self.tipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.tipsLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:self.tipsLabel];
    
    //头像
    self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 120, 120)];
    self.avatarImageView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.avatarImageView];
    
    //昵称
    self.nicknameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nicknameLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:self.nicknameLabel];
    
    //关于
    self.aboutMeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.aboutMeLabel.font = [UIFont systemFontOfSize:16];
    self.aboutMeLabel.numberOfLines = 0;
    [self.view addSubview:self.aboutMeLabel];
    
    //刷新用户信息
    [self refreshUserInfo];

}

/**
 *  刷新用户信息
 */
- (void)refreshUserInfo
{
    UserInfo *currentUser = (UserInfo *)[SSEThirdPartyLoginHelper currentUser];
    if (currentUser)
    {
        self.avatarImageView.hidden = NO;
        self.nicknameLabel.hidden = NO;
        self.tipsLabel.hidden = YES;
        self.aboutMeLabel.hidden = NO;
        self.nicknameLabel.text = currentUser.nickname;
        [self.nicknameLabel sizeToFit];
        self.nicknameLabel.frame = CGRectMake(self.avatarImageView.frame.size.width + self.avatarImageView.frame.origin.x + 10,
                                              self.avatarImageView.frame.origin.y,
                                              CGRectGetWidth(self.nicknameLabel.frame),
                                              CGRectGetHeight(self.nicknameLabel.frame));
        
        if (currentUser.avatar)
        {
            NSString *observer = [self description];
            __weak SkySSOViewController *theController = self;
            [[MOBFImageService sharedInstance] getImageWithURL:[NSURL URLWithString:currentUser.avatar]
                                                      observer:observer
                                                     onLoading:nil
                                                      onResult:^(NSData *imageData) {
                                                          
                                                          theController.avatarImageView.image = [[UIImage alloc] initWithData:imageData];
                                                          [[MOBFImageService sharedInstance] removeObserver:observer];
                                                          
                                                      }
                                                        onFail:nil];
        }
        if (currentUser.aboutMe.length) {
            self.aboutMeLabel.text = [NSString stringWithFormat:@"UID:%@ \nAboutMe:%@", currentUser.linkId,currentUser.aboutMe];
        }else{
            
            self.aboutMeLabel.text = [NSString stringWithFormat:@"UID:%@", currentUser.linkId];
        }
        
        self.aboutMeLabel.frame = [self.aboutMeLabel textRectForBounds:CGRectMake(self.avatarImageView.mkMaxX + 10, self.nicknameLabel.mkMaxY + 10 , self.view.frame.size.width - 40 - self.avatarImageView.mkWidth, MAXFLOAT) limitedToNumberOfLines:0];
    }
    else
    {
        self.avatarImageView.hidden = YES;
        self.nicknameLabel.hidden = YES;
        self.aboutMeLabel.hidden = YES;
        self.tipsLabel.hidden = NO;
        
        self.tipsLabel.text = @"用户尚未登录";
        self.tipsLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        [self.tipsLabel sizeToFit];
        self.tipsLabel.frame = CGRectMake((self.view.frame.size.width - self.tipsLabel.frame.size.width) / 2,
                                          (120 - self.tipsLabel.frame.size.height) / 2,
                                          CGRectGetWidth(self.tipsLabel.frame),
                                          CGRectGetHeight(self.tipsLabel.frame));
    }
}

- (void)addTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,120+20 ,SCREEN_WIDTH, SCREEN_HEIGHT-64 -120) style:UITableViewStylePlain];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = [UIColor grayColor];
    [self.view addSubview:_tableView];
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
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            [self logoutAccount:nil];
            [self loginWithPlatform:SSDKPlatformTypeQQ];
        }
            break;
        case 1:
        {
            [self logoutAccount:nil];
            [self loginWithPlatform:SSDKPlatformTypeWechat];
        }
            break;
        case 2:
        {
            [self logoutAccount:nil];
            [self loginWithPlatform:SSDKPlatformTypeFacebook];
        }
            break;
        case 3:
        {
            [self logoutAccount:nil];
            [self loginWithPlatform:SSDKPlatformTypeSinaWeibo];
        }
            break;

        default:
            break;
    }
}

/**
 *  获取第三方账号基本信息UId 与本地账号进行关联 完成第三方授权登录过程
 */
- (void)loginWithPlatform:(SSDKPlatformType)platform
{
    __weak SkySSOViewController *theController = self;
    [SSEThirdPartyLoginHelper loginByPlatform:platform
                                   onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
                                       
                                       //在此回调中可以将社交平台用户信息与自身用户系统进行绑定，最后使用一个唯一用户标识来关联此用户信息。
                                       //在此示例中没有跟用户系统关联，则使用一个社交用户对应一个系统用户的方式。将社交用户的uid作为关联ID传入associateHandler。
                                       associateHandler (user.uid, user, user);
                                       [self refreshUserInfo];
#warning 可以在此处使用第三方账号授权后返回的 uid nickname等信息 调用本地App的登录接口进行账号关联完成登录
                                       
                                   }
                                onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
                                    
                                    if (state == SSDKResponseStateSuccess)
                                    {
                                        //判断是否已经在用户列表中，避免用户使用同一账号进行重复登录
                                        if (![theController.users containsObject:user])
                                        {
                                            [theController.users addObject:user];
                                        }
                                        
                                        //刷新表格
//                                        [theController.tableView reloadData];
                                    }
                                    
                                }];
}

- (void)logoutAccount:(UIBarButtonItem *)sender
{
    if ([SSEThirdPartyLoginHelper currentUser]) {
        
        [SSEThirdPartyLoginHelper logout:[SSEThirdPartyLoginHelper currentUser]];
        [self refreshUserInfo];
    }
}
@end
