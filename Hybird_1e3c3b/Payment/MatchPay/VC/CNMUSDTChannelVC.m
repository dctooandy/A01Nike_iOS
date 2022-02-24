//
//  KYMSelectChannelVC.m
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/16.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "CNMUSDTChannelVC.h"
#import "KYMSelectChannelCell.h"
#import "BTTMeMainModel.h"

@interface CNMUSDTChannelVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertViewHeight;

@end

@implementation CNMUSDTChannelVC

- (void)awakeFromNib
{
    [super awakeFromNib];
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerTopLeft) cornerRadii:CGSizeMake(16, 16)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.contentView.frame;
    maskLayer.path = path.CGPath;
    self.contentView.layer.mask = maskLayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView.layer.cornerRadius = 16;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"KYMSelectChannelCell" bundle:nil] forCellReuseIdentifier:@"KYMSelectChannelCell"];
    self.alertViewHeight.constant = MIN(((self.list.count +1)*75), 400);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    BTTMeMainModel *model = self.list[indexPath.row];
    KYMSelectChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KYMSelectChannelCell"];
    cell.titleLable.text = model.name;
    cell.iconImageView.image = [UIImage imageNamed:model.iconName];
    cell.descLable.text = model.desc;
    cell.recommendIcon.hidden = YES;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedChannelCallback(indexPath.row);
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)closeBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
