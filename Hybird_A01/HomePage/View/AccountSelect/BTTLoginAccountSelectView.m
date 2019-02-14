//
//  BTTLoginAccountSelectView.m
//  Hybird_A01
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
        self.heightContstant.constant = 150;
        self.bgHeightConstants.constant = 335;
    } else {
        self.tableView.rowHeight = 40;
    }
    
}

#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BTTLoginAccountSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BTTLoginAccountSelectCell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (IBAction)dismissClick:(UIButton *)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}
@end
