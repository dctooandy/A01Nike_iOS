//
//  BTTVIPClubUserRightCell.m
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/5/11.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTVIPClubUserRightCell.h"
#import "UserRightTableViewCell.h"

@interface BTTVIPClubUserRightCell ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSValue *> *elementsHight;
@end
@implementation BTTVIPClubUserRightCell
@synthesize elementsHight;
- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.backgroundColor = [UIColor clearColor];
    [self setupUI];
    [self setupElements];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.tableView reloadData];
}
- (void)setupUI
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.pagingEnabled = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"UserRightTableViewCell" bundle:nil] forCellReuseIdentifier:@"UserRightTableViewCell"];
    [self.tableView reloadData];
}
#pragma mark - tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.elementsHight[indexPath.item].CGSizeValue.height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserRightTableViewCell"];
    weakSelf(weakSelf);
    if (indexPath.item == 0)
    {
        [cell config:VIPRightFirstPage];
    }else if (indexPath.item == 1)
    {
        [cell config:VIPRightUpgradePage];
    }else if (indexPath.item == 2)
    {
        [cell config:VIPRightWashRatePage];
    }else if (indexPath.item == 3)
    {
        [cell config:VIPRightRights];
    }else if (indexPath.item == 4)
    {
        [cell config:VIPRightRightsDescriptPage];
    }else if (indexPath.item == 5)
    {
        [cell config:VIPRightTravelPage];
    }else if (indexPath.item == 6)
    {
        [cell config:VIPRightHistoryPage];
    }
    cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
        strongSelf(strongSelf);
        if (strongSelf.buttonClickBlock) {
            strongSelf.buttonClickBlock(button);
        }
    };
    return cell;
}

-(void)setupElements {
    NSMutableArray *elementsHight = [NSMutableArray array];
    NSInteger count = 7;
    CGFloat defaultInnerHeight = (SCREEN_HEIGHT - 49);
    CGFloat defaultNote1Height = 0;// 原始 100
    for (int i = 0; i < count; i++) {
//        if (i == 0) {
//            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, defaultInnerHeight)]];
//        } else  {
//            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)]];
//        }
        if (i == 4)
        {
            float newHeight = defaultInnerHeight + (SCREEN_HEIGHT >= 812 ? 200 : 300) + defaultNote1Height ;
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, newHeight)]];
        }else if (i == 5)
        {
            float newHeight = defaultInnerHeight + (SCREEN_HEIGHT/812.0) * 120;
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, newHeight)]];
        }else if (i == 6)
        {
            float newHeight = defaultInnerHeight + (SCREEN_HEIGHT/812.0) * 30;
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, newHeight)]];
        }else
        {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, defaultInnerHeight)]];
        }
    }
    
    self.elementsHight = elementsHight.mutableCopy;
    
    [self.tableView reloadData];
}
//- (void)setAccounts:(NSArray *)newValue
//{
//    self.accounts = newValue;
//
//    [self.tableView reloadData];
//}
- (void)scrollToPageWithIndex:(NSIndexPath*)indexPath
{
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
@end
