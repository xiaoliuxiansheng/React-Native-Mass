//
//  QMCardInfoModel.h
//  IMSDK-OC
//
//  Created by zcz on 2019/12/24.
//  Copyright © 2019 HCF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AttrModel : JSONModel
@property(nonatomic, copy) NSString <Optional>*color;
@property(nonatomic, copy) NSString <Optional>*content;

@end

@interface QMCardParams : JSONModel
@property(nonatomic, copy) NSString <Optional>*orderNo;

@end

@interface QMCardInfoModel : JSONModel
@property(nonatomic, copy) NSString <Optional>*img;
@property(nonatomic, copy) NSString <Optional>*item_type;
@property(nonatomic, copy) NSString <Optional>*status;
@property(nonatomic, copy) NSString <Optional>*target;
@property(nonatomic, copy) NSString <Optional>*title;

@property(nonatomic, strong) AttrModel <Optional>*attr_one;
@property(nonatomic, strong) AttrModel <Optional>*attr_two;

@property(nonatomic, copy) NSString <Optional>*other_title_one;
@property(nonatomic, copy) NSString <Optional>*other_title_two;
@property(nonatomic, copy) NSString <Optional>*other_title_three;

@property(nonatomic, copy) NSString <Optional>*price;
@property(nonatomic, copy) NSString <Optional>*sub_title;

@property(nonatomic, strong) QMCardParams <Optional>*params;

@end



NS_ASSUME_NONNULL_END
