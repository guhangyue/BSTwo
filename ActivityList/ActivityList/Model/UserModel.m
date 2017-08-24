//
//  UserModel.m
//  ActivityList
//
//  Created by admin1 on 2017/8/23.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (id)initWithDictionary: (NSDictionary *)dict
{
    self = [super init];
    if (self){
        _memberId=[Utilities nullAndNilCheck:dict[@"memberId"] replaceBy:@"0"];
        _phone=[Utilities nullAndNilCheck:dict[@"contactTel"] replaceBy:@"未知号码"];
        _nickname=[Utilities nullAndNilCheck:dict[@"memberName"] replaceBy:@"未知"];
        _age=[Utilities nullAndNilCheck:dict[@"age"] replaceBy:@"未知"];
        _dob=[Utilities nullAndNilCheck:dict[@"dob"] replaceBy:@"未知"];
        _idCardNo=[Utilities nullAndNilCheck:dict[@"identificationcard"] replaceBy:@"未知"];
        _credit=[Utilities nullAndNilCheck:dict[@"memberPoint"] replaceBy:@"未知"];
        _userPwd=[Utilities nullAndNilCheck:dict[@"userPwd"] replaceBy:@"未知"];
        _avatarUrl=[Utilities nullAndNilCheck:dict[@"memberUrl"] replaceBy:@"未知"];
        _tokenKey=[Utilities nullAndNilCheck:dict[@"Key"] replaceBy:@"未知"];
        if ([dict[@"memberSex"]isKindOfClass:[NSNull class]])
        {
            _gender=@"";
        }else{
            switch ([dict[@"memberSex"]integerValue])
            {
                case 1:
                    _gender=@"男";
                    break;
                case 2:
                    _gender=@"女";
                    break;
                default:
                    _gender=@"未知";
                    break;
            }
        }
        
        
    }
    return self;
}

@end
