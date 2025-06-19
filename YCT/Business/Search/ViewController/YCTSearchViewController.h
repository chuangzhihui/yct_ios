//
//  YCTSearchViewController.h
//  YCT
//
//  Created by hua-cloud on 2021/12/20.
//

#import "YCTBaseViewController.h"
#import "YCTSearchViewModel.h"
#import <JXCategoryView/JXCategoryView.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTSearchNavView : UIView<UITextFieldDelegate>
@property (nonatomic, strong) UIView * cornerView;
@property (nonatomic, strong) UIButton * backButton;
@property (nonatomic, strong) UIButton * searchButton;
@property (nonatomic, strong) UIButton * scanButton;
@property (nonatomic, strong) UIButton * locationButton;
@property (nonatomic, strong) UITextField * searchTextField;

@property (nonatomic, strong) dispatch_block_t returnHandler;
@property (nonatomic, strong) dispatch_block_t textBeginEditingHandler;


@end

@interface YCTSearchViewController : YCTBaseViewController
@property (nonatomic, assign) BOOL isFromHomeSearch;
@property (nonatomic, assign) BOOL isCallApi;
@property (nonatomic, assign) NSString* name;
- (instancetype)initWithKeyWord:(NSString *)keyword defaultSearchType:(YCTSearchResultType)defaultSearchType;
@end

NS_ASSUME_NONNULL_END
