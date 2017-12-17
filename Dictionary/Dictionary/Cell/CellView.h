//
//  CellView.h
//  Dictionary
//
//  Created by 1 on 12/1/17.
//  Copyright © 2017 1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellView : UITableViewCell

- (void)toggleCellAccessibility:(BOOL)enable;
- (void)configure:(NSString *)withData;

@end
