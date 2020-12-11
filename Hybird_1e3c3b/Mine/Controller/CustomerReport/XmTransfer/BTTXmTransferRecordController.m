//
//  BTTXmTransferRecordController.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 25/09/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTXmTransferRecordController.h"
#import "BTTXmTransferRecordController+LoadData.h"
#import "BTTCreditRecordHeaderCell.h"
#import "BTTCreditRecordCell.h"

@interface BTTXmTransferRecordController ()
@property (nonatomic, strong) NSMutableDictionary * cellDic;
@end

@implementation BTTXmTransferRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"洗码转账记录";
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
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTCreditRecordHeaderCell" bundle:nil] forCellWithReuseIdentifier:@"BTTCreditRecordHeaderCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        BTTCreditRecordHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTCreditRecordHeaderCell" forIndexPath:indexPath];
        return cell;
    } else {
        NSString *identifier = [_cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
        if (identifier == nil) {
            identifier = [NSString stringWithFormat:@"%@%@", @"BTTCreditRecordCell", [NSString stringWithFormat:@"%@", indexPath]];
            [_cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
            [self.collectionView registerNib:[UINib nibWithNibName:@"BTTCreditRecordCell" bundle:nil] forCellWithReuseIdentifier:identifier];
        }
        BTTCreditRecordCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        [cell setXmTransferData:self.model.data[indexPath.row - 1]];
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
    
    NSInteger total = self.model.data.count + 1;
    NSMutableArray *elementsHight = [NSMutableArray array];
    for (int i = 0; i < total; i++) {
        if (i == 0) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 30)]];
        } else {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 100)]];
        }
    }
    self.elementsHight = elementsHight.mutableCopy;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

@end
