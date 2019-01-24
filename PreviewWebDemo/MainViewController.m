//
//  MainViewController.m
//  PreviewWebDemo
//
//  Created by Michael Tang on 2019/1/4.
//  Copyright © 2019 MichaelTang. All rights reserved.
//

#import "MainViewController.h"
#import "PAPreviewAdViewController.h"
#import "PANetworkManager.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "UIView+Toast.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *isSupportMarid;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)requestJsonAction:(UIButton *)sender {
    
    [SVProgressHUD show];
    
    __weak typeof(self) weakSelf = self;
    
    [[PANetworkManager sharedManager]requestAPIDataSpport:1 success:^(PAIPAModel * _Nonnull apiModel) {
        NSLog(@"--- %@" , apiModel.ads);
        [SVProgressHUD dismiss];
        if (apiModel.ads.count == 0) {
            [weakSelf.view makeToast:@"load fail..."];
            return ;
        }
        PAAdsModel *model = apiModel.ads[0];
        model.support_function = 1;
        [weakSelf loadHtml:model];
        
    } failure:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [weakSelf.view makeToast:@"load fail..."];
        });
       
    }];
    
    
}
- (IBAction)requestSupport2:(UIButton *)sender {
    [SVProgressHUD show];
    
    __weak typeof(self) weakSelf = self;
    
    [[PANetworkManager sharedManager] requestAPIDataSpport:2 success:^(PAIPAModel * _Nonnull apiModel) {
        NSLog(@"--- %@" , apiModel.ads);
        [SVProgressHUD dismiss];
        if (apiModel.ads.count == 0) {
            [weakSelf.view makeToast:@"load fail..."];
            return ;
        }
        PAAdsModel *model = apiModel.ads[0];
        model.support_function = 2;
        [weakSelf loadHtml:model];
        
    } failure:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [weakSelf.view makeToast:@"load fail..."];
        });
        
    }];
}

- (void)loadHtml:(PAAdsModel *)admodel{
    PAPreviewAdViewController *detailVc = [[PAPreviewAdViewController alloc] init];
    detailVc.adModel = admodel;
    detailVc.isSupportMarid = self.isSupportMarid.on;
    if (![admodel.playable_ads_html hasPrefix:@"http://"] && ![admodel.playable_ads_html hasPrefix:@"https://"]) {
        
        [detailVc loadHTMLString:admodel.playable_ads_html isReplace:NO];
    }else{
        
        [detailVc setLoadUrl:admodel.playable_ads_html];
    }
    
    [self presentViewController:detailVc animated:YES completion:nil];
}


@end
