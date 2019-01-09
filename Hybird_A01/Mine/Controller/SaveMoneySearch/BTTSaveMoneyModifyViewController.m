//
//  BTTSaveMoneyModifyViewController.m
//  Hybird_A01
//
//  Created by Domino on 03/01/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTSaveMoneyModifyViewController.h"
#import "BTTMeMainModel.h"
#import "BTTBindingMobileOneCell.h"
#import "BTTPublicBtnCell.h"

@interface BTTSaveMoneyModifyViewController ()<BTTElementsFlowLayoutDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation BTTSaveMoneyModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"存款详情";
    [self setupCollectionView];
    [self setupTopView];
    [self loadMainData];
}

- (void)setupTopView {
    UIImageView *imageView = [UIImageView new];
    [self.collectionView addSubview:imageView];
    imageView.frame = CGRectMake(15, 14.5, 15, 15);
    imageView.image = ImageNamed(@"pay_Exclamation");
    UILabel *noticeLabel = [UILabel new];
    [self.collectionView addSubview:noticeLabel];
    noticeLabel.frame = CGRectMake(35, 11, 200, 20);
    noticeLabel.textColor = [UIColor colorWithHexString:@"d13847"];
    noticeLabel.font = [UIFont systemFontOfSize:14];
    noticeLabel.text = @"信息填写错误, 请重新填写!";
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileOneCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileOneCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTPublicBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTPublicBtnCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.dataSource.count) {
        BTTPublicBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTPublicBtnCell" forIndexPath:indexPath];
        cell.btnType = BTTPublicBtnTypeModify;
        cell.btn.enabled = YES;
        weakSelf(weakSelf);
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            strongSelf(strongSelf);
            
        };
        return cell;
    } else {
        BTTBindingMobileOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileOneCell" forIndexPath:indexPath];
        BTTMeMainModel *model = self.dataSource[indexPath.row];
        cell.model = model;
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%zd", indexPath.item);
}

#pragma mark - LMJCollectionViewControllerDataSource

- (UICollectionViewLayout *)collectionViewController:(BTTCollectionViewController *)collectionViewController layoutForCollectionView:(UICollectionView *)collectionView {
    BTTCollectionViewFlowlayout *elementsFlowLayout = [[BTTCollectionViewFlowlayout alloc] initWithDelegate:self];
    
    return elementsFlowLayout;
}

#pragma mark - LMJElementsFlowLayoutDelegate

- (CGSize)waterflowLayout:(BTTCollectionViewFlowlayout *)waterflowLayout collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.elementsHight[indexPath.item].CGSizeValue;
}

- (UIEdgeInsets)waterflowLayout:(BTTCollectionViewFlowlayout *)waterflowLayout edgeInsetsInCollectionView:(UICollectionView *)collectionView {
    return UIEdgeInsetsMake(44, 0, 0, 0);
}

/**
 *  列间距, 默认10
 */
- (CGFloat)waterflowLayout:(BTTCollectionViewFlowlayout *)waterflowLayout collectionView:(UICollectionView *)collectionView columnsMarginForItemAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

/**
 *  行间距, 默认10
 */
- (CGFloat)waterflowLayout:(BTTCollectionViewFlowlayout *)waterflowLayout collectionView:(UICollectionView *)collectionView linesMarginForItemAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}


- (void)setupElements {
    for (int i = 0; i < self.dataSource.count + 1; i++) {
        if (i == self.dataSource.count) {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 110)]];
        } else {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (void)loadMainData {
    if (self.dataSource.count) {
        [self.dataSource removeAllObjects];
    }
    NSArray *nameArr = @[@"存款姓名",@"存款金额",@"存款方式",@"存款时间",@"存款地点",@"存款银行",@"存款卡号"];
    for (NSString *name in nameArr) {
        BTTMeMainModel *model = [BTTMeMainModel new];
        model.name = name;
        [self.dataSource addObject:model];
    }
    [self setupElements];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
