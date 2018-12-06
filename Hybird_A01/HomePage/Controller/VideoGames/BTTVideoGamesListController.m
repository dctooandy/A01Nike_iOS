//
//  BTTVideoGamesListController.m
//  Hybird_A01
//
//  Created by Domino on 26/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTVideoGamesListController.h"
#import "BTTVideoGamesListController+LoadData.h"
#import "BTTHomePageBannerCell.h"
#import "BTTBannerModel.h"
#import "BTTPromotionDetailController.h"
#import "BTTVideoGamesFilterCell.h"
#import "BTTVideoGamesHeaderCell.h"
#import "BTTVideoGameCell.h"
#import "BTTVideoGamesSearchCell.h"
#import "BRPickerView.h"
#import "BTTVideoGamesNoDataCell.h"
#import "BTTVideoGamesFooterCell.h"
#import "BTTLoginOrRegisterViewController.h"

@interface BTTVideoGamesListController ()<BTTElementsFlowLayoutDelegate,UISearchBarDelegate>


@property (nonatomic, assign) NSInteger page;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *line;

@property (nonatomic, copy) NSString *platform;

@property (nonatomic, copy) NSString *keyword;

@property (nonatomic, copy) NSString *sort;

@property (nonatomic, copy) NSString *order;

@property (nonatomic, assign) BOOL isShowSearchBar;

@property (nonatomic, strong) NSMutableArray *games;

@property (nonatomic, assign) NSInteger isFavorite;

@property (nonatomic, copy) NSString *count;

@property (nonatomic, assign) NSInteger searchPage;

@end

@implementation BTTVideoGamesListController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    _limit = 16;
    _searchPage = 1;
    _count = @"0";
    [self resetRequestModel];
    self.title = @"电子游戏";
    [self setupCollectionView];
    [self showLoading];
    [self loadGamesData];
    weakSelf(weakSelf);
    [self loadmoreWithBlock:^{
        strongSelf(strongSelf);
        [strongSelf showLoading];
        if (strongSelf.isFavorite) {
            [strongSelf loadCollectionData];
        } else {
            [strongSelf loadGamesData];
        }
    }];
    if ([IVNetwork userInfo]) {
        [self loadCollectionData];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)resetRequestModel {
    _type = @"hot";
    _line = @"";
    _platform = @"";
    _keyword = @"";
    _sort = @"hot";
    _order = @"desc";
    _page = 1;
}

- (void)loadGamesData {
    [self.collectionView.mj_footer resetNoMoreData];
    BTTVideoGamesRequestModel *requestModel = [BTTVideoGamesRequestModel new];
    requestModel.type = _type;
    requestModel.line = _line;
    requestModel.platform = _platform;
    requestModel.keyword = [_keyword stringByReplacingOccurrencesOfString:@" " withString:@""];
    requestModel.sort = _sort;
    requestModel.order = _order;
    if (_keyword.length) {
        requestModel.page = _searchPage;
    } else {
        requestModel.page = _page;
    }
    requestModel.limit = _limit;
    weakSelf(weakSelf);
    [self loadVideoGamesWithRequestModel:requestModel complete:^(IVRequestResultModel *result, id response) {
        strongSelf(strongSelf);
        NSLog(@"%@",response);
        [strongSelf endRefreshing];
        [strongSelf hideLoading];
        strongSelf.isShowSearchBar = NO;
        if (result.code_http == 200 && [result.data isKindOfClass:[NSDictionary class]]) {
            if (strongSelf.page == 1 || self.keyword.length) {
                [strongSelf.games removeAllObjects];
                self.keyword = @"";
            }
            self.count = result.data[@"count"];
            NSArray *games = result.data[@"list"];
            for (NSDictionary *dict in games) {
                BTTVideoGameModel *model = [BTTVideoGameModel yy_modelWithDictionary:dict];
                [strongSelf.games addObject:model];
            }
            if (games.count) {
                if (requestModel.keyword.length) {
                    strongSelf.searchPage ++;
                } else {
                    strongSelf.page ++;
                }
            }
            if (games.count < strongSelf.limit && games.count) {
                [strongSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
                strongSelf.isShowFooter = YES;
                [strongSelf.games addObject:[BTTVideoGameModel new]];
            }
            if (!games.count) {
                strongSelf.isShowFooter = YES;
                [strongSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [strongSelf setupElements];
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"点击了搜索");
    self.keyword = searchBar.text;
    searchBar.text = @"";
    [searchBar setShowsCancelButton:NO];
    [searchBar endEditing:YES];
    if (self.keyword.length) {
        [self showLoading];
        [self loadGamesData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.isShowSearchBar = NO;
    searchBar.text = @"";
    [searchBar setShowsCancelButton:NO];
    [searchBar endEditing:YES];
    [self setupElements];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES];
    return YES;
}


- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageBannerCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageBannerCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTVideoGamesFilterCell" bundle:nil] forCellWithReuseIdentifier:@"BTTVideoGamesFilterCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTVideoGamesHeaderCell" bundle:nil] forCellWithReuseIdentifier:@"BTTVideoGamesHeaderCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTVideoGameCell" bundle:nil] forCellWithReuseIdentifier:@"BTTVideoGameCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTVideoGamesSearchCell" bundle:nil] forCellWithReuseIdentifier:@"BTTVideoGamesSearchCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTVideoGamesNoDataCell" bundle:nil] forCellWithReuseIdentifier:@"BTTVideoGamesNoDataCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTVideoGamesFooterCell" bundle:nil] forCellWithReuseIdentifier:@"BTTVideoGamesFooterCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isFavorite) {
        if (indexPath.row == 0) {
            BTTHomePageBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageBannerCell" forIndexPath:indexPath];
            weakSelf(weakSelf);
            cell.clickEventBlock = ^(id  _Nonnull value) {
                strongSelf(strongSelf);
                BTTBannerModel *model = strongSelf.banners[[value integerValue]];
                BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
                vc.webConfigModel.url = model.action.detail;
                vc.webConfigModel.newView = YES;
                vc.webConfigModel.theme = @"outside";
                [strongSelf.navigationController pushViewController:vc animated:YES];
            };
            cell.imageUrls = self.imageUrls;
            return cell;
        } else if (indexPath.row == 1) {
            __weak BTTVideoGamesFilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTVideoGamesFilterCell" forIndexPath:indexPath];
            weakSelf(weakSelf);
            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                strongSelf(strongSelf);
                if (button.tag != 1073) {
                    strongSelf.isFavorite = NO;
                    if (strongSelf.games.count % strongSelf.limit) {
                        strongSelf.isShowFooter = YES;
                    } else {
                        strongSelf.isShowFooter = NO;
                    }
                    strongSelf.isShowSearchBar = NO;
                    UIButton *collectBtn = (UIButton *)[cell viewWithTag:1073];
                    collectBtn.selected = NO;
                    [strongSelf setupElements];
                    [strongSelf selectControlWithButton:button selectValueBlock:^(NSString *value) {
                        [button setTitle:value forState:UIControlStateNormal];
                    }];
                } else {
                    if (![IVNetwork userInfo]) {
                        [MBProgressHUD showError:@"请先登录" toView:nil];
                        BTTLoginOrRegisterViewController *vc = [[BTTLoginOrRegisterViewController alloc] init];
                        [strongSelf.navigationController pushViewController:vc animated:YES];
                        return;
                    }
                    strongSelf.isShowSearchBar = NO;
                    button.selected = !button.selected;
                    if (button.selected) {
                        strongSelf.isShowFooter = button.selected;
                    } else {
                        if (strongSelf.games.count % strongSelf.limit) {
                            strongSelf.isShowFooter = YES;
                        } else {
                            strongSelf.isShowFooter = NO;
                        }
                    }
                    if (button.selected) {
                        [strongSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
                    } else {
                        [strongSelf.collectionView.mj_footer resetNoMoreData];
                    }
                    strongSelf.isFavorite = button.selected;
                    [strongSelf setupElements];
                }
            };
            return cell;
        } else if (indexPath.row == 2) {
            BTTVideoGamesHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTVideoGamesHeaderCell" forIndexPath:indexPath];
            cell.totalLabel.text = [NSString stringWithFormat:@"共有 (%@) 款游戏",self.count];
            weakSelf(weakSelf);
            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                strongSelf(strongSelf);
                BTTVideoGamesFilterCell *filterCell = (BTTVideoGamesFilterCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:strongSelf.isShowSearchBar ? 2 : 1 inSection:0]];
                UIButton *collectBtn = (UIButton *)[filterCell viewWithTag:1073];
                collectBtn.selected = NO;
                strongSelf.isFavorite = NO;
                strongSelf.isShowSearchBar = YES;
                strongSelf.searchPage = 1;
                [strongSelf setupElements];
            };
            return cell;
        } else {
            if (self.favorites.count > 1) {
                if (indexPath.row == self.favorites.count + 2) {
                    BTTVideoGamesFooterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTVideoGamesFooterCell" forIndexPath:indexPath];
                    return cell;
                } else {
                    BTTVideoGameModel *model = self.favorites.count ? self.favorites[indexPath.row - 3] : nil;
                    BTTVideoGameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTVideoGameCell" forIndexPath:indexPath];
                    if (indexPath.row % 2) {
                        cell.leftConstants.constant = 15;
                        cell.rightConstants.constant = 7.5;
                    } else {
                        cell.leftConstants.constant = 7.5;
                        cell.rightConstants.constant = 15;;
                    }
                    weakSelf(weakSelf);
                    cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                        strongSelf(strongSelf);
                        NSLog(@"%@",button);
                        if (![IVNetwork userInfo]) {
                            [MBProgressHUD showError:@"请先登录" toView:nil];
                            BTTLoginOrRegisterViewController *vc = [[BTTLoginOrRegisterViewController alloc] init];
                            [strongSelf.navigationController pushViewController:vc animated:YES];
                            return;
                        }
                        [strongSelf loadAddOrCancelFavorite:button.selected gameModel:model];
                    };
                    cell.model = model;
                    return cell;
                }
                
            } else {
                if (indexPath.row == 4) {
                    BTTVideoGamesFooterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTVideoGamesFooterCell" forIndexPath:indexPath];
                    weakSelf(weakSelf);
                    cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                        strongSelf(strongSelf);
                        BTTBaseWebViewController *vc = [BTTBaseWebViewController new];
                        vc.webConfigModel.newView = YES;
                        vc.webConfigModel.theme = @"inside";
                        if (button.tag == 1110) {
                            vc.webConfigModel.url = @"common/license.htm";
                        } else if (button.tag == 1111) {
                            vc.webConfigModel.url = @"common/newbie_guide.htm";
                        } else {
                            vc.webConfigModel.url = @"common/about.htm";
                        }
                        [strongSelf.navigationController pushViewController:vc animated:YES];
                    };
                    cell.clickEventBlock = ^(id  _Nonnull value) {
                        strongSelf(strongSelf);
                        BTTBaseWebViewController *vc = [BTTBaseWebViewController new];
                        vc.webConfigModel.newView = YES;
                        vc.webConfigModel.theme = @"outside";
                        vc.webConfigModel.url = @"common/about.htm";
                        [strongSelf.navigationController pushViewController:vc animated:YES];
                    };
                    return cell;
                } else {
                    BTTVideoGamesNoDataCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTVideoGamesNoDataCell" forIndexPath:indexPath];
                    return cell;
                }
            }
        }
    } else {
        if (self.isShowSearchBar) {
            if (indexPath.row == 0) {
                BTTVideoGamesSearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTVideoGamesSearchCell" forIndexPath:indexPath];
                cell.searchBar.delegate = self;
                return cell;
            } else if (indexPath.row == 1) {
                BTTHomePageBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageBannerCell" forIndexPath:indexPath];
                weakSelf(weakSelf);
                cell.clickEventBlock = ^(id  _Nonnull value) {
                    strongSelf(strongSelf);
                    BTTBannerModel *model = strongSelf.banners[[value integerValue]];
                    BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
                    vc.webConfigModel.url = model.action.detail;
                    vc.webConfigModel.newView = YES;
                    vc.webConfigModel.theme = @"outside";
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                };
                cell.imageUrls = self.imageUrls;
                return cell;
            } else if (indexPath.row == 2) {
                __weak BTTVideoGamesFilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTVideoGamesFilterCell" forIndexPath:indexPath];
                weakSelf(weakSelf);
                cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                    strongSelf(strongSelf);
                    if (button.tag != 1073) {
                        UIButton *collectBtn = (UIButton *)[cell viewWithTag:1073];
                        collectBtn.selected = NO;
                        strongSelf.isFavorite = NO;
                        if (strongSelf.games.count % strongSelf.limit) {
                            strongSelf.isShowFooter = YES;
                        } else {
                            strongSelf.isShowFooter = NO;
                        }
                        strongSelf.isShowSearchBar = NO;
                        [strongSelf setupElements];
                        [strongSelf selectControlWithButton:button selectValueBlock:^(NSString *value) {
                            [button setTitle:value forState:UIControlStateNormal];
                        }];
                    } else {
                        if (![IVNetwork userInfo]) {
                            [MBProgressHUD showError:@"请先登录" toView:nil];
                            BTTLoginOrRegisterViewController *vc = [[BTTLoginOrRegisterViewController alloc] init];
                            [strongSelf.navigationController pushViewController:vc animated:YES];
                            return;
                        }
                        strongSelf.isShowSearchBar = NO;
                        button.selected = !button.selected;
                        if (button.selected) {
                            strongSelf.isShowFooter = button.selected;
                        } else {
                            if (strongSelf.games.count % strongSelf.limit) {
                                strongSelf.isShowFooter = YES;
                            } else {
                                strongSelf.isShowFooter = NO;
                            }
                        }
                        if (button.selected) {
                            [strongSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
                        } else {
                            [strongSelf.collectionView.mj_footer resetNoMoreData];
                        }
                        strongSelf.isFavorite = button.selected;
                        [strongSelf setupElements];
                    }
                };
                return cell;
            } else if (indexPath.row == 3) {
                BTTVideoGamesHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTVideoGamesHeaderCell" forIndexPath:indexPath];
                cell.totalLabel.text = [NSString stringWithFormat:@"共有 (%@) 款游戏",self.count];
                weakSelf(weakSelf);
                cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                    strongSelf(strongSelf);
                    BTTVideoGamesFilterCell *filterCell = (BTTVideoGamesFilterCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:strongSelf.isShowSearchBar ? 2 : 1 inSection:0]];
                    UIButton *collectBtn = (UIButton *)[filterCell viewWithTag:1073];
                    collectBtn.selected = NO;
                    strongSelf.isFavorite = NO;
                    strongSelf.searchPage = 1;
                    strongSelf.isShowSearchBar = YES;
                    [strongSelf setupElements];
                };
                return cell;
            } else {
                if (self.games.count > 1) {
                    if (self.isShowFooter) {
                        if (indexPath.row == self.games.count + 3) {
                            BTTVideoGamesFooterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTVideoGamesFooterCell" forIndexPath:indexPath];
                            return cell;
                        } else {
                            BTTVideoGameModel *model = self.games.count ? self.games[indexPath.row - 4] : nil;
                            BTTVideoGameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTVideoGameCell" forIndexPath:indexPath];
                            if (indexPath.row % 2 == 0) {
                                cell.leftConstants.constant = 15;
                                cell.rightConstants.constant = 7.5;
                            } else {
                                cell.leftConstants.constant = 7.5;
                                cell.rightConstants.constant = 15;;
                            }
                            cell.model = model;
                            weakSelf(weakSelf);
                            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                                strongSelf(strongSelf);
                                if (![IVNetwork userInfo]) {
                                    [MBProgressHUD showError:@"请先登录" toView:nil];
                                    BTTLoginOrRegisterViewController *vc = [[BTTLoginOrRegisterViewController alloc] init];
                                    [strongSelf.navigationController pushViewController:vc animated:YES];
                                    return;
                                }
                                [strongSelf loadAddOrCancelFavorite:button.selected gameModel:model];
                            };
                            return cell;
                        }
                    } else {
                        BTTVideoGameModel *model = self.games.count ? self.games[indexPath.row - 4] : nil;
                        BTTVideoGameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTVideoGameCell" forIndexPath:indexPath];
                        if (indexPath.row % 2 == 0) {
                            cell.leftConstants.constant = 15;
                            cell.rightConstants.constant = 7.5;
                        } else {
                            cell.leftConstants.constant = 7.5;
                            cell.rightConstants.constant = 15;;
                        }
                        cell.model = model;
                        weakSelf(weakSelf);
                        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                            strongSelf(strongSelf);
                            if (![IVNetwork userInfo]) {
                                [MBProgressHUD showError:@"请先登录" toView:nil];
                                BTTLoginOrRegisterViewController *vc = [[BTTLoginOrRegisterViewController alloc] init];
                                [strongSelf.navigationController pushViewController:vc animated:YES];
                                return;
                            }
                            [strongSelf loadAddOrCancelFavorite:button.selected gameModel:model];
                        };
                        return cell;
                    }
                    
                } else {
                    if (indexPath.row == 5) {
                        BTTVideoGamesFooterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTVideoGamesFooterCell" forIndexPath:indexPath];
                        weakSelf(weakSelf);
                        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                            strongSelf(strongSelf);
                            BTTBaseWebViewController *vc = [BTTBaseWebViewController new];
                            vc.webConfigModel.newView = YES;
                            vc.webConfigModel.theme = @"inside";
                            if (button.tag == 1110) {
                                vc.webConfigModel.url = @"common/license.htm";
                            } else if (button.tag == 1111) {
                                vc.webConfigModel.url = @"common/newbie_guide.htm";
                            } else {
                                vc.webConfigModel.url = @"common/about.htm";
                            }
                            [strongSelf.navigationController pushViewController:vc animated:YES];
                        };
                        cell.clickEventBlock = ^(id  _Nonnull value) {
                            strongSelf(strongSelf);
                            BTTBaseWebViewController *vc = [BTTBaseWebViewController new];
                            vc.webConfigModel.newView = YES;
                            vc.webConfigModel.theme = @"outside";
                            vc.webConfigModel.url = @"common/about.htm";
                            [strongSelf.navigationController pushViewController:vc animated:YES];
                        };
                        return cell;
                    } else {
                        BTTVideoGamesNoDataCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTVideoGamesNoDataCell" forIndexPath:indexPath];
                        return cell;
                    }
                    
                }
            }
        } else {
            if (indexPath.row == 0) {
                BTTHomePageBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageBannerCell" forIndexPath:indexPath];
                weakSelf(weakSelf);
                cell.clickEventBlock = ^(id  _Nonnull value) {
                    strongSelf(strongSelf);
                    BTTBannerModel *model = strongSelf.banners[[value integerValue]];
                    BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
                    vc.webConfigModel.url = model.action.detail;
                    vc.webConfigModel.newView = YES;
                    vc.webConfigModel.theme = @"outside";
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                };
                cell.imageUrls = self.imageUrls;
                return cell;
            } else if (indexPath.row == 1) {
                __weak BTTVideoGamesFilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTVideoGamesFilterCell" forIndexPath:indexPath];
                weakSelf(weakSelf);
                cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                    strongSelf(strongSelf);
                    
                    if (button.tag != 1073) {
                        UIButton *collectBtn = (UIButton *)[cell viewWithTag:1073];
                        collectBtn.selected = NO;
                        strongSelf.isFavorite = NO;
                        if (strongSelf.games.count % strongSelf.limit) {
                            strongSelf.isShowFooter = YES;
                        } else {
                            strongSelf.isShowFooter = NO;
                        }
                        strongSelf.isShowSearchBar = NO;
                        [strongSelf setupElements];
                        [strongSelf selectControlWithButton:button selectValueBlock:^(NSString *value) {
                            [button setTitle:value forState:UIControlStateNormal];
                        }];
                    } else {
                        if (![IVNetwork userInfo]) {
                            [MBProgressHUD showError:@"请先登录" toView:nil];
                            BTTLoginOrRegisterViewController *vc = [[BTTLoginOrRegisterViewController alloc] init];
                            [strongSelf.navigationController pushViewController:vc animated:YES];
                            return;
                        }
                        strongSelf.isShowSearchBar = NO;
                        button.selected = !button.selected;
                        if (button.selected) {
                            strongSelf.isShowFooter = button.selected;
                        } else {
                            if (strongSelf.games.count % strongSelf.limit) {
                                strongSelf.isShowFooter = YES;
                            } else {
                                strongSelf.isShowFooter = NO;
                            }
                        }
                        
                        if (button.selected) {
                            [strongSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
                        } else {
                            [strongSelf.collectionView.mj_footer resetNoMoreData];
                        }
                        strongSelf.isFavorite = button.selected;
                        [strongSelf setupElements];
                    }
                };
                return cell;
            } else if (indexPath.row == 2) {
                BTTVideoGamesHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTVideoGamesHeaderCell" forIndexPath:indexPath];
                cell.totalLabel.text = [NSString stringWithFormat:@"共有 (%@) 款游戏",self.count];
                weakSelf(weakSelf);
                cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                    strongSelf(strongSelf);
                    BTTVideoGamesFilterCell *filterCell = (BTTVideoGamesFilterCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:strongSelf.isShowSearchBar ? 2 : 1 inSection:0]];
                    UIButton *collectBtn = (UIButton *)[filterCell viewWithTag:1073];
                    collectBtn.selected = NO;
                    strongSelf.searchPage = 1;
                    strongSelf.isFavorite = NO;
                    strongSelf.isShowSearchBar = YES;
                    [strongSelf setupElements];
                };
                return cell;
            } else {
                if (self.games.count > 1) {
                    if (self.isShowFooter) {
                        if (indexPath.row == self.games.count + 2) {
                            BTTVideoGamesFooterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTVideoGamesFooterCell" forIndexPath:indexPath];
                            return cell;
                        } else {
                            BTTVideoGameModel *model = self.games.count ? self.games[indexPath.row - 3] : nil;
                            BTTVideoGameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTVideoGameCell" forIndexPath:indexPath];
                            if (indexPath.row % 2) {
                                cell.leftConstants.constant = 15;
                                cell.rightConstants.constant = 7.5;
                            } else {
                                cell.leftConstants.constant = 7.5;
                                cell.rightConstants.constant = 15;;
                            }
                            weakSelf(weakSelf);
                            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                                strongSelf(strongSelf);
                                if (![IVNetwork userInfo]) {
                                    [MBProgressHUD showError:@"请先登录" toView:nil];
                                    BTTLoginOrRegisterViewController *vc = [[BTTLoginOrRegisterViewController alloc] init];
                                    [strongSelf.navigationController pushViewController:vc animated:YES];
                                    return;
                                }
                                [strongSelf loadAddOrCancelFavorite:button.selected gameModel:model];
                            };
                            cell.model = model;
                            return cell;
                        }
                    } else {
                        BTTVideoGameModel *model = self.games.count ? self.games[indexPath.row - 3] : nil;
                        BTTVideoGameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTVideoGameCell" forIndexPath:indexPath];
                        if (indexPath.row % 2) {
                            cell.leftConstants.constant = 15;
                            cell.rightConstants.constant = 7.5;
                        } else {
                            cell.leftConstants.constant = 7.5;
                            cell.rightConstants.constant = 15;;
                        }
                        weakSelf(weakSelf);
                        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                            strongSelf(strongSelf);
                            if (![IVNetwork userInfo]) {
                                [MBProgressHUD showError:@"请先登录" toView:nil];
                                BTTLoginOrRegisterViewController *vc = [[BTTLoginOrRegisterViewController alloc] init];
                                [strongSelf.navigationController pushViewController:vc animated:YES];
                                return;
                            }
                            [strongSelf loadAddOrCancelFavorite:button.selected gameModel:model];
                        };
                        cell.model = model;
                        return cell;
                    }
                } else {
                    if (indexPath.row == 4) {
                        BTTVideoGamesFooterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTVideoGamesFooterCell" forIndexPath:indexPath];
                        weakSelf(weakSelf);
                        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                            strongSelf(strongSelf);
                            BTTBaseWebViewController *vc = [BTTBaseWebViewController new];
                            vc.webConfigModel.newView = YES;
                            vc.webConfigModel.theme = @"inside";
                            if (button.tag == 1110) {
                                vc.webConfigModel.url = @"common/license.htm";
                            } else if (button.tag == 1111) {
                                vc.webConfigModel.url = @"common/newbie_guide.htm";
                            } else {
                                vc.webConfigModel.url = @"common/about.htm";
                            }
                            [strongSelf.navigationController pushViewController:vc animated:YES];
                        };
                        cell.clickEventBlock = ^(id  _Nonnull value) {
                            strongSelf(strongSelf);
                            BTTBaseWebViewController *vc = [BTTBaseWebViewController new];
                            vc.webConfigModel.newView = YES;
                            vc.webConfigModel.theme = @"outside";
                            vc.webConfigModel.url = @"common/about.htm";
                            [strongSelf.navigationController pushViewController:vc animated:YES];
                        };
                        return cell;
                    } else {
                        BTTVideoGamesNoDataCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTVideoGamesNoDataCell" forIndexPath:indexPath];
                        return cell;
                    }
                }
                
            }
        }
    }
}


- (void)selectControlWithButton:(UIButton *)button selectValueBlock:(BTTSelectValueBlock)selectValueBlock{
    NSArray *contents = nil;
    NSString *title = @"";
    if (button.tag == 1070) {
        contents = @[@"所有类别",@"热门游戏",@"彩金池游戏",@"最新游戏"];
        title = @"请选择游戏类别";
    } else if (button.tag == 1071) {
        contents = @[@"全平台",@"MG",@"AG",@"PT",@"TTG",@"PP"];
        title = @"请选择游戏平台";
        
    } else if (button.tag == 1072) {
        contents = @[@"全赔付",@"1-4线",@"5-9线",@"15-25线",@"30-50线",@"51-243线"];
        title = @"请选择线路";
    }
    [BRStringPickerView showStringPickerWithTitle:title dataSource:contents defaultSelValue:button.titleLabel.text isAutoSelect:NO themeColor:nil resultBlock:^(id selectValue, NSInteger index) {
        selectValueBlock(selectValue);
        self.page = 1;
        if ([selectValue isEqualToString:@"所有类别"]) {
            self.type = @"";
        } else if ([selectValue isEqualToString:@"热门游戏"]) {
            self.type = @"hot";
        } else if ([selectValue isEqualToString:@"彩金池游戏"]) {
            self.type = @"moneypool";
        } else if ([selectValue isEqualToString:@"最新游戏"]) {
            self.type = @"new";
        } else if ([selectValue isEqualToString:@"全平台"]) {
            self.platform = @"";
        } else if ([selectValue isEqualToString:@"MG"] ||
                   [selectValue isEqualToString:@"AG"] ||
                   [selectValue isEqualToString:@"PT"] ||
                   [selectValue isEqualToString:@"TTG"] ||
                   [selectValue isEqualToString:@"PP"]) {
            self.platform = selectValue;
        } else if ([selectValue isEqualToString:@"全赔付"]) {
            self.line = @"";
        } else if ([selectValue isEqualToString:@"1-4线"]) {
            self.line = @"1-4";
        } else if ([selectValue isEqualToString:@"5-9线"]) {
            self.line = @"5-9";
        } else if ([selectValue isEqualToString:@"15-25线"]) {
            self.line = @"15-25";
        } else if ([selectValue isEqualToString:@"30-50线"]) {
            self.line = @"30-50";
        } else if ([selectValue isEqualToString:@"51-243线"]) {
            self.line = @"51-243";
        }
        
        [self showLoading];
        [self loadGamesData];
    }];
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSLog(@"%zd", indexPath.item);
    IVGameModel *model = [[IVGameModel alloc] init];
    if (self.isFavorite) {
        if (self.favorites.count > 1) {
            if (indexPath.row >= 3) {
                BTTVideoGameModel *gameModel = self.favorites.count ? self.favorites[indexPath.row - 3] : nil;
                if (!gameModel.gameid.length) {
                    return;
                }
                model.cnName = gameModel.cnName;
                model.enName = gameModel.engName;
                model.provider = gameModel.provider;
                model.gameId = gameModel.gameid;
                model.gameType = [NSString stringWithFormat:@"%@",@(gameModel.gameType)];
                model.gameStyle = gameModel.gameStyle;
                [[IVGameManager sharedManager] forwardToGameWithModel:model controller:self];
            }
        }
    } else {
        if (self.isShowSearchBar) {
            if (indexPath.row >= 4 && self.games.count > 1) {
                BTTVideoGameModel *gameModel = self.games.count ? self.games[indexPath.row - 4] : nil;
                if (!gameModel.gameid.length) {
                    return;
                }
                model.cnName = gameModel.cnName;
                model.enName = gameModel.engName;
                model.provider = gameModel.provider;
                model.gameId = gameModel.gameid;
                model.gameType = [NSString stringWithFormat:@"%@",@(gameModel.gameType)];
                model.gameStyle = gameModel.gameStyle;
                [[IVGameManager sharedManager] forwardToGameWithModel:model controller:self];
            }
        } else {
            if (indexPath.row >= 3 && self.games.count > 1) {
                BTTVideoGameModel *gameModel = self.games.count ? self.games[indexPath.row - 3] : nil;
                if (!gameModel.gameid.length) {
                    return;
                }
                model.cnName = gameModel.cnName;
                model.enName = gameModel.engName;
                model.provider = gameModel.provider;
                model.gameId = gameModel.gameid;
                model.gameType = [NSString stringWithFormat:@"%@",@(gameModel.gameType)];
                model.gameStyle = gameModel.gameStyle;
                [[IVGameManager sharedManager] forwardToGameWithModel:model controller:self];
            }
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
    NSInteger total = 0;
    if (self.isFavorite) {
        if (self.favorites.count > 1) {
            total = 3 + self.favorites.count;
        } else {
            total = 5;
        }
    } else {
        if (self.isShowSearchBar) {
            if (self.games.count > 1) {
                total = 4 + self.games.count;
            } else {
                total = 6;
            }
        } else {
            if (self.games.count > 1) {
                total = 3 + self.games.count;
            } else {
                total = 5;
            }
        }
    }
    for (int i = 0; i < total; i++) {
        if (self.isFavorite) {
            if (self.favorites.count > 1) {
               
                if (i == 0) {
                    [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, BTTBnnnerDefaultHeight * (SCREEN_WIDTH / BTTBannerDefaultWidth))]];
                } else if (i == 1) {
                    [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 40)]];
                } else if (i == 2) {
                    [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 30)]];
                } else {
                    if (self.isShowFooter) {
                        if (i == total - 1) {
                            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 140)]];
                        } else {
                            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH / 2, (SCREEN_WIDTH / 2 - 22.5) / 130 * 90 + 105)]];
                        }
                    } else {
                        [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH / 2, (SCREEN_WIDTH / 2 - 22.5) / 130 * 90 + 105)]];
                    }
                }
                
            } else {
                if (i == 0) {
                    [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, BTTBnnnerDefaultHeight * (SCREEN_WIDTH / BTTBannerDefaultWidth))]];
                } else if (i == 1) {
                    [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 40)]];
                } else if (i == 2) {
                    [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 30)]];
                } else if (i == 4) {
                    [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - BTTBnnnerDefaultHeight * (SCREEN_WIDTH / BTTBannerDefaultWidth) - 260)]];
                } else {
                    [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 50)]];
                }
            }
        } else {
            if (self.isShowSearchBar) {
                if (self.games.count > 1) {
                    if (i == 0) {
                        if (@available(iOS 11, *)) {
                            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 56)]];
                        } else {
                            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
                        }
                    } else if (i == 1) {
                        [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, BTTBnnnerDefaultHeight * (SCREEN_WIDTH / BTTBannerDefaultWidth))]];
                    } else if (i == 2) {
                        [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 40)]];
                    } else if (i == 3) {
                        [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 30)]];
                    } else {
                        if (self.isShowFooter) {
                            if (i == total - 1) {
                                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 140)]];
                            } else {
                                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH / 2, (SCREEN_WIDTH / 2 - 22.5) / 130 * 90 + 105)]];
                            }
                        } else {
                            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH / 2, (SCREEN_WIDTH / 2 - 22.5) / 130 * 90 + 105)]];
                        }
                    }
                } else {
                    if (i == 0) {
                        if (@available(iOS 11, *)) {
                            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 56)]];
                        } else {
                            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
                        }
                    } else if (i == 1) {
                        [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, BTTBnnnerDefaultHeight * (SCREEN_WIDTH / BTTBannerDefaultWidth))]];
                    } else if (i == 2) {
                        [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 40)]];
                    } else if (i == 3) {
                        [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 30)]];
                    } else if (i == 4) {
                        [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - BTTBnnnerDefaultHeight * (SCREEN_WIDTH / BTTBannerDefaultWidth) - 260)]];
                    } else {
                        [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 100)]];
                    }
                }
                
            } else {
                if (self.games.count > 1) {
                    if (i == 0) {
                        [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, BTTBnnnerDefaultHeight * (SCREEN_WIDTH / BTTBannerDefaultWidth))]];
                    } else if (i == 1) {
                        [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 40)]];
                    } else if (i == 2) {
                        [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 30)]];
                    } else {
                        if (self.isShowFooter) {
                            if (i == total - 1) {
                                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 140)]];
                            } else {
                                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH / 2, (SCREEN_WIDTH / 2 - 22.5) / 130 * 90 + 105)]];
                            }
                        } else {
                            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH / 2, (SCREEN_WIDTH / 2 - 22.5) / 130 * 90 + 105)]];
                        }
                    }
                } else {
                    if (i == 0) {
                        [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, BTTBnnnerDefaultHeight * (SCREEN_WIDTH / BTTBannerDefaultWidth))]];
                    } else if (i == 1) {
                        [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 40)]];
                    } else if (i == 2) {
                        [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 30)]];
                    } else if (i == 4) {
                        [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - BTTBnnnerDefaultHeight * (SCREEN_WIDTH / BTTBannerDefaultWidth) - 260)]];
                    } else {
                        [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 100)]];
                    }
                }
            }
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}


- (NSMutableArray *)games {
    if (!_games) {
        _games = [NSMutableArray array];
    }
    return _games;
}


- (NSMutableArray *)favorites {
    if (!_favorites) {
        _favorites = [NSMutableArray array];
    }
    return _favorites;
}

@end
