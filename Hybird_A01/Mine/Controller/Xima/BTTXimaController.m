//
//  BTTXimaController.m
//  Hybird_A01
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

typedef enum {
    BTTXimaDateTypeThisWeek, //本周
    BTTXimaDateTypeLastWeek  //上周
}BTTXimaDateType;

typedef enum {
    BTTXimaThisWeekTypeVaild, ///< 当前
    BTTXimaThisWeekTypeOther  ///< other
}BTTXimaThisWeekType;

@interface BTTXimaController ()<BTTElementsFlowLayoutDelegate>

@property (nonatomic, assign) BTTXimaDateType ximaDateType; ///< 洗码页面显示类型

@property (nonatomic, assign) BTTXimaThisWeekType thisWeekDataType; ///< this week 数据类型

@end

@implementation BTTXimaController

- (void)viewDidLoad {
    self.title = @"自助洗码";
    [super viewDidLoad];
    self.ximaStatusType = BTTXimaStatusTypeNormal;
    self.ximaDateType = BTTXimaDateTypeThisWeek;
    self.thisWeekDataType = BTTXimaThisWeekTypeVaild;
    self.currentListType = BTTXimaCurrentListTypeNoData;
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
            [strongSelf setupElements];
        };
        return cell;
    } else {
        if (self.ximaStatusType == BTTXimaStatusTypeNormal) {
            if (self.ximaDateType == BTTXimaDateTypeLastWeek) {
                if (self.historyListType == BTTXimaHistoryListTypeNoData) {
                    if (indexPath.row == 1) {
                        BTTXimaNoDataCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTXimaNoDataCell" forIndexPath:indexPath];
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
                    if (indexPath.row == 1 + self.histroyModel.list.count) {
                        BTTThisWeekTotalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTThisWeekTotalCell" forIndexPath:indexPath];
                        cell.model = self.histroyModel;
                        return cell;
                    } else if (indexPath.row == self.histroyModel.list.count + 2) {
                        BTTXimaFooterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTXimaFooterCell" forIndexPath:indexPath];
                        weakSelf(weakSelf);
                        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                            strongSelf(strongSelf);
                            [strongSelf pushToWebView];
                        };
                        return cell;
                    } else {
                        BTTLastWeekCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTLastWeekCell" forIndexPath:indexPath];
                        BTTXimaItemModel *model = self.histroyModel.list[indexPath.row - 1];
                        cell.model = model;
                        return cell;
                    }
                }
            } else {
                if (self.thisWeekDataType == BTTXimaThisWeekTypeVaild) {
                    if (self.currentListType == BTTXimaCurrentListTypeNoData) {
                        if (indexPath.row == 1) {
                            BTTXimaNoDataCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTXimaNoDataCell" forIndexPath:indexPath];
                            return cell;
                        } else if (indexPath.row == 2) {
                            BTTXimaSingleBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTXimaSingleBtnCell" forIndexPath:indexPath];
                            weakSelf(weakSelf);
                            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                                strongSelf(strongSelf);
                                BTTXimaHeaderCell *cell = (BTTXimaHeaderCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                                [cell setBtnTwoType:BTTXimaHeaderBtnTwoTypeOtherSelect];
                                [cell setBtnOneType:BTTXimaHeaderBtnOneTypeThisWeekNormal];
                                strongSelf.thisWeekDataType = BTTXimaThisWeekTypeOther;
                                [strongSelf setupElements];
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
                        if (indexPath.row == 1 + self.validModel.list.count) {
                            BTTThisWeekTotalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTThisWeekTotalCell" forIndexPath:indexPath];
                            cell.model = self.validModel;
                            return cell;
                        } else if (indexPath.row == self.validModel.list.count + 2) {
                            BTTThisWeekBtnsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTThisWeekBtnsCell" forIndexPath:indexPath];
                            weakSelf(weakSelf);
                            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                                strongSelf(strongSelf);
                                if (button.tag == 1050) {
                                    [strongSelf loadXimaBillOut];
                                } else if (button.tag == 1051) {
                                    BTTXimaHeaderCell *cell = (BTTXimaHeaderCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                                    [cell setBtnTwoType:BTTXimaHeaderBtnTwoTypeOtherSelect];
                                    [cell setBtnOneType:BTTXimaHeaderBtnOneTypeThisWeekNormal];
                                    strongSelf.thisWeekDataType = BTTXimaThisWeekTypeOther;
                                    [strongSelf setupElements];
                                }
                            };
                            return cell;
                        } else if (indexPath.row == self.validModel.list.count + 3) {
                            BTTXimaFooterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTXimaFooterCell" forIndexPath:indexPath];
                            weakSelf(weakSelf);
                            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                                strongSelf(strongSelf);
                                [strongSelf pushToWebView];
                            };
                            return cell;
                        } else {
                            BTTThisWeekCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTThisWeekCell" forIndexPath:indexPath];
                            
                            BTTXimaItemModel *model = self.validModel.list[indexPath.row - 1];
                            cell.thisWeekCellType = model.isSelect;
                            cell.model = model;
                            return cell;
                        }
                    }
                } else {
                    if (indexPath.row == 1 + self.otherModel.list.count) {
                        BTTThisWeekTotalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTThisWeekTotalCell" forIndexPath:indexPath];
                        cell.model = self.otherModel;
                        return cell;
                    } else if (indexPath.row == self.otherModel.list.count + 2) {
                        BTTXimaFooterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTXimaFooterCell" forIndexPath:indexPath];
                        weakSelf(weakSelf);
                        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                            strongSelf(strongSelf);
                            [strongSelf pushToWebView];
                        };
                        return cell;
                    } else {
                        BTTThisWeekCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTThisWeekCell" forIndexPath:indexPath];
                        cell.thisWeekCellType = BTTXimaThisWeekCellTypeDisable;
                        BTTXimaItemModel *model = self.otherModel.list[indexPath.row - 1];
                        cell.model = model;
                        return cell;
                    }
                }
            }
        } else {
            if (indexPath.row == self.xmResults.count + 1) {
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
                        BTTXimaLogController *vc = [BTTXimaLogController new];
                        vc.webConfigModel.url = @"customer/log_xm.htm?days=15";
                        vc.webConfigModel.newView = YES;
                        vc.webConfigModel.theme = @"inside";
                        [strongSelf.navigationController pushViewController:vc animated:YES];
                    }
                };
                return cell;
            } else {
                BTTXimaSuccessItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTXimaSuccessItemCell" forIndexPath:indexPath];
                BTTXimaSuccessItemModel *model = self.xmResults[indexPath.row - 1];
                cell.model = model;
                return cell;
            }
        }
        
    }
}

- (void)pushToWebView {
    BTTBaseWebViewController *vc = [[BTTBaseWebViewController alloc] init];
    vc.webConfigModel.url = [NSString stringWithFormat:@"%@%@",[IVNetwork h5Domain],@"promotion_activity.htm"];
    vc.webConfigModel.theme = @"outside";
    vc.webConfigModel.newView = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%zd", indexPath.item);
    if (self.ximaStatusType == BTTXimaStatusTypeNormal && self.ximaDateType == BTTXimaDateTypeThisWeek && self.thisWeekDataType == BTTXimaThisWeekTypeVaild) {
        if (indexPath.row >= 1 && indexPath.row < 1 + self.validModel.list.count) {
            BTTXimaItemModel *model = self.validModel.list[indexPath.row - 1];
            model.isSelect = !model.isSelect;
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
                if (self.currentListType == BTTXimaCurrentListTypeNoData) {
                    total =  4;
                } else {
                    total = 4 + self.validModel.list.count;
                }
            } else {
                total = 3 + self.otherModel.list.count;
            }
        } else {
            if (self.historyListType == BTTXimaHistoryListTypeNoData) {
                total = 3;
            } else {
                total = 3 + self.histroyModel.list.count;
            }
        }
    } else {
        total = 2 + self.xmResults.count;
    }
    
    for (int i = 0; i < total; i ++) {
        
        if (i == 0) {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 48)]];
        } else {
            if (self.ximaStatusType == BTTXimaStatusTypeNormal) {
                if (self.ximaDateType == BTTXimaDateTypeLastWeek) {
                    if (self.historyListType == BTTXimaHistoryListTypeNoData) {
                        if (i == 1) {
                            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 80)]];
                        } else {
                            if (SCREEN_WIDTH == 414) {
                                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 583)]];
                            } else if (SCREEN_WIDTH == 320) {
                                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 680)]];
                            } else {
                                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 613)]];
                            }
                        }
                    } else {
                        if (i == 1 + self.histroyModel.list.count) {
                            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
                        } else if (i == self.histroyModel.list.count + 2) {
                            if (SCREEN_WIDTH == 414) {
                                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 583)]];
                            } else if (SCREEN_WIDTH == 320) {
                                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 680)]];
                            } else {
                                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 613)]];
                            }
                        } else {
                            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 107)]];
                        }
                    }
                } else {
                    if (self.thisWeekDataType == BTTXimaThisWeekTypeVaild) {
                        if (self.currentListType == BTTXimaCurrentListTypeNoData) {
                            if (i == 1) {
                                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 80)]];
                            } else if (i == 2) {
                                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 100)]];
                            } else {
                                if (SCREEN_WIDTH == 414) {
                                    [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 583)]];
                                } else if (SCREEN_WIDTH == 320) {
                                    [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 680)]];
                                } else {
                                    [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 613)]];
                                }
                            }
                        } else {
                            if (i == 1 + self.validModel.list.count) {
                                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
                            } else if (i == self.validModel.list.count + 2) {
                                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 137)]];
                            } else if (i == self.validModel.list.count + 3) {
                                if (SCREEN_WIDTH == 414) {
                                    [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 583)]];
                                } else if (SCREEN_WIDTH == 320) {
                                    [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 680)]];
                                } else {
                                    [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 613)]];
                                }
                            } else {
                                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 107)]];
                            }
                        }
                    } else {
                        if (i == 1 + self.otherModel.list.count) {
                            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
                        } else if (i == self.otherModel.list.count + 2) {
                            if (SCREEN_WIDTH == 414) {
                                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 583)]];
                            } else if (SCREEN_WIDTH == 320) {
                                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 680)]];
                            } else {
                                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 613)]];
                            }
                        } else {
                            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 107)]];
                        }
                    }
                }
            } else {
                if (i == total - 1) {
                    [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 100)]];
                } else {
                    [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 85)]];
                }
            }
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

@end
