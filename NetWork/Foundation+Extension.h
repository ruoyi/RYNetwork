//
//  Foundation+Extension.h
//  dailycare
//
//  Created by 若懿 on 15/12/16.
//  Copyright © 2015年 ruoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

static inline NSString *StringValue(id obj) {
	if([obj isKindOfClass:[NSString class]]) {
		return (NSString *)obj;
	} else if ([obj isKindOfClass:[NSNull class]]|| obj == nil) {
		return  @"";
	} else if ([obj isKindOfClass:[NSNumber class]]) {
		return  [(NSNumber *)obj stringValue];
	}

	return @"";
}


static inline NSNumber *NumberValue(id obj) {
    if([obj isKindOfClass:[NSNumber class]]) {
        NSNumber *num = nil;
        
        if (strcmp([obj objCType], @encode(char)) == 0) {
            num = [NSNumber numberWithChar:[obj charValue]];
        }
        else if (strcmp([obj objCType], @encode(unsigned char)) == 0) {
            num = [NSNumber numberWithUnsignedChar:[obj unsignedCharValue]];
        }
        else if (strcmp([obj objCType], @encode(short)) == 0) {
            num = [NSNumber numberWithShort:[obj shortValue]];
        }
        else if (strcmp([obj objCType], @encode(unsigned short)) == 0) {
            num = [NSNumber numberWithUnsignedShort:[obj unsignedShortValue]];
        }
        else if (strcmp([obj objCType], @encode(int)) == 0) {
            num = [NSNumber numberWithInt:[obj intValue]];
        }
        else if (strcmp([obj objCType], @encode(unsigned int)) == 0) {
            num = [NSNumber numberWithUnsignedInt:[obj unsignedIntValue]];
        }
        else if (strcmp([obj objCType], @encode(long)) == 0) {
            num = [NSNumber numberWithLong:[obj longValue]];
        }
        else if (strcmp([obj objCType], @encode(unsigned long)) == 0) {
            num = [NSNumber numberWithUnsignedLong:[obj unsignedLongValue]];
        }
        else if (strcmp([obj objCType], @encode(long long)) == 0) {
            num = [NSNumber numberWithLongLong:[obj longLongValue]];
        }
        else if (strcmp([obj objCType], @encode(unsigned long long)) == 0) {
            num = [NSNumber numberWithUnsignedLongLong:[obj unsignedLongLongValue]];
        }
        else if (strcmp([obj objCType], @encode(float)) == 0) {
            num = [NSNumber numberWithFloat:[obj floatValue]];
        }
        else if (strcmp([obj objCType], @encode(double)) == 0) {
            num = [NSNumber numberWithDouble:[obj doubleValue]];
        }
        else if (strcmp([obj objCType], @encode(BOOL)) == 0) {
            num = [NSNumber numberWithBool:[obj boolValue]];
        }
        else {
            //To-Do  unkown num type ,num is nil
        }
        
        return num;
    }else if ([obj isKindOfClass:[NSNull class]]|| obj == nil) {
        return  @0;
    }else if ([obj isKindOfClass:[NSString class]]) {
        float fv  = [(NSString *)obj floatValue];
        if (fv < 0) {
            return [NSNumber numberWithFloat:fv];
        }
        return @([(NSString *)obj doubleValue]);
    }
    
    return @0;
}

static inline NSArray* ArrayValue(id obj) {
	if ([obj isKindOfClass:[NSNull class]]|| obj == nil) {
		return  @[];
	}
	else if([obj isKindOfClass:[NSArray class]])
	{
		return (NSArray *)obj;
	}

	return @[];
}

static inline NSDictionary* DictionaryValue(id obj) {
	if ([obj isKindOfClass:[NSNull class]] || obj == nil) {
		return  @{};
	}else if ([obj isKindOfClass:[NSDictionary class]]) {
		return (NSDictionary *)obj;
	}

	return @{};
}


@interface NSString (RYExtension)

- (NSString *)ry_stringByURLEncoding;

- (BOOL)ry_validatePhoneNumber;

- (BOOL)ry_validatePhonePassword;

@end


@interface NSArray (RYExtension)

+ (NSArray *)ry_searchInforcation;

- (NSArray *)ry_safeSubarrayWithRange:(NSRange)range;

+ (NSArray *)ry_safeArrayWithObject:(id)object;

- (id)ry_find:(BOOL(^)(id obj))block;

@end


@interface NSDictionary (RYExtension)

- (NSDictionary *)ry_changeKeyFrom:(id)fromkey toKey:(id)tokey;

- (NSDictionary *)ry_matchKeys:(NSArray *)matchKeys tokey:(id)tokey;

- (NSDictionary *)ry_matchKeyInfo:(NSDictionary *)keyInfo;

@end


@interface NSMutableDictionary (RYExtension)

- (void)ry_safeSetObject:(id)anObject forKey:(id <NSCopying>)aKey;

@end


@interface NSDate (RYExtension)

- (NSDate *)ry_dateByAddingDays: (NSInteger) dDays;

@end





