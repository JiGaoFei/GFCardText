//
//  ViewController.m
//  GFCardText
//
//  Created by 孙行者网络 on 2018/3/15.
//  Copyright © 2018年 孙行者网络. All rights reserved.
//

#import "ViewController.h"
#import "GFCardManager.h"
@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
/**选择器*/
@property (nonatomic,strong)  UIImagePickerController *imgagePickController;
/**照片*/
@property (nonatomic,strong) UIImageView *cardImageView;
/**标题*/
@property (nonatomic,strong) UILabel *titleLabel;
/**相机按钮 */
@property (nonatomic,strong) UIButton *cameraBtn;
/**相册按钮*/
@property (nonatomic,strong) UIButton *photoBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建卡片背景
    self.cardImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 150)];
    self.cardImageView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.cardImageView];
    
    // 创建标题
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake( [UIScreen mainScreen].bounds.size.width / 2 -150, 300, 300, 20)];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.text = @"123";
    [self.view addSubview:self.titleLabel];
    
    // 创建相加按钮
    self.cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cameraBtn setTitle:@"相机" forState:UIControlStateNormal];
    self.cameraBtn.frame = CGRectMake( [UIScreen mainScreen].bounds.size.width / 2 -100, 400, 200, 40);
    [self.cameraBtn addTarget:self action:@selector(cameraBtnAciton:) forControlEvents:UIControlEventTouchUpInside];
    self.cameraBtn.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.cameraBtn];
    
    // 创建相册
    self.photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.photoBtn setTitle:@"相册" forState:UIControlStateNormal];
    self.photoBtn.frame = CGRectMake( [UIScreen mainScreen].bounds.size.width / 2 -100, 500, 200, 40);
    [self.photoBtn addTarget:self action:@selector(photoBtnAciton:) forControlEvents:UIControlEventTouchUpInside];
    self.photoBtn.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.photoBtn];
    
    
    // 创建图片控制器
    self.imgagePickController = [[UIImagePickerController alloc] init];
    self.imgagePickController.delegate = self;
    self.imgagePickController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    self.imgagePickController.allowsEditing = YES;
    // Do any additional setup after loading the view, typically from a nib.
}
// 创建UI
- (void)setUpUI
{
    
}

- (void)cameraBtnAciton:(UIButton *)sender
{
    NSLog(@"相机");
    // 判断是否可以打开照相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imgagePickController.sourceType = UIImagePickerControllerSourceTypeCamera;
        // 设置摄像头(拍照,录制视频)为拍照
        self.imgagePickController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
           [self presentViewController:self.imgagePickController animated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设备不能打开相机" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }

}
- (void)photoBtnAciton:(UIButton *)sender
{
    NSLog(@"相册");
    self.imgagePickController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imgagePickController animated:YES completion:nil];
}


#pragma mark - UIImagePickerControllerDelegate
//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    UIImage *srcImage = nil;
    //判断资源类型
    if ([mediaType isEqualToString:@"public.image"]){
        srcImage = info[UIImagePickerControllerEditedImage];
        self.cardImageView.image = srcImage;
        //识别身份证
        self.titleLabel.text = @"图片插入成功，正在识别中...";
        [[GFCardManager shareCardManager] recognizeCardWithImage:srcImage compleate:^(NSString *text) {
            if (text != nil) {
              
                dispatch_async(dispatch_get_main_queue(), ^{
                    // UI更新代码
              self.titleLabel.text = [NSString stringWithFormat:@"识别结果：%@",text];
                    NSLog(@"识别结果%@",text);
                });
                NSLog(@"结果:%@",text);
            }else {
                self.titleLabel.text = @"请选择照片";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"照片识别失败，请选择清晰、没有复杂背景的身份证照片重试！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                [alert show];
            }
        }];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//进入拍摄页面点击取消按钮
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
