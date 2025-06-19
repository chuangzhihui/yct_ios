//
//  YCTPostTagsView.m
//  YCT
//
//  Created by 木木木 on 2021/12/28.
//

#import "YCTPostAddTagsView.h"

@interface YCTPostAddTagsView ()<YCTTagsViewDelegate>

@property (strong, nonatomic) YCTTagsView *systemTagsView;
@property (strong, nonatomic) YCTTagsView *customTagsView;

@end

@implementation YCTPostAddTagsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.limitCount = 6;
    
    self.systemTagsView = ({
        YCTTagsView *view = [[YCTTagsView alloc] init];
        view.isMultiSelect = YES;
        view.delegate = self;
        YCTTagAttributeConfiguration *configuration = view.tagAttributeConfiguration;
        configuration.scrollDirection = UICollectionViewScrollDirectionVertical;
        configuration.displayType = YCTTagDisplayTypeNormal;
        configuration.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        configuration.normalBackgroundColor = UIColor.tableBackgroundColor;
        configuration.selectedBackgroundColor = UIColor.mainThemeColor;
        view;
    });
    [self addSubview:self.systemTagsView];
    
    self.customTagsView = ({
        YCTTagsView *view = [[YCTTagsView alloc] init];
        view.isMultiSelect = YES;
        view.delegate = self;
        [view setCanScroll:NO];
        YCTTagAttributeConfiguration *configuration = view.tagAttributeConfiguration;
        configuration.displayType = YCTTagDisplayTypeOperation;
        configuration.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        configuration.normalBackgroundColor = UIColor.tableBackgroundColor;
        configuration.selectedBackgroundColor = UIColor.mainThemeColor;
        view;
    });
    [self addSubview:self.customTagsView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.systemTagsView.frame = CGRectMake(0, 0, self.frame.size.width, 29);
    self.customTagsView.frame = (CGRect){
        0,
        self.systemTagsView.hidden ? 0 : CGRectGetMaxY(self.systemTagsView.frame),
        self.frame.size.width,
        self.frame.size.height - (self.systemTagsView.hidden ? 0 : CGRectGetHeight(self.systemTagsView.frame))
    };
}

- (void)setSystemTags:(NSArray<NSString *> *)systemsTags
         selectedTags:(NSArray *)selectedTags {
    NSMutableSet *customTagsSet = [NSMutableSet setWithArray:selectedTags];
    NSMutableSet *systemTagsSet = [NSMutableSet setWithArray:systemsTags];
    [customTagsSet minusSet:systemTagsSet];

    self.customTagsView.tags = customTagsSet.allObjects;
    [self.customTagsView updateSelectedTags:customTagsSet.allObjects];
    [self.customTagsView reloadData];
    
    self.systemTagsView.tags = systemsTags;
    [systemTagsSet intersectSet:[NSSet setWithArray:selectedTags]];
    [self.systemTagsView updateSelectedTags:systemTagsSet.allObjects];
    [self.systemTagsView reloadData];
    self.systemTagsView.hidden = (systemsTags.count == 0);
    
    [self delegateUpdateSelectStatus];
    [self setNeedsLayout];
}

- (NSArray<NSString *> *)systemTags {
    return self.systemTagsView.selectedTags;
}

- (NSArray<NSString *> *)customTags {
    return self.customTagsView.selectedTags;
}

#pragma mark - YCTTagsViewDelegate

- (BOOL)tagsView:(YCTTagsView *)tagsView shouldSelectIndexPath:(NSIndexPath *)indexPath {
    if (self.systemTags.count + self.customTags.count >= self.limitCount) {
        return NO;
    }
    return YES;
}

- (void)tagsView:(YCTTagsView *)tagsView didSelectTags:(NSArray *)tags {
    [self delegateUpdateSelectStatus];
}

- (void)tagsViewDidAddNewTag:(YCTTagsView *)tagsView {
    [self delegateUpdateHeight];
}

- (void)tagsViewDidRemoveTag:(YCTTagsView *)tagsView {
    [self delegateUpdateHeight];
    [self delegateUpdateSelectStatus];
}

#pragma mark - Private

- (void)delegateUpdateHeight {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTagViewUpdateHeight:)]) {
        CGFloat systemsTagsViewHeight = self.systemTagsView.hidden ? 0 : 29;
        CGFloat customTagsViewHeight = [YCTTagsView getHeightWithTags:self.customTagsView.tags tagAttribute:self.customTagsView.tagAttributeConfiguration width:self.bounds.size.width];
        [self.delegate didTagViewUpdateHeight:systemsTagsViewHeight + customTagsViewHeight];
    }
}

- (void)delegateUpdateSelectStatus {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectTags:)]) {
        NSMutableArray *tags = [NSMutableArray array];
        [tags addObjectsFromArray:self.systemTagsView.selectedTags];
        [tags addObjectsFromArray:self.customTagsView.selectedTags];
        [self.delegate didSelectTags:tags.copy];
    }
}

@end
