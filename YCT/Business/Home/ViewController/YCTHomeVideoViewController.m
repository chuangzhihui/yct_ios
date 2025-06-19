//
//  YCTHomeVideoViewController.m
//  YCT
//
//  Created by hua-cloud on 2021/12/12.
//

#import "YCTHomeVideoViewController.h"
#import "YCTVideoViewController.h"
#import "YCTApiHomeVideoList.h"
#import "YCTVideoModel.h"
#import "YCTRootViewController.h"

@interface YCTHomeVideoViewController ()
@property (nonatomic, strong) YCTVideoViewController * videoController;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray * videoModels;
@property (nonatomic, assign) YCTHomeVideoType type;
@property (nonatomic, copy) NSArray * ids;
@end

@implementation YCTHomeVideoViewController
- (instancetype)initWithType:(YCTHomeVideoType)type{
    if (self = [super init]) {
        self.page = 1;
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;
    //增加监听，当键盘出现或改变时收出消息
    
}

- (void)viewWillAppear:(BOOL)animated{
   
}

- (void)viewWillDisappear:(BOOL)animated{
    
}

- (void)setupView{
    
}

- (void)bindViewModel{
    @weakify(self);
    [RACObserve(self, videoModels) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (YCT_IS_VALID_ARRAY(x) && !self.videoController) {
            self.videoController = [[YCTVideoViewController alloc] initWithVideoModels:self.videoModels.copy
                                                                                 index:0
                                                                                  type:YCTVideoDetailTypeOther];
            [self addChildVC:self.videoController];
            [self.videoController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsZero);
            }];
            
            [self.videoController handleWithHeaderRefershCallback:^{
                @strongify(self);
                self.page = 1;
                [self requestForVideoData];
            }];
            
            [self.videoController handleWithFooerRefershCallback:^{
                @strongify(self);
                [self requestForVideoData];
            }];
        }else{
            [self.videoController updateModels:self.videoModels.copy refresh:self.page == 1];
        }
    }];
    
    if (self.type == YCTHomeVideoTypeRecommand) {
        [[YCTRootViewController sharedInstance].homeSelected subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self refresh];
        }];
    }
}



#pragma mark - request
- (void)refresh{
    self.page = 1;
    [self requestForVideoData];
}

- (void)loadMore{
    [self requestForVideoData];
}

- (void)requestForVideoData{
    if (self.page == 1) {
        self.ids = @[];
//        [[YCTHud sharedInstance] showLoadingHud];
    }
    YCTApiHomeVideoList * api = [[YCTApiHomeVideoList alloc] initWithPage:self.page type:self.type == YCTHomeVideoTypeRecommand ? YCTApiHomeVideoTypeRecommand : YCTApiHomeVideoTypeFocus ids:YCTString([self.ids componentsJoinedByString:@","], @"") user_type:_user_type];
    @weakify(self);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"请求主页数据成功");
        @strongify(self);
        NSArray<YCTVideoModel *> * models;
        if ([api.responseDataModel isKindOfClass:[NSMutableArray class]]) {
            models = YCTArray(api.responseDataModel, @[]);
        }else{
            models = YCTArray(((YCTVideoDataModel *)api.responseDataModel).datas, @[]).copy;
        }
        NSLog(@"datas:%@",request.responseString);
        if (self.page == 1) {
            [self.videoModels removeAllObjects];
        }
        [self.videoModels addObjectsFromArray:models];
        NSMutableArray * idsTemp = @[].mutableCopy;
        [self.videoModels enumerateObjectsUsingBlock:^(YCTVideoModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [idsTemp addObject:obj.id];
        }];
        self.ids = idsTemp.copy;
        self.videoModels = self.videoModels;
        if (self.page == 0) {
            self.page = 2;
        } else {
            self.page ++;
        }
        NSInteger size = 10;
//        if (self.type == YCTApiHomeVideoTypeRecommand) {
//            size = 5;
//        }
        if ((models.count >= size) == false) {
            self.page = 0;
            self.ids = @[];
        }
        
        [self.videoController endRefreshWithHasMore:models.count >= size];
        [[YCTHud sharedInstance] hideHud];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"请求主页数据失败：%@",request.requestUrl);
        NSLog(@"请求主页数据失败：%@",request.responseString);
        [[YCTHud sharedInstance] hideHud];
        self.page = 0;
        self.ids = @[];
        [self.videoController endRefreshWithHasMore:false];
        [self loadMore];
    }];
}

#pragma mark - getter

- (NSMutableArray *)videoModels{
    if (!_videoModels) {
        _videoModels = @[].mutableCopy;
    }
    return _videoModels;
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

/**
 可选实现，列表将要显示的时候调用
 */
- (void)listWillAppear{
    NSLog(@"viewWillappear");
}

/**
 可选实现，列表显示的时候调用
 */
- (void)listDidAppear{
    if (_videoController) {
        [self.videoController onWillAppear];
    }else{
        [self requestForVideoData];
    }
}

/**
 可选实现，列表将要消失的时候调用
 */
- (void)listWillDisappear{
    if (_videoController) {
        [self.videoController onWillDisappear];
    }
}

@end
