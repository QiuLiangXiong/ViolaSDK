//
//  VADefine.h
//  WhiteWhale
//
//  Created by 邱良雄 on 2018/6/18.
//  Copyright © 2018年 diabao. All rights reserved.
//

#ifndef VADefine_h
#define VADefine_h
#import "VAThreadManager.h"
#import "VALog.h"
#import "VAUtil.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

#define VA_SDK_VERSION @"1.0.0"
#define VA_ROOT_REF @"__root"

#define kBlockWeakSelf __weak typeof(&*self) weakSelf = self
#define kBlockStrongSelf __strong typeof(&*weakSelf) strongSelf = weakSelf

#if DEBUG
#define VAAssert(condition, message) \
do{\
if(!(condition)){\
NSLog(message,nil);\
assert(0);\
}\
}while(0)
#else
#define VAAssert(condition, message)
#endif


#define VAAssertReturn(condition,message)\
VAAssert(condition,message);\
if(!(condition)) return;


#define VAAssertBridgeThread() \
VAAssert([VAThreadManager isBridgeThread], \
@"must be called on the bridge thread")
#define VAAssertComponentThread() \
VAAssert([VAThreadManager isComponentThread], \
@"must be called on the component thread")

#define VAAssertMainThread() \
VAAssert([NSThread isMainThread], \
@"must be called on the bridge thread")

#define VA_ENUMBER_CASE(_invoke, idx, code, obj, _type, op, _flist) \
case code:{\
_type *_tmp = malloc(sizeof(_type));\
memset(_tmp, 0, sizeof(_type));\
*_tmp = [obj op];\
[_invoke setArgument:_tmp atIndex:(idx) + 2];\
*(_flist + idx) = _tmp;\
break;\
}
#define VA_EPCHAR_CASE(_invoke, idx, code, obj, _type, op, _flist) \
case code:{\
_type *_tmp = (_type  *)[obj op];\
[_invoke setArgument:&_tmp atIndex:(idx) + 2];\
*(_flist + idx) = 0;\
break;\
}\

#define VA_ALLOC_FLIST(_ppFree, _count) \
do {\
_ppFree = (void *)malloc(sizeof(void *) * (_count));\
memset(_ppFree, 0, sizeof(void *) * (_count));\
} while(0)

#define VA_FREE_FLIST(_ppFree, _count) \
do {\
for(int i = 0; i < _count; i++){\
if(*(_ppFree + i ) != 0) {\
free(*(_ppFree + i));\
}\
}\
free(_ppFree);\
}while(0)

#define VA_ARGUMENTS_SET(_invocation, _sig, idx, _obj, _ppFree) \
do {\
const char *encode = [_sig getArgumentTypeAtIndex:(idx) + 2];\
switch(encode[0]){\
VA_EPCHAR_CASE(_invocation, idx, _C_CHARPTR, _obj, char *, UTF8String, _ppFree)\
VA_ENUMBER_CASE(_invocation, idx, _C_INT, _obj, int, intValue, _ppFree)\
VA_ENUMBER_CASE(_invocation, idx, _C_SHT, _obj, short, shortValue, _ppFree)\
VA_ENUMBER_CASE(_invocation, idx, _C_LNG, _obj, long, longValue, _ppFree)\
VA_ENUMBER_CASE(_invocation, idx, _C_LNG_LNG, _obj, long long, longLongValue, _ppFree)\
VA_ENUMBER_CASE(_invocation, idx, _C_UCHR, _obj, unsigned char, unsignedCharValue, _ppFree)\
VA_ENUMBER_CASE(_invocation, idx, _C_UINT, _obj, unsigned int, unsignedIntValue, _ppFree)\
VA_ENUMBER_CASE(_invocation, idx, _C_USHT, _obj, unsigned short, unsignedShortValue, _ppFree)\
VA_ENUMBER_CASE(_invocation, idx, _C_ULNG, _obj, unsigned long, unsignedLongValue, _ppFree)\
VA_ENUMBER_CASE(_invocation, idx, _C_ULNG_LNG, _obj,unsigned long long, unsignedLongLongValue, _ppFree)\
VA_ENUMBER_CASE(_invocation, idx, _C_FLT, _obj, float, floatValue, _ppFree)\
VA_ENUMBER_CASE(_invocation, idx, _C_DBL, _obj, double, doubleValue, _ppFree)\
VA_ENUMBER_CASE(_invocation, idx, _C_BOOL, _obj, bool, boolValue, _ppFree)\
default: { [_invocation setArgument:&_obj atIndex:(idx) + 2]; *(_ppFree + idx) = 0; break;}\
}\
}while(0)


#endif /* VADefine_h */
