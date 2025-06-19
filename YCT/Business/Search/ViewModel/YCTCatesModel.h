//
//  YCTCatesModel.h
//  YCT
//
//  Created by 张大爷的 on 2022/10/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTCatesModel : NSObject
@property int level;
@property int cateId;
@property int pid;
@property int ppid;

@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *pname;
@property(nonatomic,strong)NSString *ppname;
-(instancetype)initWithDic:(NSDictionary *)dic level:(int) level pid:(int)pid pname:(NSString *)pname ppid:(int)ppid ppname:(NSString *)ppname;
@end

NS_ASSUME_NONNULL_END
