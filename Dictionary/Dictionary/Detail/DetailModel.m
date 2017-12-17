//
//  DetailModel.m
//  Dictionary
//
//  Created by 1 on 12/16/17.
//  Copyright © 2017 1. All rights reserved.
//

#import "DetailModel.h"

#define REQUEST_STRING @"https://od-api.oxforddictionaries.com:443/api/v1/entries/%@/%@"
#define APP_ID @"9436ccf8"
#define APP_KEY @"c360af3c7857068578608c17e2060ebf"

@interface DetailModel()

@property (nonatomic, strong) NSArray<UnitDictionary *> *details;

@end

@implementation DetailModel

- (void)wordToGetInfo:(NSString *)word fromLanguage:(NSString *)fromLanguage block:(CompletionBlock)complete
{
    NSString *requestString = [NSString stringWithFormat:REQUEST_STRING, fromLanguage, word];
    NSURL *url = [NSURL URLWithString:requestString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:APP_ID forHTTPHeaderField:@"app_id"];
    [request setValue:APP_KEY forHTTPHeaderField:@"app_key"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler: ^(NSData* data, NSURLResponse *response, NSError *error)
                   {
                       if (error)
                       {
                           return;
                       }
                       
                       NSError *parseError = nil;
                       id object = [NSJSONSerialization
                                    JSONObjectWithData: data
                                    options: 0
                                    error: &parseError];
                       if (parseError)
                       {
                           return;
                       }
                       
                       NSMutableArray<UnitDictionary *> *definitions = [[NSMutableArray alloc] init];
                       
                       if([object isKindOfClass:[NSDictionary class]])
                       {
                           NSDictionary *results = object;
                           NSDictionary *secondary = results[@"results"][0][@"lexicalEntries"];
                           
                           for(NSDictionary *dictionary in secondary)
                           {
                               NSString *partOfSpeech;
                               partOfSpeech = dictionary[@"lexicalCategory"];
                               NSMutableArray<NSString *> *tempDefinitions = [NSMutableArray new];
                               
                               for (NSDictionary* defs in dictionary[@"entries"])
                               {
                                   for (NSDictionary* def in defs[@"senses"])
                                   {
                                       for (NSString* definition in def[@"definitions"])
                                       {
                                           [tempDefinitions addObject:definition];
                                       }
                                   }
                               }
                               UnitDictionary *temp = [[UnitDictionary alloc] initWithPartOfSpeech:partOfSpeech definitions:tempDefinitions];
                               [definitions addObject:temp];
                           }
                       }
                       complete(definitions);
                   }];
    
    [task resume];
}
@end
