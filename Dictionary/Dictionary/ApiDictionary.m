//
//  ApiDictionary.m
//  Dictionary
//
//  Created by 1 on 11/23/17.
//  Copyright © 2017 1. All rights reserved.
//
#import "ApiDictionary.h"
#import "UnitRequest.h"

@interface Cache: NSObject

@property (strong, nonatomic) NSString *requestWord;
@property (strong, nonatomic) NSArray<NSString *> *translatedWords;
@property (strong, nonatomic) NSString *reverseTranslate;
-(id)initWithRequestWord:(NSString *)wordToTranslate translatedWords:(NSArray<NSString *>*)words reverseTranslate:(NSString*)reverse;

@end

@implementation Cache

-(id)initWithRequestWord:(NSString *)wordToTranslate translatedWords:(NSArray<NSString *> *)words reverseTranslate:(NSString *)reverse
{
    self = [super init];
    if(self != nil)
    {
        self.requestWord = wordToTranslate;
        self.translatedWords = words;
        self.reverseTranslate = reverse;
    }
    return self;
}

@end

@interface ApiDictionary()

@property (strong, nonatomic) NSArray<NSString *> *translatedWords;
@property (strong, nonatomic) NSString *errorMessage;
@property (strong, nonatomic) NSString *reverseTranslate;
@property (strong, nonatomic) NSString *requestText;
@property (nonatomic) NSInteger requestCount;
@property (nonatomic) State state;
@property (nonatomic) UnitRequest *currentRequest;
@property (nonatomic) NSMutableArray<Cache *> *cache;

@end

@implementation ApiDictionary

#define LANGUAGE @"en"
#define TARGET_LANGUAGE @"es"

-(instancetype)init
{
    self = [super init];
    if(self != nil)
    {
        self.cache = [NSMutableArray new];
    }
    return self;
}

- (void) translateWord:(NSString *)withWord
{
    // Check for equal words in request
    if (self.requestText == withWord && self.state != FAILED && self.state != CANCELED)
    {
        return;
    }
    
    [self cancelRequest];
    self.state = NEW;
    self.requestText = withWord;
    void (^interationBlock)(void) = ^void(void){self.requestCount++;};
    // Restore state if we already have one before
    Cache *cache = [self restoreSavedStateWithWord:withWord];
    if (cache != nil)
    {
        [self restoreStateFrom:cache];
        return;
    }
    
    __weak ApiDictionary *strongSelf = self;
    CompletionBlock reverseBlock = ^(NSArray<NSString *> *translatedWords, NSString *error){

        if (self.state == CANCELED)
        {
            return;
        }
        
        if(![self validateResponse:translatedWords errorString:error])
        {
            return;
        }
        
        strongSelf.reverseTranslate = translatedWords.firstObject;
        [strongSelf.cache addObject:[[Cache alloc]initWithRequestWord:strongSelf.requestText translatedWords:strongSelf.translatedWords reverseTranslate:strongSelf.reverseTranslate]];
        strongSelf.state = DONE;
    };
    
    CompletionBlock block = ^(NSArray<NSString *> *translatedWords, NSString *error){        
        if (self.state == CANCELED)
        {
            return;
        }
        
        if(![self validateResponse:translatedWords errorString:error])
        {
            return;
        }
        
        NSString *wordToReverse = translatedWords.firstObject;
        strongSelf.translatedWords = translatedWords;
       
        UnitRequest *reverseRequest = [[UnitRequest alloc] initRequestWithWord:wordToReverse currentLanguage:TARGET_LANGUAGE targetLanguage:LANGUAGE block:reverseBlock counterBlock:interationBlock];
        strongSelf.currentRequest = reverseRequest;
        [reverseRequest makeRequest];
    };
    
    UnitRequest *simpleRequest = [[UnitRequest alloc] initRequestWithWord:withWord currentLanguage:LANGUAGE targetLanguage:TARGET_LANGUAGE block:block counterBlock:interationBlock];
    self.state = INPROGRESS;
    self.currentRequest = simpleRequest;
    [simpleRequest makeRequest];
   
}

- (void)cancelRequest
{
    [self.currentRequest cancelRequest];
    self.state = CANCELED;
    self.errorMessage = @"";
}

- (Cache *)restoreSavedStateWithWord:(NSString *)word
{
    for (Cache *previousRequest in self.cache)
    {
        if ([previousRequest.requestWord isEqualToString:word])
        {
            return previousRequest;
        }
    }
    return nil;
}

- (void)restoreStateFrom:(Cache *)cache
{
    self.requestText = cache.requestWord;
    self.reverseTranslate = cache.reverseTranslate;
    self.translatedWords = cache.translatedWords;
    self.state = DONE;
}

- (BOOL)validateResponse:(NSArray<NSString *> *)translatedWords errorString:(NSString *)error
{
    if(error != nil)
    {
        self.errorMessage = error;
        self.currentRequest = nil;
        self.state = FAILED;
        return false;
    }
    
    if(translatedWords.count == 0)
    {
        return false;
    }
    
    return true;
}

@end
