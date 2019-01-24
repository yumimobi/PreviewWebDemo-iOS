//
//  ViewController.m
//  PreviewWebDemo
//
//  Created by Michael Tang on 2018/9/19.
//  Copyright © 2018年 MichaelTang. All rights reserved.
//

#import "ViewController.h"
#import "PAPreviewAdViewController.h"
#import "PAIPAModel.h"

@interface ViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *warningLab;

@property (weak, nonatomic) IBOutlet UITextView *htmlTextView;

@property (weak, nonatomic) IBOutlet UISwitch *isSupportMarid;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}
- (IBAction)loadHtmlAction:(UIButton *)sender {
    [self loadHtml];
}

- (void)loadHtml{
    [self.htmlTextView resignFirstResponder];
    
    NSString *text =  [NSString stringWithFormat:@"%@",self.htmlTextView.text];
    self.warningLab.text = nil;
    if (text.length == 0) {
        self.warningLab.text = @"html url is nil";
        return;
    }
    
    PAPreviewAdViewController *detailVc = [[PAPreviewAdViewController alloc] init];
    detailVc.isSupportMarid = self.isSupportMarid.on;
    PAAdsModel *model = [[PAAdsModel alloc] init];
    model.support_function = 3;
    
    detailVc.adModel = model;
    
    if (![text hasPrefix:@"http://"] && ![text hasPrefix:@"https://"]) {
        self.warningLab.text = @"load html strings";
        [detailVc loadHTMLString:text isReplace:YES];
    }else{
        self.warningLab.text = @"load html url";
        [detailVc setLoadUrl:text];
    }
    
    [self presentViewController:detailVc animated:YES completion:nil];
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.warningLab.text = nil;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text{
    
    if ([text isEqualToString:@"\n"]) {
         [self loadHtml];
        return NO;
        
    }
    return YES;
    
}


@end
