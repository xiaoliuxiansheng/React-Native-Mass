//
//  QMLogistcsInfoModel.h
//  IMSDK-OC
//
//  Created by zcz on 2019/12/25.
//  Copyright © 2019 HCF. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMLogistcsInfoModel : JSONModel
@property(nonatomic, copy) NSString <Optional>*list_title;
@property(nonatomic, copy) NSString <Optional>*empty_message;
@property(nonatomic, copy) NSString <Optional>*message;
@property(nonatomic, copy) NSString <Optional>*list_num;
@property(nonatomic, strong) NSArray <Optional>*list;

@end


@interface QMLogistcsInfo : JSONModel
@property(nonatomic, copy) NSString <Optional>*title;
@property(nonatomic, copy) NSString <Optional>*is_current;
@property(nonatomic, copy) NSString <Optional>*desc;

@end

NS_ASSUME_NONNULL_END
