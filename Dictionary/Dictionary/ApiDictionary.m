//
//  ApiDictionary.m
//  Dictionary
//
//  Created by 1 on 11/23/17.
//  Copyright © 2017 1. All rights reserved.
//
#import "ApiDictionary.h"

@implementation ApiDictionary

#import "ApiDictionary.h"
#define APP_ID @"9436ccf8"
#define APP_KEY @"c360af3c7857068578608c17e2060ebf"

NSString *language = @"en";
NSString *target_lang = @"es";
NSString *word = @"Change";

- (void) makeRequest: (NSString *)withWord
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://od-api.oxforddictionaries.com:443/api/v1/entries/%@/%@/translations=%@", language, withWord, target_lang]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:APP_ID forHTTPHeaderField:@"app_id"];
    [request setValue:APP_KEY forHTTPHeaderField:@"app_key"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler: ^(NSData* data, NSURLResponse *response, NSError *error )
    {
        if (error)
        {
            NSLog(@"We got error");
            return;
        }
        
        NSError *parseError = nil;
        id object = [NSJSONSerialization
                     JSONObjectWithData: data
                     options: 0
                     error: &parseError];
        if (parseError)
        {
            NSLog(@"%@", parseError.localizedDescription);
        }
        NSMutableArray *translatedWords = [[NSMutableArray alloc] init];
        if([object isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *results = object;
            NSDictionary *secondary = results[@"results"][0][@"lexicalEntries"][0][@"entries"][0][@"senses"];
           
            for(NSDictionary *dictionary in secondary) {
                
                for (NSString *key in [dictionary allKeys])
                {
                    
                    if ([key isEqualToString:@"translations"])
                    {
                        for (NSDictionary* translate in dictionary[key]) {
                            [translatedWords addObject: translate[@"text"]];
                        }
                    }
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
             [self.delegate updateData: [translatedWords componentsJoinedByString:@"\n"]];
        });
       
    }];
    [task resume];
}

@end
