//
//  FeedViewController.m
//  DXRoundProgressImageView
//
//  Created by xiekw on 10/10/14.
//  Copyright (c) 2014 xiekw. All rights reserved.
//

#import "FeedViewController.h"
#import "RoundProgressImageView.h"

@interface RoundImageCell : UITableViewCell

@property (nonatomic, strong) RoundProgressImageView *rImageView;

@end

@implementation RoundImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.rImageView = [[RoundProgressImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
        [self addSubview:self.rImageView];
        self.rImageView.restartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rImageView.restartBtn.frame = CGRectMake(0, 0, 47.0, 50.0);
        [self.rImageView.restartBtn setImage:[UIImage imageNamed:@"btn_content_refresh_nomal.png"] forState:UIControlStateNormal];;
        [self.rImageView.restartBtn setImage:[UIImage imageNamed:@"btn_content_refresh_selected.png"] forState:UIControlStateHighlighted];;

    }
    return self;
}

- (void)prepareForReuse
{
    [self.rImageView cancelImageLoadingOperation];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.rImageView.frame = self.bounds;
}

@end

@interface FeedViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *images;

@end

@implementation FeedViewController

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
    
    self.view.backgroundColor = [UIColor redColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = CGRectGetWidth(self.view.bounds);
    [self.view addSubview:self.tableView];
    
    self.images = @[@"http://photos-h.ak.instagram.com/hphotos-ak-xaf1/10723681_396096430537807_1223749955_a.jpg",
                    @"http://photos-b.ak.instagram.com/hphotos-ak-xfa1/10724921_1533807823502393_1514706648_a.jpg",
                    @"http://photos-e.ak.instagram.com/hphotos-ak-xaf1/10665433_876700919008364_1889919294_a.jpg",
                    @"http://photos-a.ak.instagram.com/hphotos-ak-xaf1/10706808_1565551290331160_1737365041_a.jpg",
                    @"http://photos-a.ak.instagram.com/hphotos-ak-xfa1/10724996_1526187324293624_1466811973_a.jpg",
                    @"http://scontent-a-ord.cdninstagram.com/hphotos-xfa1/t51.2885-15/10724126_717381661662702_1820071134_a.jpg",
                    @"https://igcdn-photos-d-a.akamaihd.net/hphotos-ak-xpa1/1389691_1485677835042251_1271378975_a.jpg",
                    @"http://photos-c.ak.instagram.com/hphotos-ak-xfp1/10245991_839370632746466_1038112850_a.jpg",
                    @"http://photos-d.ak.instagram.com/hphotos-ak-xfa1/10724171_137585983102571_777167344_a.jpg",
                    @"http://photos-d.ak.instagram.com/hphotos-ak-xaf1/10727764_294726154068907_1007589035_a.jpg",
                    @"https://igcdn-photos-a-a.akamaihd.net/hphotos-ak-xaf1/10723999_847836168591024_1150615522_a.jpg",
                    @"http://photos-g.ak.instagram.com/hphotos-ak-xaf1/10727224_630796553700246_656431291_a.jpg",
                    @"http://photos-c.ak.instagram.com/hphotos-ak-xaf1/10684239_1509165802659378_1563094791_a.jpg",
                    @"http://photos-h.ak.instagram.com/hphotos-ak-xpf1/1168403_717975574964151_1110318010_a.jpg",
                    @"http://photos-c.ak.instagram.com/hphotos-ak-xaf1/10727754_310721755797258_1725692284_a.jpg",
                    @"http://photos-c.ak.instagram.com/hphotos-ak-xaf1/10693524_721754351245954_1858919319_a.jpg",
                    @"http://photos-d.ak.instagram.com/hphotos-ak-xaf1/10431876_1455459958034123_128270284_a.jpg",
                    @"http://photos-a.ak.instagram.com/hphotos-ak-xfa1/10729376_1491649877751560_206324740_a.jpg",
                    @"http://photos-e.ak.instagram.com/hphotos-ak-xfa1/10706669_260946367448548_117037371_a.jpg"];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.images.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lb = [UILabel new];
    lb.text = [NSString stringWithFormat:@"Hello to use This %ld", (long)section];
    lb.backgroundColor = [UIColor whiteColor];
    return lb;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    RoundImageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[RoundImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSString *imageString = self.images[indexPath.section];
    [cell.rImageView prSetImageWithURL:[NSURL URLWithString:imageString] placeholderImage:nil];
    return cell;
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
