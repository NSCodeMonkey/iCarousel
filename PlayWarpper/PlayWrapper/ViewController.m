//
//  ViewController.m
//  PlayWarpper
//
//  Created by Tao DING on 2018/12/21.
//  Copyright © 2018 Tao DING. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<OUPCarouselViewDataSource, OUPCarouselViewDelegate>
@property (nonatomic) OUPCarouselView* carousel;
@property (nonatomic, strong) NSMutableArray* items;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.items = [NSMutableArray array];
    for (int i = 0; i < 10; i++)
    {
        [self.items addObject:@(i)];
    }
    // Do any additional setup after loading the view, typically from a nib.

    _carousel = [[OUPCarouselView alloc] init];
    _carousel.infiniteScrollEnabled = YES;
    _carousel.spacing = 1.05;
    _carousel.isFeedbackEnabled = YES;
    _carousel.autoScroll = 0.2;

    _carousel.dataSource = self;
    _carousel.delegate = self;
    [_carousel registerItemViewClass:UIImageView.class];
    [self.view addSubview:_carousel];
    _carousel.translatesAutoresizingMaskIntoConstraints = NO;
    // Layout
    [_carousel.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [_carousel.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [_carousel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [_carousel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
}

- (CGSize)carouselView:(nonnull OUPCarouselView*)carouselView sizeForItemAtIndex:(NSInteger)index
{
    return CGSizeMake(200, 200);
}

- (nonnull UIView*)carouselView:(nonnull OUPCarouselView*)carouselView viewForItemAtIndex:(NSInteger)index
{
    UIImageView* view = (UIImageView*)[carouselView dequeueReuseableViewForItemAtIndex:index];
    view.image = [UIImage imageNamed:@"page.png"];
    view.contentMode = UIViewContentModeCenter;
    UILabel* label = (UILabel*)[view viewWithTag:1];
    //create new view if no view is available for recycling
    if (!label)
    {
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:50];
        label.tag = 1;
        [view addSubview:label];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel*)[view viewWithTag:1];
    }

    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    label.text = [self.items[(NSUInteger)index] stringValue];

    return view;
}

- (NSInteger)numberOfItemsInCarouselView:(nonnull OUPCarouselView*)carouselView
{
    return _items.count;
}

- (void)carouselViewDidEndScrollingAnimation:(OUPCarouselView *)carouselView
{
    NSLog(@"current index %ld",(long)carouselView.currentItemIndex);
}

@end
