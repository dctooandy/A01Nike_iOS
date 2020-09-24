//
//  BTTModifyBankRecordController.m
//  Hybird_A01
//
//  Created by Jairo on 22/09/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTModifyBankRecordController.h"
#import "BTTModifyBankRecordController+LoadData.h"
#import "BTTModifyBankRecordHeaderCell.h"
#import "BTTModifyBankRecordCell.h"

@interface BTTModifyBankRecordController ()<BTTElementsFlowLayoutDelegate>
@property (nonatomic, strong) NSMutableDictionary * cellDic;
@end

@implementation BTTModifyBankRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"银行卡更改记录";
    self.cellDic = [[NSMutableDictionary alloc] init];
    [self setupCollectionView];
    [self loadRecords];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTModifyBankRecordHeaderCell" bundle:nil] forCellWithReuseIdentifier:@"BTTModifyBankRecordHeaderCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        BTTModifyBankRecordHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTModifyBankRecordHeaderCell" forIndexPath:indexPath];
        return cell;
    } else {
        NSString *identifier = [_cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
        if (identifier == nil) {
            identifier = [NSString stringWithFormat:@"%@%@", @"BTTModifyBankRecordCell", [NSString stringWithFormat:@"%@", indexPath]];
            [_cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
            [self.collectionView registerNib:[UINib nibWithNibName:@"BTTModifyBankRecordCell" bundle:nil] forCellWithReuseIdentifier:identifier];
        }
        BTTModifyBankRecordCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        [cell setData:self.model.accounts[indexPath.row - 1]];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSLog(@"%zd", indexPath.item);
}

#pragma mark - LMJElementsFlowLayoutDelegate

- (CGSize)waterflowLayout:(BTTCollectionViewFlowlayout *)waterflowLayout collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.elementsHight[indexPath.item].CGSizeValue;
}

- (UIEdgeInsets)waterflowLayout:(BTTCollectionViewFlowlayout *)waterflowLayout edgeInsetsInCollectionView:(UICollectionView *)collectionView {
    return UIEdgeInsetsMake(0, 0, 0, 0);
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
    if (self.elementsHight.count) {
        [self.elementsHight removeAllObjects];
    }
    
    NSInteger total = self.model.accounts.count + 1;
    NSMutableArray *elementsHight = [NSMutableArray array];
    for (int i = 0; i < total; i++) {
        if (i == 0) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 30)]];
        } else {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 60)]];
        }
    }
    self.elementsHight = elementsHight.mutableCopy;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

@end
