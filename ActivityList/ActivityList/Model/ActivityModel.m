//
//  ActivityModel.m
//  ActivityList
//
//  Created by admin on 2017/7/26.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "ActivityModel.h"

@implementation ActivityModel

- (id)initWithDictionary: (NSDictionary *)dict{
    
    self = [super init];
    
  /*  if ([dict[@"imgURL"] isKindOfClass:[NSNull class]]){
        _imgUrl = @"http://7u2h3s.com2.z0.glb.qiniucdn.com/activityImg_2_0B28535F-B789-4E8B-9B5D-28DEDB728E9A";
    }else{
        _imgUrl = dict[@"imgURL"];
    }*/
    //以上代码等同于以下代码
    if (self){
        _activityId=[Utilities nullAndNilCheck:dict[@"id"] replaceBy:@"0"];
    self.imgUrl = [dict[@"imgUrl"] isKindOfClass:[NSNull class]] ? @"" : dict[@"imgUrl"];
    
    self.name = [dict[@"name"] isKindOfClass:[NSNull class]] ? @"活动" : dict[@"name"];
    
    self.content = [dict[@"content"] isKindOfClass:[NSNull class]] ? @"暂无内容" :dict[@"content"];
    
    self.reliableNumber = [dict[@"reliableNumber"] isKindOfClass:[NSNull class]] ? 0 :[dict[@"reliableNumber"] integerValue];
    
    self.unReliableNumber = [dict[@"unReliableNumber"] isKindOfClass:[NSNull class]] ? 0 :[dict[@"unReliableNumber"] integerValue];
    
    self.isFavo = [dict[@"isFavo"] isKindOfClass:[NSNull class]] ? NO: [dict[@"isFavo"] boolValue];
        
    }
    
    return self;
    
}
- (id)initWithDetialDictionary: (NSDictionary *)dict{
    self = [super init];
    
    
    if (self){
        _activityId=[Utilities nullAndNilCheck:dict[@"id"] replaceBy:@"0"];
        self.imgUrl = [dict[@"imgUrl"] isKindOfClass:[NSNull class]] ? @"" : dict[@"imgUrl"];
        
        self.name = [dict[@"name"] isKindOfClass:[NSNull class]] ? @"活动" : dict[@"name"];
        
        self.content = [dict[@"content"] isKindOfClass:[NSNull class]] ? @"暂无内容" :dict[@"content"];
        
        self.reliableNumber = [dict[@"reliableNumber"] isKindOfClass:[NSNull class]] ? 0 :[dict[@"reliableNumber"] integerValue];
        
        self.unReliableNumber = [dict[@"unReliableNumber"] isKindOfClass:[NSNull class]] ? 0 :[dict[@"unReliableNumber"] integerValue];
        _address=[Utilities nullAndNilCheck:dict[@"address"] replaceBy:@"活动地址待定"];
        _applyFee=[Utilities nullAndNilCheck:dict[@"applicationFee"] replaceBy:@""];
        _attendence=[Utilities nullAndNilCheck:dict[@"participantsNumber"] replaceBy:@"0"];
        _type=[Utilities nullAndNilCheck:dict[@"categoryName"] replaceBy:@"普通活动"];
        _issuer=[Utilities nullAndNilCheck:dict[@"issuerName"] replaceBy:@"未知发布者"];
        _phone=[Utilities nullAndNilCheck:dict[@"issuerPhone"] replaceBy:@""];
        _limitation=[Utilities nullAndNilCheck:dict[@"attendenceAmount"] replaceBy:@"0"];
        
        _dueTime = [dict[@"applicationExpirationDate"]isKindOfClass:[NSNull class]] ? (NSTimeInterval)0:(NSTimeInterval)[dict[@"applicationExpirationDate"]integerValue];
        _startTime=[dict[@"startDate"] isKindOfClass:[NSNull class]] ? (NSTimeInterval)0 : (NSTimeInterval)[dict[@"startDate"] integerValue];
        _endTime=[dict[@"endDate"] isKindOfClass:[NSNull class]] ? (NSTimeInterval)0 : (NSTimeInterval)[dict[@"endDate"] integerValue];
        _status=[dict[@"applyStatus"] isKindOfClass:[NSNull class]] ? -1 : [dict[@"applyStatus"] integerValue];
        
    }
    return self;
}

@end
