//
//  YCTShareDataObject.m
//  YCT
//
//  Created by 木木木 on 2022/1/13.
//

#import "YCTShareDataObject.h"
#import "NSObject+YCTShareData.h"

@interface YCTShareDataObject ()
@property (nonatomic, strong) NSHashTable<id<YCTSharedDataProtocol>> *hashTable;
@property (nonatomic, strong) NSLock *lock;
@end

@implementation YCTShareDataObject

- (instancetype)init {
    self = [super init];
    if (self) {
        self.lock = [[NSLock alloc] init];
        self.hashTable = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
    }
    return self;
}

- (void)addObject:(id<YCTSharedDataProtocol>)obj {
    [self.lock lock];
    [self.hashTable addObject:obj];
    [self.lock unlock];
}

- (void)sendValue:(id)value keyPath:(NSString *)keyPath type:(NSString *)type id:(NSString *)id {
   if (self.type && [self.type isEqualToString:type]) {
       [self.lock lock];
       for (NSObject<YCTSharedDataProtocol> *obj in _hashTable) {
           if ([obj.id isEqualToString:id] && [obj canPerformKeyPath:keyPath]) {
               dispatch_block_t updateValue =^() {
                   [obj setValue:value forKey:keyPath];
               };
               if ([NSThread currentThread].isMainThread) {
                   updateValue();
               }
               else {
                   dispatch_sync(dispatch_get_main_queue(), updateValue);
               }
           }
       }
       [self.lock unlock];
   }
}

@end
