//
//  GFCardManager.h
//  GFCardText
//
//  Created by 孙行者网络 on 2018/3/15.
//  Copyright © 2018年 孙行者网络. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIImage;
typedef void (^CompleateBlock)(NSString *text);
@interface GFCardManager : NSObject
/**
 *  初始化一个单例
 *
 *  @return 返回一个GFCardManager的实例对象
 */
+ (instancetype)shareCardManager;
/**
 *  根据身份证照片得到身份证号码
 *
 *  @param cardImage 传入的身份证照片
 *  @param compleate 识别完成后的回调
 */
- (void)recognizeCardWithImage:(UIImage *)cardImage compleate:(CompleateBlock)compleate;

@end
