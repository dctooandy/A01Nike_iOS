//
//  BTTLoginAccountSelectView.m
//  Hybird_1e3c3b
//
//  Created by Domino on 11/02/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTLoginAccountSelectView.h"
#import "BTTLoginAccountSelectCell.h"

@interface BTTLoginAccountSelectView ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightContstant;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstants;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgHeightConstants;

@property (nonatomic, copy) NSString *selectAccount;

@property (nonatomic, strong) NSIndexPath *preSelectIndexPath;

@end

@implementation BTTLoginAccountSelectView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"BTTLoginAccountSelectCell" bundle:nil] forCellReuseIdentifier:@"BTTLoginAccountSelectCell"];
    self.widthConstants.constant = SCREEN_WIDTH - 80;
    self.bgView.layer.cornerRadius = 5;
    self.tableView.scrollEnabled = NO;
    
    if (SCREEN_WIDTH == 320) {
        self.phoneLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.tableView.rowHeight = 30;
    } else {
        self.tableView.rowHeight = 40;
    }
    
}

#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.accounts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BTTLoginAccountSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BTTLoginAccountSelectCell"];
    if (indexPath.row == 0) {
        cell.accountLabel.text = [NSString stringWithFormat:@"%@(最近登录)",self.accounts[indexPath.row][@"loginName"]];
        cell.selectBtn.selected = YES;
    } else {
        cell.accountLabel.text = [NSString stringWithFormat:@"%@",self.accounts[indexPath.row][@"loginName"]];
        cell.selectBtn.selected = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.preSelectIndexPath.row != indexPath.row) {
        BTTLoginAccountSelectCell *preCell = (BTTLoginAccountSelectCell *)[tableView cellForRowAtIndexPath:self.preSelectIndexPath];
        preCell.selectBtn.selected = NO;
        
        self.selectAccount = self.accounts[indexPath.row][@"loginName"];
        BTTLoginAccountSelectCell *cell = (BTTLoginAccountSelectCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.selectBtn.selected = YES;
        self.preSelectIndexPath = indexPath;
    }
}

- (IBAction)dismissClick:(UIButton *)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (IBAction)loginClick:(UIButton *)sender {
    if (self.callBackBlock) {
        self.callBackBlock(self.selectAccount,@"",@"");
    }
}
- (NSArray *)filterFAccountsWithArray:(NSArray *)array
{
    NSMutableArray * newAccounts = [array mutableCopy];
    if (array && array.count > 0) {
        for (NSDictionary * subDis in array) {
            
            if ([subDis[@"loginName"] hasPrefix:@"f"] == YES)
            {
                NSLog(@"string contains f");
                [newAccounts removeObject:subDis];
//                return [newAccounts copy];
//                break;
            }else
            {
                NSLog(@"string does not contain f");
                
            }
        }
        return newAccounts;
    }else
    {
        return @[];
    }
}
- (void)setAccounts:(NSArray *)accounts {

    _accounts = [self filterFAccountsWithArray:accounts];
    NSString *phoneHidden = [NSString stringWithFormat:@"%@*******%@",[self.phone substringToIndex:3],[self.phone substringFromIndex:self.phone.length - 1]];
    NSString *phoneStr = [NSString stringWithFormat:@"手机号%@, 可登录账号如下:", phoneHidden];
    
    NSRange phoneRange = [phoneStr rangeOfString:phoneHidden];
    NSMutableAttributedString *attPhone = [[NSMutableAttributedString alloc] initWithString:phoneStr];
    [attPhone addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"499bf7"]} range:phoneRange];
    self.phoneLabel.attributedText = attPhone;
    if (_accounts.count > 0)
    {
        self.selectAccount = _accounts[0][@"loginName"];
        self.preSelectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        if (SCREEN_WIDTH == 320) {
            self.heightContstant.constant = 30 * _accounts.count;
            self.bgHeightConstants.constant = 190 + 30 * _accounts.count;
        } else {
            self.heightContstant.constant = 40 * _accounts.count;
            self.bgHeightConstants.constant = 190 + 40 * _accounts.count;
        }
    }else
    { // 沒有帳號時,需要另外處理
        self.selectAccount = @"";
        self.preSelectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        if (SCREEN_WIDTH == 320) {
            self.heightContstant.constant = 30 ;
            self.bgHeightConstants.constant = 190 ;
        } else {
            self.heightContstant.constant = 40;
            self.bgHeightConstants.constant = 190 + 40;
        }
    }
    [self.tableView reloadData];
}

@end
