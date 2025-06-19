//
//  BGMAddTextAiVC+bgm.m
//  YCT
//
//  Created by 林涛 on 2025/4/3.
//

#import "BGMAddTextAiVC+bgm.h"
#import "YCTApiVideoGetMusics.h"
#import "YCTApiVideoGetMusicsGetAiBGMList.h"

@interface BGMAddTextAiVC()
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) YCTBgmMusicModel *music;

@end

@implementation BGMAddTextAiVC (bgm)
+(void)load{
    Method okSendText = class_getInstanceMethod(self.class, NSSelectorFromString(@"okSendText:"));
    Method yct_okSendText = class_getInstanceMethod(self.class, @selector(yct_okSendText:));
    method_exchangeImplementations(okSendText, yct_okSendText);
    
    Method regenerateUpText = class_getInstanceMethod(self.class, NSSelectorFromString(@"regenerateUpText:"));
    Method yct_regenerateUpText = class_getInstanceMethod(self.class, @selector(yct_regenerateUpText:));
    method_exchangeImplementations(regenerateUpText, yct_regenerateUpText);
    
    Method onLoadPituHide = class_getInstanceMethod(self.class, NSSelectorFromString(@"onLoadPituHide"));
    Method yct_onLoadPituHide = class_getInstanceMethod(self.class, @selector(yct_onLoadPituHide));
    method_exchangeImplementations(onLoadPituHide, yct_onLoadPituHide);
    
    
}

- (void)setMusic:(YCTBgmMusicModel *)music{
    objc_setAssociatedObject(self, @selector(setMusic:), music, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YCTBgmMusicModel *)music{
    return objc_getAssociatedObject(self, @selector(setMusic:));
}

//- (void)setGetCount:(NSInteger)getCount{
//    objc_setAssociatedObject(self, @selector(setGetCount:), @(getCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (NSInteger)getCount{
//    return [objc_getAssociatedObject(self, @selector(setGetCount:)) integerValue];
//}

- (void)setMakeProgressViewShow {
    UIWindowScene *windowScene = (UIWindowScene *)[[[UIApplication sharedApplication] connectedScenes] anyObject];
    UIWindow *mainWindow = windowScene.windows.firstObject;
    [mainWindow addSubview:self.progressVw];
    [self.progressVw show];
    
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    //        [keyWindow addSubview:self.progressVw];
    //    });
}
- (void)setMakeProgressViewHide {
    [self.progressVw hide];
}
- (void)setMakeProgressViewProgress:(double)progress {
    self.progressVw.progress = progress;
}
    
- (void)requestForMusicWithText:(NSString *)text completion:(void(^)(YCTBgmMusicModel * object))completion {
//    [[YCTHud sharedInstance] showProgress:0.001 text:@"音乐生成中.."];
    [self setMakeProgressViewShow];
    YCTApiVideoGetMusics * api = [[YCTApiVideoGetMusics alloc] initWithAddBgmAi:1 text:text];
    @weakify(self);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        NSLog(@"请求主页：%@",request.requestUrl);
        NSLog(@"datas:%@",request.responseString);
        // datas:{"code":1,"msg":"操作成功","data":{"task_id":"4ffc485ba6491f595114efc97fe17d30"}}
        id data = request.responseObject[@"data"];
        if (data) {
            [self getMusicUrls:data[@"task_id"] completion:completion];
        } else {
            [[YCTHud sharedInstance] showFailedHud:@"生成Ai失败，请重新编辑内容"];
            [self setMakeProgressViewHide];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"请求主页数据失败：%@",request.requestUrl);
        NSLog(@"请求主页数据失败：%@",request.responseString);
        [[YCTHud sharedInstance] showFailedHud:@"生成失败"];
        [self setMakeProgressViewHide];
    }];
}

- (void)getMusicUrls:(NSString *)taskId completion:(void(^)(id object))completion {
    if (taskId) {
        YCTApiVideoGetMusicsGetAiBGMList *getApi = [[YCTApiVideoGetMusicsGetAiBGMList alloc] initWithPage:1 taskId:taskId];
        @weakify(self);
        [getApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            @strongify(self);
            NSLog(@"请求主页：%@",request.requestUrl);
            NSLog(@"请求参数: %@", request.requestArgument);
//            NSLog(@"请求：%@",request.responseObject);
            NSLog(@"datas:%@",request.responseString);
            NSArray * resultModels = request.responseObject[@"data"];
            BOOL isUse = false;
            for (NSInteger i=0; i<resultModels.count; i++) {
                id model = resultModels[i];
                if ([taskId isEqualToString:model[@"task_id"]]) {
                    isUse = true;
//                    self.textTv.text = request.responseString;
                    self.aiData = resultModels[i];
                    !completion ? : completion(model);
//                    [[YCTHud sharedInstance] showProgress:1.0 text:@"音乐生成成功"];
                    [self setMakeProgressViewProgress:1.0];
                    [self setMakeProgressViewHide];
//                    [[YCTHud sharedInstance] hideHud];
                    return;
                }
            }
            
            NSLog(@"请求数据次数：%ld",self.getCount);
            NSInteger tCount = 360;
            if (self.getCount > tCount) {
                [[YCTHud sharedInstance] showFailedHud:@"生成Ai失败，请重新编辑内容"];
                [self setMakeProgressViewHide];
            } else {
                self.getCount = self.getCount + 1;
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    // 在这里执行延迟代码（主线程）
                    NSLog(@"延迟 1 秒执行的任务");
                    [self getMusicUrls:taskId completion:completion];
                    double progress = ((double)self.getCount)/((double)tCount);
//                    [[YCTHud sharedInstance] showProgress:progress text:@"音乐生成中.."];
                    [self setMakeProgressViewProgress:progress];
                });
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            NSLog(@"请求主页数据失败：%@",request.requestUrl);
            NSLog(@"请求主页数据失败：%@",request.responseString);
            [[YCTHud sharedInstance] showFailedHud:@"生成失败"];
            [self setMakeProgressViewHide];
        }];
    }
}

- (void)yct_okSendText:(NSString *)text {
    [self yct_okSendText:text];
    
    if (self.okBtn.selected) {
        return;
    }
    
    @weakify(self);
    [self requestForMusicWithText:text completion:^(id object) {
        @strongify(self);
        UGCKitBGMHelper * bgmHelper = [UGCKitBGMHelper sharedInstance];
//        [self setValue:bgmHelper forKey:object.url];
//        [bgmHelper setDelegate:self];
        [bgmHelper initAddBGMAddTextAiData:object];
    }];
}
- (void)yct_regenerateUpText:(NSString *)text {
    [self yct_regenerateUpText:text];
    [self requestForMusicWithText:text completion:^(id object) {
        UGCKitBGMHelper * bgmHelper = [UGCKitBGMHelper sharedInstance];
        [bgmHelper initAddBGMAddTextAiData:object];
    }];
}

- (void)yct_onLoadPituHide {
//    [self yct_onLoadPituHide];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[YCTHud sharedInstance] showSuccessHud:@"生成成功"];
    });
}

@end
