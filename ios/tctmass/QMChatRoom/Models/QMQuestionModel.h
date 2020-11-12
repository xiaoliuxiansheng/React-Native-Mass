//
//  QMQuestionModel.h
//  IMSDK-OC
//
//  Created by zcz on 2020/1/2.
//  Copyright © 2020 HCF. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMQuestionModel : JSONModel

@property(nonatomic, copy) NSString <Optional>*_id;
@property(nonatomic, copy) NSString <Optional>*accountId;
@property(nonatomic, copy) NSString <Optional>*kmType;
@property(nonatomic, copy) NSString <Optional>*name;
@property(nonatomic, copy) NSString <Optional>*order;
@property(nonatomic, copy) NSString <Optional>*pid;
@property(nonatomic, copy) NSArray <Optional>*childs;
@property(nonatomic, copy) NSString <Optional>*isUpdae;
@property(nonatomic, copy) NSString <Optional>*lastTime;
@property(nonatomic, copy) NSString <Optional>*publisher;
@property(nonatomic, copy) NSString <Optional>*title;
@property(nonatomic, copy) NSString <Optional>*hits;


@end

NS_ASSUME_NONNULL_END
