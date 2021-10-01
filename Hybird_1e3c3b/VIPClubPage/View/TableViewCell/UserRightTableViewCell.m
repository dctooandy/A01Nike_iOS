//
//  UserRightTableViewCell.m
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/5/11.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "UserRightTableViewCell.h"
#import "BTTVIPClubHistoryCell.h"
#import "VIPRightFirstCell.h"
#import "VIPRightUpgradeCell.h"
#import "VIPRightWashRateCell.h"
#import "VIPRightRightsCell.h"
#import "VIPRightRightsDescriptCell.h"
#import "VIPRightTravelCell.h"
#import "VIPRightHistoryCell.h"
#import "GradientImage.h"
#import "BTTVIPClubFlowLayout.h"

@interface UserRightTableViewCell () <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) BTTVIPClubFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableArray<NSValue *> *elementsHight;
@property (nonatomic, strong) NSMutableArray *cellNameArray;
@property (weak, nonatomic) IBOutlet UIButton *discriptionButton;
@property (weak, nonatomic) IBOutlet UIImageView *backGroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *wordImageView;
@property (weak, nonatomic) IBOutlet UIImageView *displayNoteOne;
@property (weak, nonatomic) IBOutlet UIImageView *displayNoteTwo;
@property (weak, nonatomic) IBOutlet UIImageView *displayNoteThree;
@property (weak, nonatomic) IBOutlet UIImageView *rightLeftArrowIconImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *travelLargeButton;
@property (weak, nonatomic) IBOutlet UIButton *travelSmallButton;

@property (nonatomic, assign) BTTVIPClubUserRightPageType cellType;
@property (nonatomic, assign) BOOL isRightArrow;
@property (assign, nonatomic) BOOL confirmTransform;
@property (nonatomic, strong) NSMutableArray *cellHistoryArray;
@end
@implementation UserRightTableViewCell
@synthesize collectionView;
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setCollectionView];
    self.backgroundColor = [UIColor clearColor];
    self.isRightArrow = YES;
    self.confirmTransform = YES;/// 小大小cell 動畫效果
    _cellHistoryArray = @[@"/www/yacht_tour/index.html",@"/www/yacht_tour2/index.html",@"/www/dream_island_trip/index.html",@"/www/ph_tour/index.html",@"/www/dream_island_trip2/index.html"].mutableCopy;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setupButtons];
}
- (void)setupButtons
{
    [self.discriptionButton.layer setCornerRadius:self.discriptionButton.frame.size.height/2];
    [self.discriptionButton.layer setBorderWidth:1];
    [self.discriptionButton.layer setBorderColor:[UIColor colorWithHexString:@"FFFFFF" alpha:0.5f].CGColor];
    self.discriptionButton.backgroundColor = [UIColor colorWithHexString:@"FFFFFF" alpha:0.08f];
    [self.discriptionButton setUserInteractionEnabled:YES];
    [self.contentView bringSubviewToFront:self.discriptionButton];
    [self.contentView bringSubviewToFront:self.travelLargeButton];
    [self.contentView bringSubviewToFront:self.travelSmallButton];
}
- (void)setCollectionView
{
    BTTVIPClubFlowLayout *flowLayout = [[BTTVIPClubFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout = flowLayout;
    
    UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:_flowLayout];
    mainView.backgroundColor = [UIColor clearColor];
    mainView.pagingEnabled = NO;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.showsVerticalScrollIndicator = NO;

    [mainView registerNib:[UINib nibWithNibName:@"VIPRightFirstCell" bundle:nil] forCellWithReuseIdentifier:@"VIPRightFirstCell"];
    [mainView registerNib:[UINib nibWithNibName:@"VIPRightUpgradeCell" bundle:nil] forCellWithReuseIdentifier:@"VIPRightUpgradeCell"];
    [mainView registerNib:[UINib nibWithNibName:@"VIPRightWashRateCell" bundle:nil] forCellWithReuseIdentifier:@"VIPRightWashRateCell"];
    [mainView registerNib:[UINib nibWithNibName:@"VIPRightRightsCell" bundle:nil] forCellWithReuseIdentifier:@"VIPRightRightsCell"];
    [mainView registerNib:[UINib nibWithNibName:@"VIPRightRightsDescriptCell" bundle:nil] forCellWithReuseIdentifier:@"VIPRightRightsDescriptCell"];
    [mainView registerNib:[UINib nibWithNibName:@"VIPRightTravelCell" bundle:nil] forCellWithReuseIdentifier:@"VIPRightTravelCell"];
    [mainView registerNib:[UINib nibWithNibName:@"VIPRightHistoryCell" bundle:nil] forCellWithReuseIdentifier:@"VIPRightHistoryCell"];
    mainView.dataSource = self;
    mainView.delegate = self;
    mainView.scrollsToTop = NO;
    [self.contentView addSubview:mainView];
    self.collectionView = mainView;
}
- (void)config:(BTTVIPClubUserRightPageType)cellType
{
    self.cellType = cellType;
    float collectionViewHeight = (_cellType == VIPRightRightsDescriptPage) ? SCREEN_HEIGHT + 300 : SCREEN_HEIGHT;
    CGRect oldFrame = self.collectionView.frame;
    oldFrame.size.height = collectionViewHeight;
    [self.collectionView setFrame:oldFrame];
    [self setupElements];
}
- (void)setCellType:(BTTVIPClubUserRightPageType )cellType
{
    _cellType = cellType;
    [_flowLayout setCellType:self.cellType];
    [_flowLayout setConfirmTransform:_confirmTransform];
}
-(void)setupElements {
    NSMutableArray *elementsHight = [NSMutableArray array];
    NSInteger count = 0;
    NSInteger diffSpacing  = 0;
    CGFloat defaultHeight = SCREEN_HEIGHT - 49;
    
    CGFloat topTitleHeightConstraint =  0.08;
    CGFloat firstPageHeight = 0.162;
    
    CGFloat bottomViewHeightConstraint =  0.14;
    CGFloat washRatePageBottomHeight = 0.1;
    CGFloat ssrTravelBottomHeight = 0.19;
    CGFloat historyPageBottomHeight = 0.12;
    
    CGFloat cellHeightRate = 0.6;
    CGFloat cellTopSpaceRate = 0.2;
    CGFloat cellBottomRate = (1 - cellHeightRate - cellTopSpaceRate);
    
    CGFloat detailCellWidthSpaceRate = 0.06;
    [self.displayNoteOne setHidden:YES];
    [self.displayNoteTwo setHidden:YES];
    [self.displayNoteThree setHidden:YES];
    [self.rightLeftArrowIconImageView setHidden:YES];
    [self.collectionView setPagingEnabled:NO];
    [self.travelLargeButton setHidden:YES];
    [self.travelSmallButton setHidden:YES];
    [self.discriptionButton setTitle:@"特别说明" forState:UIControlStateNormal];
    switch (_cellType) {
        case VIPRightFirstPage:
            count = 1;
            diffSpacing = 0;
            cellHeightRate = 1;
            cellTopSpaceRate = 0;
            detailCellWidthSpaceRate = 0;
            self.backGroundImage.image = ImageNamed(@"VIP1_BG Copy");
            self.wordImageView.image = ImageNamed(@"SliceWordFirstPage");
            _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
            topTitleHeightConstraint = firstPageHeight;
            [self.discriptionButton setHidden:YES];
            break;
        case VIPRightUpgradePage:
            count = 6;
            diffSpacing = (_confirmTransform == YES ? 0 : -18);
            cellHeightRate = (_confirmTransform == YES ? 0.496 : 0.62);
            cellTopSpaceRate = 0.17;
            defaultHeight = SCREEN_HEIGHT*cellHeightRate;
            detailCellWidthSpaceRate = (SCREEN_WIDTH - defaultHeight/370*250)/2/SCREEN_WIDTH;
            self.backGroundImage.image = ImageNamed(@"Upgrade_BG");
            self.wordImageView.image = ImageNamed(@"Group 9");
            _cellNameArray = @[@"OneStarCopy",@"TwoStarCopy",@"ThreeStarCopy",@"FourStarCopy",@"FiveStarCopy",@"SixStarCopy"].mutableCopy;
            [self.discriptionButton setHidden:NO];
            break;
        case VIPRightWashRatePage:
            count = 6;
            diffSpacing = -20;
            cellHeightRate = 0.6;
            cellTopSpaceRate = 0.23;
            defaultHeight = SCREEN_HEIGHT*cellHeightRate;
            self.backGroundImage.image = ImageNamed(@"BinWash_BG");
            self.wordImageView.image = ImageNamed(@"SliceWordWashRate");
            _cellNameArray = @[@"OneStarMember",@"TwoStarMember",@"ThreeStarMember",@"FourStarMember",@"FiveStarMember",@"SixStarMember"].mutableCopy;
            bottomViewHeightConstraint = washRatePageBottomHeight;
            [self.discriptionButton setHidden:NO];
            break;
        case VIPRightRights:
            count = 6;
            diffSpacing = -20;
            cellHeightRate = 0.6;
            cellTopSpaceRate = 0.23;
            defaultHeight = SCREEN_HEIGHT*cellHeightRate;
            self.backGroundImage.image = ImageNamed(@"SliceRights_BG");
            self.wordImageView.image = ImageNamed(@"SliceWordRights");
            _cellNameArray = @[@"SliceRights_OneStar",@"SliceRights_TwoStar",@"SliceRights_ThreeStar",@"SliceRights_FourStar",@"SliceRights_FiveStar",@"SliceRights_SixStar"].mutableCopy;
            [self.discriptionButton setHidden:YES];
            break;
        case VIPRightRightsDescriptPage:
            count = 1;
            diffSpacing = 0;
            cellHeightRate = 0.54;
            cellTopSpaceRate = 0.24;
            defaultHeight = (SCREEN_HEIGHT - 49 + 300);
            self.backGroundImage.image = ImageNamed(@"SliceRightsDescript_BG");
            self.wordImageView.image = ImageNamed(@"SliceWordRightsDescript");
            detailCellWidthSpaceRate = 0;
            _cellNameArray = @[@"SliceRightsDescript_PageOne",@"SliceRightsDescript_PageTwo"].mutableCopy;
//            [self.collectionView setPagingEnabled:YES];
            [self.discriptionButton setHidden:YES];
            [self.displayNoteOne setHidden:NO];
            [self.rightLeftArrowIconImageView setHidden:YES];
            break;
        case VIPRightTravelPage:
            count = 2;
            diffSpacing = -40;
            cellHeightRate = 0.6;
            cellTopSpaceRate = 0.36;
            defaultHeight = SCREEN_HEIGHT*cellHeightRate;
            self.backGroundImage.image = ImageNamed(@"SliceTravel_BG");
            self.wordImageView.image = ImageNamed(@"SliceWordTravel");
            detailCellWidthSpaceRate = 0;
            _cellNameArray = @[@"SliceSSRTravel",@"SliceSpecialTravel"].mutableCopy;
            bottomViewHeightConstraint = ssrTravelBottomHeight;
//            [self.collectionView setPagingEnabled:YES];
            [self.discriptionButton setHidden:NO];
            [self.displayNoteTwo setHidden:NO];
            [self.travelLargeButton setHidden:NO];
            [self.travelSmallButton setHidden:NO];
            break;
        case VIPRightHistoryPage:
            count = 5;
            diffSpacing = -20;
            cellHeightRate = 0.6;
            cellTopSpaceRate = 0.23;
            defaultHeight = SCREEN_HEIGHT*cellHeightRate;
            self.backGroundImage.image = ImageNamed(@"SliceTravel_History_BG");
            self.wordImageView.image = ImageNamed(@"SliceWordTravelHistory");
            _cellNameArray = @[@"SliceTravelImageS1",@"SliceTravelImageS2",@"SliceTravelImageS3",@"SliceTravelImageS4",@"SliceTravelImageS5"].mutableCopy;
            bottomViewHeightConstraint = historyPageBottomHeight;
            [self.discriptionButton setHidden:NO];
            [self.discriptionButton setTitle:@"查看回顾" forState:UIControlStateNormal];
            [self.displayNoteThree setHidden:NO];
            break;
        default:
            break;
    }
    if (_cellType == VIPRightRightsDescriptPage)
    {
        _flowLayout.sectionInset = UIEdgeInsetsMake(0,
                                                    SCREEN_WIDTH*detailCellWidthSpaceRate,
                                                    0,
                                                    SCREEN_WIDTH*detailCellWidthSpaceRate);
    }else
    {
        _flowLayout.sectionInset = UIEdgeInsetsMake(SCREEN_HEIGHT*cellTopSpaceRate,
                                                    SCREEN_WIDTH*detailCellWidthSpaceRate,
                                                    SCREEN_HEIGHT*cellBottomRate,
                                                    SCREEN_WIDTH*detailCellWidthSpaceRate);
    }
    _flowLayout.minimumLineSpacing = diffSpacing*2;
    self.topViewHeight.constant = SCREEN_HEIGHT * topTitleHeightConstraint;
    self.bottomViewHeight.constant = SCREEN_HEIGHT * bottomViewHeightConstraint;
    
    for (int i = 0; i < count; i++) {
        [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH*(1 - detailCellWidthSpaceRate * 2) , defaultHeight)]];
    }
    self.elementsHight = elementsHight.mutableCopy;
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}
#pragma mark - UICollectionViewDataSource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.elementsHight[indexPath.item].CGSizeValue;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.elementsHight.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    weakSelf(weakSelf);
    BTTBaseCollectionViewCell * cell;
    switch (_cellType) {
        case VIPRightFirstPage:
        {
            cell = (VIPRightFirstCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"VIPRightFirstCell" forIndexPath:indexPath];
            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                strongSelf(strongSelf);
                if (strongSelf.buttonClickBlock) {
                    strongSelf.buttonClickBlock(button);
                }
            };
        }
            break;
        case VIPRightUpgradePage:
        {
            cell = (VIPRightUpgradeCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"VIPRightUpgradeCell" forIndexPath:indexPath];
            [[(VIPRightUpgradeCell *)cell cellImageView] setImage:ImageNamed(_cellNameArray[indexPath.item])];
        }
            break;
        case VIPRightWashRatePage:
        {
            cell = (VIPRightWashRateCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"VIPRightWashRateCell" forIndexPath:indexPath];
            [[(VIPRightWashRateCell *)cell cellImageView] setImage:ImageNamed(_cellNameArray[indexPath.item])];
        }
            break;
        case VIPRightRights:
        {
            cell = (VIPRightRightsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"VIPRightRightsCell" forIndexPath:indexPath];
            [[(VIPRightRightsCell *)cell cellImageView] setImage:ImageNamed(_cellNameArray[indexPath.item])];
        }
            break;
        case VIPRightRightsDescriptPage:
        {
            cell = (VIPRightRightsDescriptCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"VIPRightRightsDescriptCell" forIndexPath:indexPath];
//            [[(VIPRightRightsDescriptCell *)cell cellImageView] setImage:ImageNamed(_cellNameArray[1])];
//            [[(VIPRightRightsDescriptCell *)cell cellSecondImageView] setImage:ImageNamed(_cellNameArray[0])];
        }
            break;
        case VIPRightTravelPage:
        {
            cell = (VIPRightTravelCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"VIPRightTravelCell" forIndexPath:indexPath];
            [[(VIPRightTravelCell *)cell cellImageView] setImage:ImageNamed(_cellNameArray[indexPath.item])];
        }
            break;
        case VIPRightHistoryPage:
        {
            cell = (VIPRightHistoryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"VIPRightHistoryCell" forIndexPath:indexPath];
            [[(VIPRightHistoryCell *)cell cellImageView] setImage:ImageNamed(_cellNameArray[indexPath.item])];
            weakSelf(weakSelf)
            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                [weakSelf pushToHistoryWebViewWithRow:indexPath.item];
            };
        }
            break;
        default:
            break;
    }
    return cell;
}
- (void)pushToHistoryWebViewWithRow:(NSInteger)sender
{
    NSString * urlString = _cellHistoryArray[sender];
    UIViewController *topVC = [PublicMethod currentViewController];
    if ([topVC isKindOfClass:[BTTBaseWebViewController class]]) {
        BTTBaseWebViewController *topWebVC = (BTTBaseWebViewController *)topVC;
        if (topWebVC.webConfigModel.newView) {
            topWebVC.webConfigModel.url = urlString;
            [topWebVC loadWebView];
            return;
        }
    }
    BTTBaseWebViewController  *webController = [[BTTBaseWebViewController alloc] init];
    webController.webConfigModel.url = urlString;
    webController.webConfigModel.newView = YES;
    [webController loadWebView];
    [topVC.navigationController pushViewController:webController animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self animationForDescriptTravelPage];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self animationForDescriptTravelPage];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self animationForDescriptTravelPage];
}
-(void)animationForDescriptTravelPage
{
    switch (_cellType) {
        case VIPRightRightsDescriptPage:
        {
            int itemIndex = [self currentIndex];
            [self animationArrowIcon:(itemIndex == 0)];
        }
        case VIPRightTravelPage:
        {
            int itemIndex = [self currentIndex];
            [self.travelLargeButton setTitle:(itemIndex == 0 ? @"游艇豪华游" : @"尊贵风情游") forState:UIControlStateNormal];
            [self.travelSmallButton setTitle:(itemIndex == 0 ? @"尊贵风情游" : @"游艇豪华游") forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}
- (void)animationArrowIcon:(BOOL)toRight
{
    weakSelf(weakSelf)
    if (toRight == YES)
    {
        if (self.isRightArrow == YES)
        {
            return;
        }else
        {
            self.isRightArrow = YES;
            [UIView animateWithDuration:0.3 animations:^{
                [weakSelf.rightLeftArrowIconImageView setAlpha:0.0];
            } completion:^(BOOL finished) {
                [weakSelf.rightLeftArrowIconImageView setAlpha:1.0];
                weakSelf.rightLeftArrowIconImageView.image = ImageNamed(@"Icon_Arrow_Right");
            }];
        }
    }else
    {
        if (self.isRightArrow == NO)
        {
            return;
        }else
        {
            self.isRightArrow = NO;
            [UIView animateWithDuration:0.3 animations:^{
                [weakSelf.rightLeftArrowIconImageView setAlpha:0.0];
            } completion:^(BOOL finished) {
                [weakSelf.rightLeftArrowIconImageView setAlpha:1.0];
                weakSelf.rightLeftArrowIconImageView.image = ImageNamed(@"Icon_Arrow_Left");
            }];
        }
    }
}
- (int)currentIndex
{
    CGFloat itemWidth = [[_elementsHight firstObject] CGSizeValue].width;
    CGFloat itemHeight = [[_elementsHight firstObject] CGSizeValue].height;
    int index = 0;
    if (_flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (self.collectionView.contentOffset.x + itemWidth * 0.5) / itemWidth;
    } else {
        index = (self.collectionView.contentOffset.y + itemHeight * 0.5) / itemHeight;
    }
    return MAX(0, index);
}

- (int)pageControlIndexWithCurrentCellIndex:(NSInteger)index
{
    return (int)index % 2;
}

- (IBAction)discriptionButtonAction:(UIButton *)sender {
    if (self.buttonClickBlock)
    {
        switch (_cellType) {
            case VIPRightUpgradePage:
                sender.tag = 2001;
                self.buttonClickBlock(sender);
                break;
            case VIPRightWashRatePage:
                sender.tag = 2000;
                self.buttonClickBlock(sender);
                break;
            case VIPRightTravelPage:
                sender.tag = 2002;
                self.buttonClickBlock(sender);
                break;
            case VIPRightHistoryPage:
                sender.tag = 3000;
            {
                int itemIndex = [self currentIndex];
                [self pushToHistoryWebViewWithRow:itemIndex];
            }
                break;
            default:
                break;
        }
        
    }
}
- (IBAction)travelNoteChangeAction:(UIButton *)sender {
    
    switch (_cellType) {
        case VIPRightTravelPage:
        {
            int itemIndex = [self currentIndex];
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(itemIndex == 0 ? 1 : 0) inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
