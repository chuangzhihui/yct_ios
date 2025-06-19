//
//  YCTSharedDataManager.m
//  YCT
//
//  Created by 木木木 on 2022/1/13.
//

#import "YCTSharedDataManager.h"
#import "YCTShareDataObject.h"

@interface YCTSharedDataManager ()
@property (nonatomic, strong) NSMapTable<NSString *, YCTShareDataObject *> *mapTable;
@property (nonatomic, strong) NSLock *lock;
@end

@implementation YCTSharedDataManager

YCT_SINGLETON_IMP

- (instancetype)init {
    self = [super init];
    if (self) {
        self.mapTable = [NSMapTable strongToStrongObjectsMapTable];
        self.lock = [[NSLock alloc] init];
    }
    return self;
}

- (void)addObject:(id<YCTSharedDataProtocol>)obj {
    if (obj.dataType.length == 0) {
        return;
    }
    YCTShareDataObject *shareData = [self shareDataWithType:obj.dataType];
    [shareData addObject:obj];
}

- (void)sendValue:(id)value keyPath:(nonnull NSString *)keyPath type:(nonnull NSString *)type id:(nonnull NSString *)id {
    if (keyPath.length == 0 || type.length == 0 || id.length == 0) {
        return;
    }
    YCTShareDataObject *shareData = [self shareDataWithType:type];
    [shareData sendValue:value keyPath:keyPath type:type id:id];
}

- (YCTShareDataObject *)shareDataWithType:(NSString *)type {
    YCTShareDataObject *shareData;
    [self.lock lock];
    shareData = [self.mapTable objectForKey:type];
    if (!shareData) {
        shareData = [[YCTShareDataObject alloc] init];
        shareData.type = type;
        [self.mapTable setObject:shareData forKey:type];
    }
    [self.lock unlock];
    return shareData;
}

@end
