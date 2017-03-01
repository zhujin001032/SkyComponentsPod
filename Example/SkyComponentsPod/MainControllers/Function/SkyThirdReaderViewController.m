//
//  SkyThirdReaderViewController.m
//  SkyComponentsPod
//
//  Created by SimonLiu on 16/4/11.
//  Copyright © 2016年 Jason.He. All rights reserved.
//

#import "SkyThirdReaderViewController.h"

@interface SkyThirdReaderViewController () <UITableViewDelegate,UITableViewDataSource,UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation SkyThirdReaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadTableView];
}

- (void)loadTableView {
    
    CGRect tableViewRect = self.view.frame;
    tableViewRect.size.height -= 64;
    UITableView *tableView = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.rowHeight = 44.0;
    [self.view addSubview:tableView];
    _tableView = tableView;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"kCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"关于我们.txt";
            cell.imageView.image = [UIImage imageNamed:@"thirdReader_text_icon.png"];
            break;
        }
        case 1:
        {
            cell.textLabel.text = @"关于我们.docx";
            cell.imageView.image = [UIImage imageNamed:@"thirdReader_word_icon.png"];
            break;
        }
        case 2:
        {
            cell.textLabel.text = @"关于我们.pdf";
            cell.imageView.image = [UIImage imageNamed:@"thirdReader_pdf_icon.png"];
            break;
        }
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    switch (indexPath.row) {
        case 0:
        {
            _documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[[NSBundle mainBundle] URLForResource:@"关于我们" withExtension:@"txt"]];
            _documentInteractionController.delegate = self;
            [_documentInteractionController presentOptionsMenuFromRect:self.view.frame inView:self.view animated:YES];
            break;
        }
        case 1:
        {
            _documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[[NSBundle mainBundle] URLForResource:@"关于我们" withExtension:@"docx"]];
            _documentInteractionController.delegate = self;
            [_documentInteractionController presentOptionsMenuFromRect:self.view.frame inView:self.view animated:YES];
            break;
        }
        case 2:
        {
            _documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[[NSBundle mainBundle] URLForResource:@"关于我们" withExtension:@"pdf"]];
            _documentInteractionController.delegate = self;
            [_documentInteractionController presentOptionsMenuFromRect:self.view.frame inView:self.view animated:YES];
            break;
        }
        default:
            break;
    }

}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
