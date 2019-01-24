//
//  PAPreviewAdViewController.h
//  PlayableAdsPreviewer
//
//  Created by Michael Tang on 2018/8/31.
//

#import <UIKit/UIKit.h>
#import "PAIPAModel.h"

@interface PAPreviewAdViewController : UIViewController

@property (nonatomic) PAAdsModel  * adModel;
@property (nonatomic) BOOL isSupportMarid;

- (void)setLoadUrl:(NSString *)urlString;

- (void)loadHTMLString:(NSString *)htmlStr isReplace:(BOOL)isReplace;

@end
