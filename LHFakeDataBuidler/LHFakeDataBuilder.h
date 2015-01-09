//
//  LHFakeDataBuilder.h
//  Ji
//
//  Created by user on 15-1-7.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    LHFakeDataBuilderTestEnum1
}LHFakeDataBuilderTestEnum;
@interface LHFakeDataBuilderTestClass : NSObject
@property (nonatomic,assign) int intValue;
@property (nonatomic,assign) float floatValue;
@property (nonatomic,retain) NSString *string;
@property (nonatomic,assign) BOOL boolValue;
@property (nonatomic,assign) NSInteger nsintegerValue;
@property (nonatomic,assign) LHFakeDataBuilderTestEnum testEnum;
@property (nonatomic,retain) NSArray *array;
@property (nonatomic,retain) NSDictionary *dictionary;
@end

typedef id(^RandomRuleBlock)();

@interface LHFakeDataBuilder : NSObject

@property (nonatomic,retain) NSArray *defaultStringDictionary;

+(instancetype)defaultBuilder;

-(instancetype)setBuildClass:(Class)oneClass;
-(instancetype)setNSStringMaxLength:(NSInteger)maxStringLength;
-(instancetype)setManyMaxCount:(NSUInteger)manyMax;
-(instancetype)addRandomRule:(RandomRuleBlock)rule forClass:(Class)oneClass;

-(id)build;

/*
 If count <=0.then the returned array will be filled with random count object.
 The max count is configurable.
 */
-(NSArray*)buildMany:(NSInteger)count;
@end
