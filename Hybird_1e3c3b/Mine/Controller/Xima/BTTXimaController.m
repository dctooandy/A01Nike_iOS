//
//  BTTXimaController.m
//  Hybird_1e3c3b
//
//  Created by Domino on 29/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTXimaController.h"
#import "BTTXimaHeaderCell.h"
#import "BTTThisWeekBtnsCell.h"
#import "BTTThisWeekCell.h"
#import "BTTThisWeekTotalCell.h"
#import "BTTLastWeekCell.h"
#import "BTTXimaFooterCell.h"
#import "BTTXimaFooterCell.h"
#import "BTTXimaController+LoadData.h"
#import "BTTXimaItemModel.h"
#import "BTTXimaNoDataCell.h"
#import "BTTXimaSingleBtnCell.h"
#import "BTTXimaSuccessItemCell.h"
#import "BTTXimaSuccessBtnsCell.h"
#import "BTTXimaSuccessItemModel.h"
#import "BTTXimaLogController.h"
#import "BTTXimaRecordController.h"

@interface BTTXimaController ()<BTTElementsFlowLayoutDelegate>

@end

@implementation BTTXimaController

- (void)viewDidLoad {
    self.title = @"自助洗码";
    [super viewDidLoad];
    self.selectedArray = [NSMutableArray new];
    self.ximaStatusType = BTTXimaStatusTypeNormal;
    self.ximaDateType = BTTXimaDateTypeThisWeek;
    self.thisWeekDataType = BTTXimaThisWeekTypeVaild;
    self.currentListType = BTTXimaCurrentListTypeLoading;
    self.historyListType = BTTXimaHistoryListTypeLoading;
    self.otherListType = BTTXimaHistoryListTypeLoading;
    [self setupCollectionView];
    [self setupElements];
    [self loadMainData];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTXimaHeaderCell" bundle:nil] forCellWithReuseIdentifier:@"BTTXimaHeaderCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTThisWeekBtnsCell" bundle:nil] forCellWithReuseIdentifier:@"BTTThisWeekBtnsCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTThisWeekCell" bundle:nil] forCellWithReuseIdentifier:@"BTTThisWeekCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTThisWeekTotalCell" bundle:nil] forCellWithReuseIdentifier:@"BTTThisWeekTotalCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTLastWeekCell" bundle:nil] forCellWithReuseIdentifier:@"BTTLastWeekCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTXimaFooterCell" bundle:nil] forCellWithReuseIdentifier:@"BTTXimaFooterCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTXimaNoDataCell" bundle:nil] forCellWithReuseIdentifier:@"BTTXimaNoDataCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTXimaSingleBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTXimaSingleBtnCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTXimaSuccessBtnsCell" bundle:nil] forCellWithReuseIdentifier:@"BTTXimaSuccessBtnsCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTXimaSuccessItemCell" bundle:nil] forCellWithReuseIdentifier:@"BTTXimaSuccessItemCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        BTTXimaHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTXimaHeaderCell" forIndexPath:indexPath];
        weakSelf(weakSelf)
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            strongSelf(strongSelf)
            strongSelf.ximaDateType = (BTTXimaDateType)(button.tag - 80000);
            if (button.tag == 80000) {
                if ([button.titleLabel.text isEqualToString:@"其它游戏厅"]) {
                    self.thisWeekDataType = BTTXimaThisWeekTypeOther;
                } else {
                    self.thisWeekDataType = BTTXimaThisWeekTypeVaild;
                }
            }
            if (button.tag==80001) {
                if ([button.titleLabel.text isEqualToString:@"本周"]) {
                    strongSelf.ximaDateType = BTTXimaDateTypeThisWeek;
                    self.thisWeekDataType = BTTXimaThisWeekTypeVaild;
                }
                
            }
            [strongSelf setupElements];
        };
        return cell;
    } else {
        if (self.ximaStatusType == BTTXimaStatusTypeNormal) {
            if (self.ximaDateType == BTTXimaDateTypeLastWeek) {
                if (self.historyListType == BTTXimaHistoryListTypeNoData || self.historyListType == BTTXimaHistoryListTypeLoading) {
                    if (indexPath.row == 1) {
                        BTTXimaNoDataCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTXimaNoDataCell" forIndexPath:indexPath];
                        if (self.historyListType == BTTXimaHistoryListTypeLoading) {
                            cell.statusLB.text = @"加载中...";
                        } else {
                            cell.statusLB.text = @"暂无洗码数据";
                        }
                        return cell;
                    } else {
                        BTTXimaFooterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTXimaFooterCell" forIndexPath:indexPath];
                        weakSelf(weakSelf);
                        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                            strongSelf(strongSelf);
                            [strongSelf pushToWebView];
                        };
                        return cell;
                    }
                } else {
                    if (indexPath.row == self.historyArray.count + 2) {
                        BTTXimaFooterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTXimaFooterCell" forIndexPath:indexPath];
                        weakSelf(weakSelf);
                        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                            strongSelf(strongSelf);
                            [strongSelf pushToWebView];
                        };
                        return cell;
                    }else if (indexPath.row==self.historyArray.count+1){
                        BTTThisWeekTotalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTThisWeekTotalCell" forIndexPath:indexPath];
                        cell.history = self.historyArray;
                        return cell;
                    } else {
                        BTTLastWeekCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTLastWeekCell" forIndexPath:indexPath];
                        BTTXimaLastWeekItemModel *model = self.historyArray.count ? [BTTXimaLastWeekItemModel yy_modelWithJSON:self.historyArray[indexPath.row - 1]] : nil;
                        cell.model = model;
                        return cell;
                    }
                }
            } else {
                if (self.thisWeekDataType == BTTXimaThisWeekTypeVaild) {
                    if (self.currentListType == BTTXimaCurrentListTypeNoData || self.currentListType == BTTXimaCurrentListTypeLoading) {
                        if (indexPath.row == 1) {
                            BTTXimaNoDataCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTXimaNoDataCell" forIndexPath:indexPath];
                            if (self.currentListType == BTTXimaCurrentListTypeLoading) {
                                cell.statusLB.text = @"加载中...";
                            } else {
                                cell.statusLB.text = @"暂无洗码数据";
                            }
                            return cell;
                        } else if (indexPath.row == 2) {
                            BTTXimaSingleBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTXimaSingleBtnCell" forIndexPath:indexPath];
                            weakSelf(weakSelf);
                            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                                strongSelf(strongSelf);
                                if (button.tag == 1000) {
                                     BTTXimaHeaderCell *cell = (BTTXimaHeaderCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                                     [cell setBtnTwoType:BTTXimaHeaderBtnTwoTypeOtherSelect];
                                     [cell setBtnOneType:BTTXimaHeaderBtnOneTypeThisWeekNormal];
                                     strongSelf.thisWeekDataType = BTTXimaThisWeekTypeOther;
                                     [strongSelf setupElements];
                                } else {
                                    BTTXimaRecordController *vc = [BTTXimaRecordController new];
                                    [strongSelf.navigationController pushViewController:vc animated:YES];
                                }
                            };
                            return cell;
                        } else {
                            BTTXimaFooterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTXimaFooterCell" forIndexPath:indexPath];
                            weakSelf(weakSelf);
                            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                                strongSelf(strongSelf);
                                [strongSelf pushToWebView];
                            };
                            return cell;
                        }
                    } else {
                        if (indexPath.row == 1 + self.validModel.xmList.count) {
                            BTTThisWeekTotalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTThisWeekTotalCell" forIndexPath:indexPath];
                            cell.model = self.validModel;
                            return cell;
                        } else if (indexPath.row == self.validModel.xmList.count + 2) {
                            if (self.selectedArray.count==0) {
                                BTTXimaSingleBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTXimaSingleBtnCell" forIndexPath:indexPath];
                                weakSelf(weakSelf);
                                cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                                    strongSelf(strongSelf);
                                    if (button.tag == 1000) {
                                         BTTXimaHeaderCell *cell = (BTTXimaHeaderCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                                         [cell setBtnTwoType:BTTXimaHeaderBtnTwoTypeOtherSelect];
                                         [cell setBtnOneType:BTTXimaHeaderBtnOneTypeThisWeekNormal];
                                         strongSelf.thisWeekDataType = BTTXimaThisWeekTypeOther;
                                         [strongSelf setupElements];
                                    } else {
                                        BTTXimaRecordController *vc = [BTTXimaRecordController new];
                                        [strongSelf.navigationController pushViewController:vc animated:YES];
                                    }
                                };
                                return cell;
                            }else{
                                BTTThisWeekBtnsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTThisWeekBtnsCell" forIndexPath:indexPath];
                                [cell configForExtraCustomerBtn:[self detectIfBetRateMode]];
                                weakSelf(weakSelf);
                                cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                                    strongSelf(strongSelf);
                                    if (button.tag == 1049)
                                    {// 客服
                                        [CSVisitChatmanager startWithSuperVC:self finish:^(CSServiceCode errCode) {
                                            if (errCode != CSServiceCode_Request_Suc) {
                                                [MBProgressHUD showErrorWithTime:@"暂时无法链接，请贵宾改以电话联系，感谢您的理解与支持" toView:nil duration:3];
                                            } else {

                                            }
                                        }];
                                    } else if (button.tag == 1050) {
                                        if (self.selectedArray.count==0) {
                                            [MBProgressHUD showError:@"请选择要洗码的厅" toView:self.view];
                                        }else{
                                            [strongSelf loadXimaBillOut];
                                        }
                                    } else if (button.tag == 1051) {
                                        BTTXimaHeaderCell *cell = (BTTXimaHeaderCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                                        [cell setBtnTwoType:BTTXimaHeaderBtnTwoTypeOtherSelect];
                                        [cell setBtnOneType:BTTXimaHeaderBtnOneTypeThisWeekNormal];
                                        strongSelf.thisWeekDataType = BTTXimaThisWeekTypeOther;
                                        [strongSelf setupElements];
                                    } else {
                                        BTTXimaRecordController *vc = [BTTXimaRecordController new];
                                        [strongSelf.navigationController pushViewController:vc animated:YES];
                                    }
                                };
                                return cell;
                            }
                            
                        } else if (indexPath.row == self.validModel.xmList.count + 3) {
                            BTTXimaFooterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTXimaFooterCell" forIndexPath:indexPath];
                            weakSelf(weakSelf);
                            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                                strongSelf(strongSelf);
                                [strongSelf pushToWebView];
                            };
                            return cell;
                        } else {
                            BTTThisWeekCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTThisWeekCell" forIndexPath:indexPath];
                            weakSelf(weakSelf)
                            BTTXimaItemModel *model = self.validModel.xmList.count ? self.validModel.xmList[indexPath.row - 1] : nil;
                            [cell setItemSelectedWithState:[self.selectedArray containsObject:self.validModel.xmList[indexPath.row-1]]];
                            cell.tapSelecteButton = ^(BOOL isSelected) {
                                if (isSelected) {
                                    [self.selectedArray addObject:self.validModel.xmList[indexPath.row-1]];
                                }else{
                                    if ([self.selectedArray containsObject:self.validModel.xmList[indexPath.row-1]]) {
                                        [self.selectedArray removeObject:self.validModel.xmList[indexPath.row-1]];
                                    }
                                }
                                [self.collectionView reloadData];
                            };
                            cell.tapBetRateAlertButton = ^{
                                [weakSelf showBetRateAlert];
                            };
                            cell.model = model;
                            return cell;
                        }
                    }
                } else {//
                    if (self.otherListType == BTTXimaOtherListTypeLoading || self.otherListType == BTTXimaOtherListTypeNoData) {
                        if (indexPath.row == 1) {
                            BTTXimaNoDataCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTXimaNoDataCell" forIndexPath:indexPath];
                            if (self.otherListType == BTTXimaOtherListTypeLoading) {
                                cell.statusLB.text = @"加载中...";
                            } else {
                                cell.statusLB.text = @"暂无洗码数据";
                            }
                            return cell;
                        } else {
                            BTTXimaFooterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTXimaFooterCell" forIndexPath:indexPath];
                            weakSelf(weakSelf);
                            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                                strongSelf(strongSelf);
                                [strongSelf pushToWebView];
                            };
                            return cell;
                        }
                    } else {
                        if (indexPath.row == 1 + self.otherModel.xmList.count) {
                            BTTThisWeekTotalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTThisWeekTotalCell" forIndexPath:indexPath];
                            cell.model = self.otherModel;
                            return cell;
                        } else if (indexPath.row == self.otherModel.xmList.count + 2) {
                            BTTXimaFooterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTXimaFooterCell" forIndexPath:indexPath];
                            weakSelf(weakSelf);
                            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                                strongSelf(strongSelf);
                                [strongSelf pushToWebView];
                            };
                            return cell;
                        } else {
                            BTTLastWeekCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTLastWeekCell" forIndexPath:indexPath];
                            BTTXimaItemModel *model = self.otherModel.xmList.count ? self.otherModel.xmList[indexPath.row - 1] : nil;
                            cell.itemModel = model;
                            return cell;
                        }
                    }
                }
            }
        } else {
            if (indexPath.row == self.xmResults.count + 1) {
                if ([[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"]) {
                    BTTXimaSuccessBtnsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTXimaSuccessBtnsCell" forIndexPath:indexPath];
                    weakSelf(weakSelf);
                    cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                        strongSelf(strongSelf);
                        if (button.tag == 1060) {
                            BTTXimaHeaderCell *cell = (BTTXimaHeaderCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                            [cell setBtnOneType:BTTXimaHeaderBtnOneTypeLastWeekNormal];
                            [cell setBtnTwoType:BTTXimaHeaderBtnTwoTypeThisWeekSelect];
                            strongSelf.ximaStatusType = BTTXimaStatusTypeNormal;
                            strongSelf.thisWeekDataType = BTTXimaThisWeekTypeVaild;
                            [strongSelf loadMainData];
                        } else if (button.tag == 1061) {
                            [strongSelf.navigationController popToRootViewControllerAnimated:true];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoCustomerReportNotification" object:nil];
                        }
                    };
                    return cell;
                } else {
                    BTTXimaSuccessBtnsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTXimaSuccessBtnsCell" forIndexPath:indexPath];
                    weakSelf(weakSelf);
                    cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                        strongSelf(strongSelf);
                        [strongSelf.navigationController popToRootViewControllerAnimated:true];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoCustomerReportNotification" object:nil];
                    };
                    return cell;
                }
                
            } else {
                BTTXimaSuccessItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTXimaSuccessItemCell" forIndexPath:indexPath];
                BTTXimaSuccessItemModel *model = self.xmResults.count ? [BTTXimaSuccessItemModel yy_modelWithJSON:self.xmResults[indexPath.row - 1]] : nil;
                cell.model = model;
                return cell;
            }
        }
    }
    return nil;
}

- (void)pushToWebView {
    BTTBaseWebViewController *vc = [[BTTBaseWebViewController alloc] init];
    vc.webConfigModel.url = [NSString stringWithFormat:@"%@%@",[IVNetwork h5Domain],@"activity_pages/promotion_gift"];
    vc.webConfigModel.theme = @"outside";
    vc.webConfigModel.newView = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%zd", indexPath.item);
    if (self.ximaStatusType == BTTXimaStatusTypeNormal && self.ximaDateType == BTTXimaDateTypeThisWeek && self.thisWeekDataType == BTTXimaThisWeekTypeVaild) {
        if (indexPath.row >= 1 && indexPath.row < 1 + self.validModel.xmList.count) {
//            BTTXimaItemModel *model = self.validModel.xmList[indexPath.row - 1];
//            model.isSelect = !model.isSelect;
            [self.collectionView reloadData];
        }
    }
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
    return UIEdgeInsetsMake(0, 0, 40, 0);
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
    NSInteger total = 0;
    if (self.ximaStatusType == BTTXimaStatusTypeNormal) {
        if (self.ximaDateType == BTTXimaDateTypeThisWeek) {
            if (self.thisWeekDataType == BTTXimaThisWeekTypeVaild) {
                if (self.currentListType == BTTXimaCurrentListTypeNoData || self.currentListType == BTTXimaCurrentListTypeLoading) {
                    total =  4;
                } else {
                    total = 4 + self.validModel.xmList.count;
                }
            } else {
                if (self.otherListType == BTTXimaOtherListTypeNoData || self.otherListType == BTTXimaOtherListTypeLoading) {
                    total = 3;
                } else {
                    total = 3 + self.otherModel.xmList.count;
                }
            }
        } else if (self.ximaDateType == BTTXimaDateTypeLastWeek) {
            if (self.historyListType == BTTXimaHistoryListTypeNoData || self.historyListType == BTTXimaHistoryListTypeLoading) {
                total = 3;
            } else {
                total = 3 + self.historyArray.count;
            }
        }
    } else {
        total = 2 + self.xmResults.count;
    }
    NSMutableArray *elementsHight = [NSMutableArray array];
    BOOL isBetRateMode = [self detectIfBetRateMode];
    for (int i = 0; i < total; i ++) {
        
        if (i == 0) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 48)]];
        } else {
            if (self.ximaStatusType == BTTXimaStatusTypeNormal) {
                if (self.ximaDateType == BTTXimaDateTypeLastWeek) {
                    if (self.historyListType == BTTXimaHistoryListTypeNoData || self.historyListType == BTTXimaHistoryListTypeLoading) {
                        if (i == 1) {
                            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 80)]];
                        } else {
                            if (SCREEN_WIDTH == 414) {
                                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 432)]];
                            } else if (SCREEN_WIDTH == 320) {
                                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 532)]];
                            } else {
                                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 462)]];
                            }
                        }
                    } else {
                        if (i == 1 + self.historyArray.count) {
                            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
                        } else if (i == self.historyArray.count + 2) {
                            if (SCREEN_WIDTH == 414) {
                                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 432)]];
                            } else if (SCREEN_WIDTH == 320) {
                                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 532)]];
                            } else {
                                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 462)]];
                            }
                        } else {
                            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 107)]];
                        }
                    }
                } else {
                    if (self.thisWeekDataType == BTTXimaThisWeekTypeVaild) {
                        if (self.currentListType == BTTXimaCurrentListTypeNoData || self.currentListType == BTTXimaCurrentListTypeLoading) {
                            if (i == 1) {
                                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 80)]];
                            } else if (i == 2) {
                                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 100)]];
                            } else {
                                if (SCREEN_WIDTH == 414) {
                                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 432)]];
                                } else if (SCREEN_WIDTH == 320) {
                                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 532)]];
                                } else {
                                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 462)]];
                                }
                            }
                        } else {
                            if (i == 1 + self.validModel.xmList.count) {
                                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
                            } else if (i == self.validModel.xmList.count + 2) {
                                if (isBetRateMode == YES)
                                {
                                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 193)]];
                                }else
                                {
                                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 137)]];
                                }
                            } else if (i == self.validModel.xmList.count + 3) {
                                if (SCREEN_WIDTH == 414) {
                                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 432)]];
                                } else if (SCREEN_WIDTH == 320) {
                                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 532)]];
                                } else {
                                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 462)]];
                                }
                            } else {
                                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 107)]];
                            }
                        }
                    } else {
                        if (self.otherListType == BTTXimaOtherListTypeNoData || self.otherListType == BTTXimaOtherListTypeLoading) {
                            if (i == 1) {
                                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 80)]];
                            } else {
                                if (SCREEN_WIDTH == 414) {
                                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 432)]];
                                } else if (SCREEN_WIDTH == 320) {
                                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 532)]];
                                } else {
                                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 462)]];
                                }
                            }
                        } else {
                            if (i == 1 + self.otherModel.xmList.count) {
                                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
                            } else if (i == self.otherModel.xmList.count + 2) {
                                if (SCREEN_WIDTH == 414) {
                                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 432)]];
                                } else if (SCREEN_WIDTH == 320) {
                                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 532)]];
                                } else {
                                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 462)]];
                                }
                            } else {
                                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 107)]];
                            }
                        }
                    }
                }
            } else {
                if (i == total - 1) {
                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 60)]];
                } else {
                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 85)]];
                }
            }
        }
    }
    if (isBetRateMode == YES)
    {
        [self showBetRateAlert];
    }
    
    self.elementsHight = elementsHight.mutableCopy;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}
- (BOOL)detectIfBetRateMode
{
    BOOL isBetRateMode = NO;
    // 判断是否有沙巴倍投
    for ( BTTXimaItemModel *model in self.validModel.xmList) {
        if ([model.xmName isEqualToString:@"沙巴体育"] && [model.multiBetRate intValue] > 1)
        {
            isBetRateMode = YES;
        }
    }
    return isBetRateMode;
}
- (void)showBetRateAlert
{
//    NSString * message = @"您现在沙巴体育处于倍投状态，需通过人工操作洗码，请联系客服";
//    [MBProgressHUD showSuccessWithTime:message toView:nil duration:3];
}
@end
