//
//  YCTMineEditLabelViewController.m
//  YCT
//
//  Created by 木木木 on 2021/12/25.
//

#import "YCTMineEditLabelViewController.h"
#import "YCTTagsView.h"
#import "YCTApiGetUserTags.h"
#import "YCTApiUpdateUserInfo.h"
#import "YCTUserDataManager+Update.h"

#define kTagsTop (kNavigationBarHeight)

@interface YCTMineEditLabelViewController ()<YCTTagsViewDelegate>
@property (nonatomic, strong) YCTTagsView *systemTagsView;
@property (nonatomic, strong) YCTTagsView *customTagsView;
@property (nonatomic, strong) UIBarButtonItem *saveItem;

@property (nonatomic, copy) NSArray<NSString *> *systemsTags;
@property (nonatomic, copy) NSArray<NSString *> *selectedTags;
@end

@implementation YCTMineEditLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedTags = self.orginalLabels;
    
    self.title = YCTLocalizedTableString(@"mine.title.personalityLabel", @"Mine");
    
    self.customTagsView.tags = self.orginalLabels;
    [self.customTagsView reloadData];
    
    [[YCTHud sharedInstance] showLoadingHud];
    [[YCTApiGetUserTags new] startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
        NSArray<YCTUserTagModel *> *userTagModels = request.responseDataModel;
        if (YCT_IS_ARRAY(userTagModels)) {
            NSMutableArray *tags = @[].mutableCopy;
            [userTagModels enumerateObjectsUsingBlock:^(YCTUserTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [tags addObject:obj.tagName];
            }];
            self.systemsTags = tags;
            
            NSMutableSet *customTagsSet = [NSMutableSet setWithArray:self.orginalLabels];
            NSMutableSet *systemTagsSet = [NSMutableSet setWithArray:self.systemsTags];
            [customTagsSet minusSet:systemTagsSet];
        
            self.customTagsView.tags = customTagsSet.allObjects;
            [self.customTagsView updateSelectedTags:customTagsSet.allObjects];
            [self.customTagsView reloadData];
            
            self.systemTagsView.tags = self.systemsTags;
            [systemTagsSet intersectSet:[NSSet setWithArray:self.orginalLabels]];
            [self.systemTagsView updateSelectedTags:systemTagsSet.allObjects];
            [self.systemTagsView reloadData];
        } else {
            self.customTagsView.tags = self.orginalLabels;
            [self.customTagsView updateSelectedTags:self.orginalLabels];
            [self.customTagsView reloadData];
        }
        [self layoutTagsView];
        [[YCTHud sharedInstance] hideHud];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        self.customTagsView.tags = self.orginalLabels;
        [self.customTagsView reloadData];
        
        [self layoutTagsView];
        [[YCTHud sharedInstance] hideHud];
    }];
}

- (void)bindViewModel {
    @weakify(self);
    
    RAC(self.saveItem, enabled) = [RACObserve(self, selectedTags) map:^id _Nullable(NSArray * _Nullable tags) {
        @strongify(self);
        if (tags.count == 0) {
            return @(NO);
        }
        if (tags.count != self.orginalLabels.count) {
            return @(YES);
        }
        NSMutableSet *tagsSet = [NSMutableSet setWithArray:tags];
        NSSet *orginalTagsSet = [NSSet setWithArray:self.orginalLabels];
        [tagsSet minusSet:orginalTagsSet];
        return @(!(tagsSet.count == 0));
    }];
}

- (void)setupView {
    [self.view addSubview:self.systemTagsView];
    [self.view addSubview:self.customTagsView];
    
    self.navigationItem.rightBarButtonItem = ({
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:YCTLocalizedTableString(@"mine.save", @"Mine") style:(UIBarButtonItemStylePlain) target:self action:@selector(saveClick)];
        [item setTitleTextAttributes:@{
            NSFontAttributeName: [UIFont PingFangSCMedium:16],
            NSForegroundColorAttributeName: UIColor.mainThemeColor
        } forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{
            NSFontAttributeName: [UIFont PingFangSCMedium:16],
            NSForegroundColorAttributeName: UIColor.mainThemeColorLight
        } forState:UIControlStateDisabled];
        self.saveItem = item;
        item;
    });
}

- (void)saveClick {
    [self.view endEditing:YES];
    
    NSMutableArray *tags = @[].mutableCopy;
    [self.selectedTags enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj hasPrefix:@"#"]) {
            [tags addObject:[obj stringByReplacingCharactersInRange:(NSRange){0, 1} withString:@""]];
        } else {
            [tags addObject:obj];
        }
    }];
    if(tags.count>6){
        [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedTableString(@"mine.companyInfo.maxTag", @"Mine")];
        return;
    }
    YCTApiUpdateUserInfo *api = [[YCTApiUpdateUserInfo alloc] initWithType:(YCTApiUpdateUserInfoTags) value:[tags componentsJoinedByString:@","] ?: @""];
    [[YCTHud sharedInstance] showLoadingHud];
    [api startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTUserDataManager sharedInstance] updateUserTags:self.selectedTags];
        [[YCTHud sharedInstance] hideHud];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(__kindof YCTBaseRequest * _Nonnull request) {
        [[YCTHud sharedInstance] showDetailToastHud:request.getError];
    }];
}

- (void)layoutTagsView {
    CGFloat height = 0;
    if (self.systemTagsView.tags.count > 0) {
        height = [YCTTagsView getHeightWithTags:self.systemTagsView.tags tagAttribute:self.systemTagsView.tagAttributeConfiguration width:self.view.frame.size.width];
    }
    self.systemTagsView.frame = CGRectMake(0, kTagsTop, self.view.frame.size.width, height);
    
    CGFloat customTagsHeight = [YCTTagsView getHeightWithTags:self.customTagsView.tags tagAttribute:self.customTagsView.tagAttributeConfiguration width:self.view.frame.size.width];
    
    self.customTagsView.hidden = NO;
    self.customTagsView.frame = CGRectMake(0, CGRectGetMaxY(self.systemTagsView.frame), self.view.frame.size.width, customTagsHeight);
}

- (void)updateTags {
    NSMutableArray *tags = [NSMutableArray array];
    [tags addObjectsFromArray:self.systemTagsView.selectedTags];
    [tags addObjectsFromArray:self.customTagsView.selectedTags];
    self.selectedTags = tags.copy;
}

#pragma mark - YCTTagsViewDelegate

- (BOOL)tagsView:(YCTTagsView *)tagsView shouldSelectIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tagsView:(YCTTagsView *)tagsView didSelectTags:(NSArray *)tags {
    [self updateTags];
}

- (void)tagsViewDidAddNewTag:(YCTTagsView *)tagsView {
    if (tagsView == self.customTagsView) {
        [self layoutTagsView];
    }
}

- (void)tagsViewDidRemoveTag:(YCTTagsView *)tagsView {
    if (tagsView == self.customTagsView) {
        [self layoutTagsView];
    }
    [self updateTags];
}

#pragma mark - Getter

- (YCTTagsView *)systemTagsView {
    if (!_systemTagsView) {
        _systemTagsView = [[YCTTagsView alloc] init];
        _systemTagsView.delegate = self;
        _systemTagsView.isMultiSelect = YES;
        YCTTagAttributeConfiguration *configuration = _systemTagsView.tagAttributeConfiguration;
        configuration.displayType = YCTTagDisplayTypeNormal;
        configuration.sectionInset = UIEdgeInsetsMake(15, 5, 0, 5);
        configuration.normalBackgroundColor = UIColor.tableBackgroundColor;
        configuration.selectedBackgroundColor = UIColor.mainThemeColor;
        [self.view addSubview:_systemTagsView];
    }
    return _systemTagsView;
}

- (YCTTagsView *)customTagsView {
    if (!_customTagsView) {
        _customTagsView = [[YCTTagsView alloc] init];
        _customTagsView.delegate = self;
        _customTagsView.hidden = YES;
        _customTagsView.isMultiSelect = YES;
        YCTTagAttributeConfiguration *configuration = _customTagsView.tagAttributeConfiguration;
        configuration.displayType = YCTTagDisplayTypeOperation;
        configuration.sectionInset = UIEdgeInsetsMake(15, 5, 15, 5);
        configuration.normalBackgroundColor = UIColor.tableBackgroundColor;
        configuration.selectedBackgroundColor = UIColor.mainThemeColor;
        [self.view addSubview:_customTagsView];
    }
    return _customTagsView;
}

@end
