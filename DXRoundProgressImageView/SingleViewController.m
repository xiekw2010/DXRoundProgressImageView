//
//  SingleViewController.m
//  DXRoundProgressImageView
//
//  Created by xiekw on 10/10/14.
//  Copyright (c) 2014 xiekw. All rights reserved.
//

#import "SingleViewController.h"
#import "RoundProgressImageView.h"
#import "SDWebImageManager.h"

@interface SingleViewController ()

@property (nonatomic, strong) RoundProgressImageView *roundIgv;
@property (nonatomic, strong) NSMutableArray *images;

@end

@implementation SingleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGFloat const igvWidth = 300.0;
    CGFloat wholeWidth = CGRectGetWidth(self.view.bounds);
    self.roundIgv = [[RoundProgressImageView alloc] initWithFrame:CGRectMake((wholeWidth-igvWidth)*0.5, 40, igvWidth, igvWidth)];
    [self.view addSubview:self.roundIgv];
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitle:@"Next" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    nextBtn.frame = CGRectMake((wholeWidth - 150)*0.5, CGRectGetMaxY(self.roundIgv.frame) + 40, 150, 40);
    nextBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:nextBtn];
    
    [nextBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    
    self.images = [NSMutableArray
                   arrayWithArray:@[@"http://photos-h.ak.instagram.com/hphotos-ak-xaf1/10632252_1469925499939367_1009109969_a.jpg",
                                    @"http://photos-h.ak.instagram.com/hphotos-ak-xfa1/10598177_332074173634007_88941195_a.jpg",
                                    @"http://photos-b.ak.instagram.com/hphotos-ak-xaf1/10632088_1539105099657089_837441821_a.jpg",
                                    @"http://photos-a.ak.instagram.com/hphotos-ak-xaf1/10632049_698849780206856_238334272_a.jpg",
                                    @"http://photos-a.ak.instagram.com/hphotos-ak-xaf1/10632034_687299801352960_2077902099_a.jpg",
                                    @"http://photos-a.ak.instagram.com/hphotos-ak-xpa1/10488697_1476086639301168_379481690_a.jpg",
                                    @"http://photos-f.ak.instagram.com/hphotos-ak-xap1/10561209_1506851009531533_1816453144_a.jpg",
                                    @"http://photos-d.ak.instagram.com/hphotos-ak-xfa1/914774_631634073620451_39874156_a.jpg",
                                    @"http://photos-d.ak.instagram.com/hphotos-ak-xpf1/10549679_960863910594355_1666715800_a.jpg",
                                    @"http://photos-a.ak.instagram.com/hphotos-ak-xfp1/10547074_1441196752823384_834155289_a.jpg",
                                    @"http://photos-b.ak.instagram.com/hphotos-ak-xap1/10413909_654745821281521_1683595252_a.jpg",
                                    @"http://photos-c.ak.instagram.com/hphotos-ak-xpa1/10513817_904913789535826_862592562_a.jpg",
                                    @"http://photos-f.ak.instagram.com/hphotos-ak-xpa1/10522795_1434103363531277_502543925_a.jpg",
                                    @"http://photos-e.ak.instagram.com/hphotos-ak-xap1/10520199_1505279529704532_1210112757_a.jpg"
                                                   ]];
    
    NSString *lastImage = [self.images lastObject];
    [self.roundIgv prSetImageWithURL:[NSURL URLWithString:lastImage] placeholderImage:nil];
    
    for (NSString *imageString in self.images) {
        [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:imageString] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        }];
    }
}

- (void)next
{
    [self.images removeLastObject];
    NSString *lastImage = [self.images lastObject];
    [self.roundIgv prSetImageWithURL:[NSURL URLWithString:lastImage] placeholderImage:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
