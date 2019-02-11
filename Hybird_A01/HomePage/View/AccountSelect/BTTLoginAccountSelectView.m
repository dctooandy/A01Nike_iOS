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

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation BTTLoginAccountSelectView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)setupUI {
    
}

#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
