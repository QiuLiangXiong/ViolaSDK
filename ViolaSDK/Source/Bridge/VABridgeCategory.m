////
////  VABridgeCategory.m
////  WhiteWhale
////
////  Created by 邱良雄 on 2018/6/17.
////  Copyright © 2018年 diabao. All rights reserved.
////
//
//#import "VABridgeCategory.h"
//#import <objc/runtime.h>
//
//#define VA_JS_VALUE_RET_CASE(typeString, type) \
//case typeString: {                      \
//type value;                         \
//[invocation getReturnValue:&value];  \
//returnValue = [JSValue valueWithObject:@(value) inContext:context]; \
//break; \
//}
//
//#define VA_JS_VALUE_RET_STRUCT(_type, _methodName)                             \
//if ([typeString rangeOfString:@#_type].location != NSNotFound) {   \
//_type value;                                                   \
//[invocation getReturnValue:&value];                            \
//returnValue = [JSValue _methodName:value inContext:context]; \
//break;                                                         \
//}
//
//@implementation JSValue (Viola)
//
//+ (JSValue *)va_valueWithReturnValueFromInvocation:(NSInvocation *)invocation inContext:(JSContext *)context
//{
//    if (!invocation || !context) return nil;
//    const char * returnType = [invocation.methodSignature methodReturnType];
//    
//    JSValue *returnValue;
//    switch (returnType[0] == _C_CONST ? returnType[1] : returnType[0]) {
//        case _C_VOID: {
//            returnValue = [JSValue valueWithUndefinedInContext:context];
//            break;
//        }
//            
//        case _C_ID: {
//            void *value;
//            [invocation getReturnValue:&value];
//            id object = (__bridge id)value;
//            
//            returnValue = [JSValue valueWithObject:[object copy] inContext:context];
//            break;
//        }
//            VA_JS_VALUE_RET_CASE(_C_CHR, char)
//            VA_JS_VALUE_RET_CASE(_C_UCHR, unsigned char)
//            VA_JS_VALUE_RET_CASE(_C_SHT, short)
//            VA_JS_VALUE_RET_CASE(_C_USHT, unsigned short)
//            VA_JS_VALUE_RET_CASE(_C_INT, int)
//            VA_JS_VALUE_RET_CASE(_C_UINT, unsigned int)
//            VA_JS_VALUE_RET_CASE(_C_LNG, long)
//            VA_JS_VALUE_RET_CASE(_C_ULNG, unsigned long)
//            VA_JS_VALUE_RET_CASE(_C_LNG_LNG, long long)
//            VA_JS_VALUE_RET_CASE(_C_ULNG_LNG, unsigned long long)
//            VA_JS_VALUE_RET_CASE(_C_FLT, float)
//            VA_JS_VALUE_RET_CASE(_C_DBL, double)
//            VA_JS_VALUE_RET_CASE(_C_BOOL, BOOL)
//            
//        case _C_STRUCT_B: {
//            NSString *typeString = [NSString stringWithUTF8String:returnType];
//            
//            VA_JS_VALUE_RET_STRUCT(CGRect, valueWithRect)
//            VA_JS_VALUE_RET_STRUCT(CGPoint, valueWithPoint)
//            VA_JS_VALUE_RET_STRUCT(CGSize, valueWithSize)
//            VA_JS_VALUE_RET_STRUCT(NSRange, valueWithRange)
//            
//        }
//        case _C_CHARPTR:
//        case _C_PTR:
//        case _C_CLASS: {
//            returnValue = [JSValue valueWithUndefinedInContext:context];
//            break;
//        }
//    }
//    
//    return returnValue;
//}
//
//@end
//
