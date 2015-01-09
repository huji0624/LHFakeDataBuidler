//
//  LHFakeDataBuilder.m
//  Ji
//
//  Created by user on 15-1-7.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "LHFakeDataBuilder.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation LHFakeDataBuilderTestClass
-(NSString *)description{
    return self.string;
}
@end

@implementation LHFakeDataBuilder{
    Class _buildClass;
    NSInteger _maxNSStringLength;
    NSUInteger _manyMax;
    NSMutableDictionary *_randomRules;
}

+(instancetype)defaultBuilder{
    LHFakeDataBuilder *buidler_ = [[LHFakeDataBuilder alloc] init];
    [buidler_ setNSStringMaxLength:100];
    [buidler_ setManyMaxCount:500];
    return buidler_;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.defaultStringDictionary = @[@"L",@"H",@"霁",@"码",@"农",@",",@".",@"?"];
        _randomRules = [NSMutableDictionary dictionary];
    }
    return self;
}

-(instancetype)setNSStringMaxLength:(NSInteger)maxStringLength{
    _maxNSStringLength = maxStringLength;
    return self;
}

-(instancetype)setManyMaxCount:(NSUInteger)manyMax{
    _manyMax = manyMax;
    return self;
}

-(instancetype)setBuildClass:(Class)oneClass{
    _buildClass = oneClass;
    return self;
}

-(instancetype)addRandomRule:(RandomRuleBlock)rule forClass:(Class)oneClass{
    [_randomRules setObject:rule forKey:NSStringFromClass(oneClass)];
    return self;
}

-(NSNumber*)randomInt{
    int ri = (int)arc4random();
    return [NSNumber numberWithInt:ri];
}

-(NSNumber*)randomUInt{
    unsigned int uri = (unsigned int)arc4random();
    return [NSNumber numberWithUnsignedInt:uri];
}

-(NSNumber*)randomBool{
    BOOL rb = arc4random()%2==0;
    return [NSNumber numberWithBool:rb];
}

-(NSNumber*)randomFloat{
    float rf = arc4random()*0.3f;
    return [NSNumber numberWithFloat:rf];
}

-(NSNumber*)randomShort{
    return [self randomInt];
}

-(NSNumber*)randomUShort{
    return [self randomUInt];
}

-(NSNumber*)randomLong{
    return [self randomInt];
}

-(NSNumber*)randomULong{
    return [self randomUInt];
}

-(NSNumber*)randomDouble{
    return [self randomFloat];
}

-(NSNumber*)randomChar{
    return [self randomInt];
}

-(NSNumber*)randomUChar{
    return [self randomUInt];
}

-(NSNumber*)randomLongLong{
    return [self randomInt];
}

-(NSNumber*)randomULongLong{
    return [self randomUInt];
}

-(NSString*)randomString{
    NSInteger length = arc4random()%_maxNSStringLength;
    NSMutableString *mstr = [NSMutableString stringWithCapacity:length];
    NSUInteger count = self.defaultStringDictionary.count;
    for (NSInteger i=0; i<length; i++) {
        NSUInteger index = arc4random()%count;
        [mstr appendString:[self.defaultStringDictionary objectAtIndex:index]];
    }
    return [NSString stringWithString:mstr];
}

-(BOOL)isIgnoreClass{
    NSArray *igc = @[[NSArray class],[NSDictionary class],[NSMutableArray class],[NSMutableDictionary class]];
    for (Class tmp in igc) {
        if (tmp == _buildClass) {
            return YES;
        }
    }
    return NO;
}

-(id)ruleClass{
    RandomRuleBlock rule = [_randomRules objectForKey:NSStringFromClass(_buildClass)];
    if (rule) {
        return rule();
    }
    return nil;
}

-(id)build{
    if (!_buildClass) {
        NSLog(@"Build Class not found.");
        return nil;
    }
    
    if (_buildClass == [NSString class]) {
        return [self randomString];
    }
    id ruleobj = [self ruleClass];
    if (ruleobj) {
        return ruleobj;
    }else if ([self isIgnoreClass]){
        return nil;
    }
    
    NSObject *obj = [[_buildClass alloc] init];
    
    //fake object
    unsigned int count;
    objc_property_t* props = class_copyPropertyList(_buildClass, &count);
    for (int i =0 ; i<count; i++) {
        objc_property_t property = props[i];
        const char * name = property_getName(property);
        const char * type = property_getAttributes(property);
        NSString *propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        NSString * typeString = [NSString stringWithUTF8String:type];
        NSArray * attributes = [typeString componentsSeparatedByString:@","];
        NSString * typeAttribute = [attributes objectAtIndex:0];
        NSString * propertyType = [typeAttribute substringFromIndex:1];
        const char * rawPropertyType = [propertyType UTF8String];
        
        if (strcmp(rawPropertyType, @encode(int)) == 0) {
            //int value
            [obj setValue:[self randomInt] forKey:propertyName];
        } else if (strcmp(rawPropertyType, @encode(unsigned int)) == 0) {
            //unsigned int value
            NSNumber * num = [self randomUInt];
            [obj setValue:num forKey:propertyName];
        }else if (strcmp(rawPropertyType, @encode(BOOL)) == 0) {
            //bool value
            NSNumber * num = [self randomBool];
            [obj setValue:num forKey:propertyName];
        } else if (strcmp(rawPropertyType, @encode(float)) == 0) {
            //float value
            NSNumber * num = [self randomFloat];
            [obj setValue:num forKey:propertyName];
        } else if(strcmp(rawPropertyType, @encode(short)) == 0){
            //short value
            [obj setValue:[self randomShort] forKey:propertyName];
        }else if(strcmp(rawPropertyType, @encode(unsigned short)) == 0){
            //unsigned short value
            [obj setValue:[self randomUShort] forKey:propertyName];
        }else if(strcmp(rawPropertyType, @encode(long)) == 0){
            //long value
            [obj setValue:[self randomLong] forKey:propertyName];
        }else if(strcmp(rawPropertyType, @encode(unsigned long)) == 0){
            //unsigned long value
           [obj setValue:[self randomShort] forKey:propertyName];
        }else if(strcmp(rawPropertyType, @encode(double)) == 0){
            //double value
            [obj setValue:[self randomDouble] forKey:propertyName];
        }else if(strcmp(rawPropertyType, @encode(char)) == 0){
            //char value
            [obj setValue:[self randomChar] forKey:propertyName];
        }else if(strcmp(rawPropertyType, @encode(unsigned char)) == 0){
            //unsigned char value
            [obj setValue:[self randomUChar] forKey:propertyName];
        }else if(strcmp(rawPropertyType, @encode(long long)) == 0){
            //long long value
            [obj setValue:[self randomLongLong] forKey:propertyName];
        }else if(strcmp(rawPropertyType, @encode(unsigned long long)) == 0){
            //unsigned long long value
            [obj setValue:[self randomULongLong] forKey:propertyName];
        }else{
            if ([typeAttribute hasPrefix:@"T@"] && [typeAttribute length] > 1) {
                NSString * typeClassName = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length]-4)];
                Class typeClass = NSClassFromString(typeClassName);
                [obj setValue:[[[[LHFakeDataBuilder defaultBuilder] setBuildClass:typeClass] setNSStringMaxLength:_maxNSStringLength] build] forKey:propertyName];
            }
        }
        
//        NSLog(@"pro [%s] [%s]",name,type);
    }
    free(props);
    
    return obj;
}

-(NSArray *)buildMany:(NSInteger)count{
    if (count<=0) {
        count = arc4random()%_manyMax;
    }
    NSMutableArray *many = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0 ; i<count; i++) {
        [many addObject:[self build]];
    }
    return [NSArray arrayWithArray:many];
}
@end
