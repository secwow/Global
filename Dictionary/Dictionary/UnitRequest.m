//
//  UnitRequest.m
//  Dictionary
//
//  Created by 1 on 12/15/17.
//  Copyright © 2017 1. All rights reserved.
//

#import "UnitRequest.h"
#define REQUEST_STRING @"https://od-api.oxforddictionaries.com:443/api/v1/entries/%@/%@/translations=%@"
#define APP_ID @"9436ccf8"
#define APP_KEY @"c360af3c7857068578608c17e2060ebf"

@interface UnitRequest()

@property (nonatomic, strong) NSString *wordToTranslate;
@property (nonatomic, strong) NSArray<NSString *> *translatedWords;
@property (nonatomic, strong) NSString *fromLanguage;
@property (nonatomic, strong) NSString *toLanguage;
@property (nonatomic, copy) CompletionBlock block;
@property (strong, nonatomic) NSURLSessionDataTask *task;
@property (nonatomic) State state;

@end

@implementation UnitRequest

-(id)initRequestWithWord:(NSString *)wordToTranslate currentLanguage:(NSString *)fromLanguage targetLanguage:(NSString *)toLanguage block:(CompletionBlock)callback
{
    self = [super init];
    
    if(self != nil)
    {
        self.wordToTranslate = wordToTranslate;
        self.fromLanguage = fromLanguage;
        self.toLanguage = toLanguage;
        self.block = callback;
    }
    
    return self;
}

- (void)cancelRequest
{
    [self.task cancel];
    self.state = CANCELED;
}

- (void)makeRequest
{
    NSString *requestString = [NSString stringWithFormat:REQUEST_STRING, self.fromLanguage, self.wordToTranslate, self.toLanguage];
    NSURL *url = [NSURL URLWithString:requestString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:APP_ID forHTTPHeaderField:@"app_id"];
    [request setValue:APP_KEY forHTTPHeaderField:@"app_key"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    __weak UnitRequest *strongSelf = self;
    strongSelf.state = INPROGRESS;
    self.task = [session dataTaskWithRequest:request completionHandler: ^(NSData* data, NSURLResponse *response, NSError *error)
                 {
                     if (error)
                     {
                         strongSelf.state = FAILED;
                         strongSelf.block(strongSelf.translatedWords, @"Unsupported language");
                         return;
                     }
                     
                     NSError *parseError = nil;
                     id object = [NSJSONSerialization
                                  JSONObjectWithData: data
                                  options: 0
                                  error: &parseError];
                     if (parseError)
                     {
                         strongSelf.state = FAILED;
                         strongSelf.block(strongSelf.translatedWords, @"Parse error");
                         return;
                     }
                     
                    
                     NSMutableOrderedSet *words = [NSMutableOrderedSet new];
                     if([object isKindOfClass:[NSDictionary class]])
                     {
                         NSDictionary *results = object;
                         NSDictionary *secondary = results[@"results"][0][@"lexicalEntries"];
                         
                         for(NSDictionary *dictionary in secondary)
                         {
                             for (NSDictionary *entries in dictionary[@"entries"])
                             {
                                 for (NSDictionary *senses in entries[@"senses"])
                                 {
                                     for (NSDictionary *subsenses in senses[@"subsenses"])
                                     {
                                         for (NSDictionary *subsense in subsenses[@"translations"])
                                         {
                                             [words addObject:subsense[@"text"]];
                                         }
                                     }
                                     
                                     for (NSDictionary *translation in senses[@"translations"])
                                     {
                                         [words addObject:translation[@"text"]];
                                     }
                                    
                                 }
                             }

                         }
                     }
                     if (strongSelf.state == CANCELED)
                     {
                         return;    
                     }
                     self.translatedWords = words.array;
                     strongSelf.block(self.translatedWords, nil);
                 }];
    
    [self.task resume];
}

@end
