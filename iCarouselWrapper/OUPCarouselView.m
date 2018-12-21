//
//  OUPCarouselView.m
//  iCarouselExample
//
//  Created by Tao DING on 2018/12/20.
//

#import "OUPCarouselView.h"

@interface OUPCarouselView ()<iCarouselDataSource, iCarouselDelegate>
{
    Class _itemClass;
    UIView* _reusingView;
    iCarousel* _iCarousel;
    struct
    {
        unsigned int carouselViewWillBeginScrollingAnimation : 1;
        unsigned int carouselViewDidEndScrollingAnimation : 1;
        unsigned int carouselViewDidScroll : 1;
        unsigned int carouselViewCurrentItemIndexDidChange : 1;
        unsigned int carouselViewWillBeginDragging : 1;
        unsigned int carouselViewDidEndDragging : 1;
        unsigned int carouselViewWillBeginDecelerating : 1;
        unsigned int carouselViewDidEndDecelerating : 1;
        unsigned int shouldSelectItemAtIndex : 1;
        unsigned int didSelectItemAtIndex : 1;
        unsigned int itemTransformForOffset : 1;
    } delegateRespondsTo;
}
@property (nonatomic) UISelectionFeedbackGenerator* feedback;

@end

@implementation OUPCarouselView
@synthesize currentItemIndex = _currentItemIndex;

const CGFloat defaultSpacing = 1.0;
const NSInteger defaultNumberofVisibleItems = -1;
const CGFloat defaultFadeMin = (CGFloat)-INFINITY;
const CGFloat defaultFadeMax = (CGFloat)INFINITY;
const CGFloat defaultFadeRange = 1.0;
const CGFloat defaultFadeMinAlpha = 0.0;

#pragma mark - init

- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _isFeedbackEnabled = NO;
    _bounces = YES;
    _scrollEnabled = YES;
    _autoscroll = 1.0;
    _numberOfVisibleItems = defaultNumberofVisibleItems;
    _spacing = defaultSpacing;
    _fadeMin = defaultFadeMin;
    _fadeMax = defaultFadeMax;
    _fadeRange = defaultFadeRange;
    _fadeMinAlpha = defaultFadeMinAlpha;

    _iCarousel = [[iCarousel alloc] init];
    _iCarousel.type = iCarouselTypeLinear;

    [self addSubview:_iCarousel];
    _iCarousel.translatesAutoresizingMaskIntoConstraints = NO;
    // Layout
    [_iCarousel.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [_iCarousel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [_iCarousel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [_iCarousel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;

    if (_dataSource)
    {
        [self reloadData];
    }
}

#pragma mark - public

- (void)registerClass:(nullable Class)itemClass
{
    _itemClass = itemClass;
}

- (UIView*)dequeueReuseableViewForItemAtIndex:(NSInteger)index
{
    UIView* view = _reusingView;
    if (view == nil)
    {
        NSAssert(_itemClass != nil, @"need call registerClass:itemClass");
        view = [_itemClass new];

        CGSize size = [_dataSource carouselView:self sizeForItemAtIndex:index];
        view.bounds = CGRectMake(0, 0, size.width, size.height);
    }
    if (_reusingView)
    {
        _reusingView = nil;
    }
    return view;
}

- (void)scrollByOffset:(CGFloat)offset duration:(NSTimeInterval)duration
{
    [_iCarousel scrollByOffset:offset duration:duration];
}

- (void)scrollToOffset:(CGFloat)offset duration:(NSTimeInterval)duration
{
    [_iCarousel scrollToOffset:offset duration:duration];
}

- (void)scrollByNumberOfItems:(NSInteger)itemCount duration:(NSTimeInterval)duration
{
    [_iCarousel scrollByNumberOfItems:itemCount duration:duration];
}

- (void)scrollToItemAtIndex:(NSInteger)index duration:(NSTimeInterval)duration
{
    [_iCarousel scrollToItemAtIndex:index duration:duration];
}
- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated
{
    [_iCarousel scrollToItemAtIndex:index animated:animated];
}

- (nullable UIView*)itemViewAtIndex:(NSInteger)index
{
    return [_iCarousel itemViewAtIndex:index];
}

- (NSInteger)indexOfItemView:(UIView*)view
{
    return [_iCarousel indexOfItemView:view];
}

- (NSInteger)indexOfItemViewOrSubview:(UIView*)view
{
    return [_iCarousel indexOfItemViewOrSubview:view];
}

- (CGFloat)offsetForItemAtIndex:(NSInteger)index
{
    return [_iCarousel offsetForItemAtIndex:index];
}

- (nullable UIView*)itemViewAtPoint:(CGPoint)point
{
    return [_iCarousel itemViewAtPoint:point];
}

- (void)removeItemAtIndex:(NSInteger)index animated:(BOOL)animated
{
    [_iCarousel removeItemAtIndex:index animated:animated];
}

- (void)insertItemAtIndex:(NSInteger)index animated:(BOOL)animated
{
    [_iCarousel insertItemAtIndex:index animated:animated];
}

- (void)reloadItemAtIndex:(NSInteger)index animated:(BOOL)animated
{
    [_iCarousel reloadItemAtIndex:index animated:animated];
}

- (void)reloadData
{
    [_iCarousel reloadData];
}

#pragma mark - iCarouselDataSource

- (NSInteger)numberOfItemsInCarousel:(iCarousel*)carousel
{
    return [_dataSource numberOfItemsInCarouselView:self];
}

- (UIView*)carousel:(iCarousel*)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView*)view
{
    _reusingView = view;
    UIView* viewForItem = [_dataSource carouselView:self viewForItemAtIndex:index];
    return viewForItem;
}

#pragma mark - iCarouselDelegate

- (void)carouselWillBeginScrollingAnimation:(iCarousel*)carousel
{
    if (delegateRespondsTo.carouselViewWillBeginScrollingAnimation)
    {
        [_delegate carouselViewWillBeginScrollingAnimation:self];
    }
}

- (void)carouselDidEndScrollingAnimation:(iCarousel*)carousel
{
    if (delegateRespondsTo.carouselViewDidEndScrollingAnimation)
    {
        [_delegate carouselViewDidEndScrollingAnimation:self];
    }
}

- (void)carouselDidScroll:(iCarousel*)carousel
{
    if (delegateRespondsTo.carouselViewDidScroll)
    {
        [_delegate carouselViewDidScroll:self];
    }
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel*)carousel
{
    [self feedbackIfNeeded];
    if (delegateRespondsTo.carouselViewCurrentItemIndexDidChange)
    {
        [_delegate carouselViewCurrentItemIndexDidChange:self];
    }
}

- (void)carouselWillBeginDragging:(iCarousel*)carousel
{
    [self prepareFeedback];
    if (delegateRespondsTo.carouselViewWillBeginDragging)
    {
        [_delegate carouselViewWillBeginDragging:self];
    }
}

- (void)carouselDidEndDragging:(iCarousel*)carousel willDecelerate:(BOOL)decelerate
{
    if (delegateRespondsTo.carouselViewDidEndDragging)
    {
        [_delegate carouselViewDidEndDragging:self willDecelerate:decelerate];
    }
}

- (void)carouselWillBeginDecelerating:(iCarousel*)carousel
{
    if (delegateRespondsTo.carouselViewWillBeginDecelerating)
    {
        [_delegate carouselViewWillBeginDecelerating:self];
    }
}

- (void)carouselDidEndDecelerating:(iCarousel*)carousel
{
    if (delegateRespondsTo.carouselViewDidEndDecelerating)
    {
        [_delegate carouselViewDidEndDecelerating:self];
    }
}

- (BOOL)carousel:(iCarousel*)carousel shouldSelectItemAtIndex:(NSInteger)index
{
    if (delegateRespondsTo.shouldSelectItemAtIndex)
    {
        return [_delegate carouselView:self shouldSelectItemAtIndex:index];
    }
    return YES;
}

- (void)carousel:(iCarousel*)carousel didSelectItemAtIndex:(NSInteger)index
{
    if (delegateRespondsTo.didSelectItemAtIndex)
    {
        [_delegate carouselView:self didSelectItemAtIndex:index];
    }
}

- (CATransform3D)carousel:(iCarousel*)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    if (delegateRespondsTo.itemTransformForOffset)
    {
        return [_delegate carouselView:self itemTransformForOffset:offset baseTransform:transform];
    }
    return transform;
}

- (CGFloat)carousel:(iCarousel*)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            return _wrapEnabled;
        }
        case iCarouselOptionSpacing:
        {
            return _spacing == defaultSpacing ? value : _spacing;
        }
        case iCarouselOptionVisibleItems:
        {
            return _numberOfVisibleItems == defaultNumberofVisibleItems ? value : _numberOfVisibleItems;
        }
        case iCarouselOptionFadeMax:
        {
            return _fadeMax == defaultFadeMax ? value : _fadeMax;
        }
        case iCarouselOptionFadeMin:
        {
            return _fadeMin == defaultFadeMin ? value : _fadeMin;
        }
        case iCarouselOptionFadeRange:
        {
            return _fadeRange == defaultFadeRange ? value : _fadeRange;
        }
        case iCarouselOptionFadeMinAlpha:
        {
            return _fadeMinAlpha == defaultFadeMinAlpha ? value : _fadeMinAlpha;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionOffsetMultiplier:
        {
            return value;
        }
        default:
        {
            return value;
        }
    }
}

#pragma mark - properties
- (void)setDataSource:(id<OUPCarouselViewDataSource>)dataSource
{
    _dataSource = dataSource;
    _iCarousel.dataSource = self;
}

- (void)setDelegate:(id<OUPCarouselViewDelegate>)delegate
{
    _delegate = delegate;
    delegateRespondsTo.carouselViewWillBeginScrollingAnimation = [delegate respondsToSelector:@selector(carouselViewWillBeginScrollingAnimation:)];
    delegateRespondsTo.carouselViewDidEndScrollingAnimation = [delegate respondsToSelector:@selector(carouselViewDidEndScrollingAnimation:)];
    delegateRespondsTo.carouselViewDidScroll = [delegate respondsToSelector:@selector(carouselViewDidScroll:)];
    delegateRespondsTo.carouselViewCurrentItemIndexDidChange = [delegate respondsToSelector:@selector(carouselViewCurrentItemIndexDidChange:)];
    delegateRespondsTo.carouselViewWillBeginDragging = [delegate respondsToSelector:@selector(carouselViewWillBeginDragging:)];
    delegateRespondsTo.carouselViewDidEndDragging = [delegate respondsToSelector:@selector(carouselViewDidEndDragging:willDecelerate:)];
    delegateRespondsTo.carouselViewWillBeginDecelerating = [delegate respondsToSelector:@selector(carouselViewWillBeginDecelerating:)];
    delegateRespondsTo.carouselViewDidEndDecelerating = [delegate respondsToSelector:@selector(carouselViewDidEndDecelerating:)];
    delegateRespondsTo.shouldSelectItemAtIndex = [delegate respondsToSelector:@selector(carouselView:shouldSelectItemAtIndex:)];
    delegateRespondsTo.didSelectItemAtIndex = [delegate respondsToSelector:@selector(carouselView:didSelectItemAtIndex:)];
    delegateRespondsTo.itemTransformForOffset = [delegate respondsToSelector:@selector(carouselView:itemTransformForOffset:baseTransform:)];
    _iCarousel.delegate = self;
}

- (void)setBounces:(BOOL)bounces
{
    _bounces = bounces;
    _iCarousel.bounces = bounces;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled
{
    _scrollEnabled = scrollEnabled;
    _iCarousel.scrollEnabled = scrollEnabled;
}

- (void)setPagingEnabled:(BOOL)pagingEnabled
{
    _pagingEnabled = pagingEnabled;
    _iCarousel.pagingEnabled = pagingEnabled;
}

- (void)setAutoscroll:(CGFloat)autoscroll
{
    _autoscroll = autoscroll;
    _iCarousel.autoscroll = autoscroll;
}

- (void)setCurrentItemIndex:(NSInteger)currentItemIndex
{
    _currentItemIndex = currentItemIndex;
    _iCarousel.currentItemIndex = currentItemIndex;
}

- (NSInteger)currentItemIndex
{
    _currentItemIndex = _iCarousel.currentItemIndex;
    return _currentItemIndex;
}

- (UISelectionFeedbackGenerator*)feedback
{
    if (@available(iOS 10.0, *))
    {
        if (!_feedback)
        {
            _feedback = [UISelectionFeedbackGenerator new];
        }

        return _feedback;
    }
    else
    {
        return nil;
    }
}

#pragma mark - private

- (BOOL)shouldFeedback
{
    if (@available(iOS 10.0, *))
    {
        return _isFeedbackEnabled && (_iCarousel.scrolling || _iCarousel.dragging || _iCarousel.decelerating);
    }

    return NO;
}

- (void)prepareFeedback
{
    if (@available(iOS 10.0, *))
    {
        if (_isFeedbackEnabled)
        {
            [self.feedback prepare];
        }
    }
}

- (void)feedbackIfNeeded
{
    if (self.shouldFeedback)
    {
        [self.feedback selectionChanged];
    }
}

@end
