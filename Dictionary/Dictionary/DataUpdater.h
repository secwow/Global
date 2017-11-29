#import <Foundation/Foundation.h>
@protocol DataUpdater

-(void)updateTranslatedWords: (NSArray<NSString *>*) words;
-(void)didGetError: (NSString *)errorText;

@end
