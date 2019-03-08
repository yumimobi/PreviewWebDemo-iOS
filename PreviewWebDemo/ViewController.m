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
@property (weak, nonatomic) IBOutlet UISwitch *isPreRender;
@property (nonatomic) PAPreviewAdViewController *detailVc;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)presentAd:(id)sender {
    self.detailVc.view.hidden = NO;
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
    
    self.detailVc = [[PAPreviewAdViewController alloc] init];
    self.detailVc.isSupportMarid = self.isSupportMarid.on;
    if (self.isPreRender.on) {
        self.detailVc.view.hidden = YES;
        [self.view addSubview:self.detailVc.view];
    } else {
        [self presentViewController:self.detailVc animated:YES completion:nil];
    }
    PAAdsModel *model = [[PAAdsModel alloc] init];
    model.support_function = 3;
    self.detailVc.adModel = model;
    if (![text hasPrefix:@"http://"] && ![text hasPrefix:@"https://"]) {
        self.warningLab.text = @"load html strings";
        [self.detailVc loadHTMLString:text isReplace:YES];
    }else{
        self.warningLab.text = @"load html url";
        [self.detailVc setLoadUrl:text];
    }
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
