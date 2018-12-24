//
//  OUPCarouselView.h
//  iCarouselExample
//
//  Created by Tao DING on 2018/12/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OUPCarouselView;

@protocol OUPCarouselViewDataSource<NSObject>

- (NSInteger)numberOfItemsInCarouselView:(OUPCarouselView*)carouselView;
- (UIView*)carouselView:(OUPCarouselView*)carouselView viewForItemAtIndex:(NSInteger)index;

@end

@protocol OUPCarouselViewDelegate<NSObject>

- (CGSize)carouselView:(OUPCarouselView*)carouselView sizeForItemAtIndex:(NSInteger)index;

@optional
- (void)carouselViewWillBeginScrollingAnimation:(OUPCarouselView*)carouselView;
- (void)carouselViewDidEndScrollingAnimation:(OUPCarouselView*)carouselView;
- (void)carouselViewDidScroll:(OUPCarouselView*)carouselView;
- (void)carouselViewCurrentItemIndexDidChange:(OUPCarouselView*)carouselView;
- (void)carouselViewWillBeginDragging:(OUPCarouselView*)carouselView;
- (void)carouselViewDidEndDragging:(OUPCarouselView*)carouselView willDecelerate:(BOOL)decelerate;
- (void)carouselViewWillBeginDecelerating:(OUPCarouselView*)carouselView;
- (void)carouselViewDidEndDecelerating:(OUPCarouselView*)carouselView;

- (BOOL)carouselView:(OUPCarouselView*)carouselView shouldSelectItemAtIndex:(NSInteger)index;
- (void)carouselView:(OUPCarouselView*)carouselView didSelectItemAtIndex:(NSInteger)index;

- (CATransform3D)carouselView:(OUPCarouselView*)carouselView itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform;

@end

@interface OUPCarouselView : UIView

@property (nonatomic, weak) IBOutlet id<OUPCarouselViewDataSource> dataSource;
@property (nonatomic, weak) IBOutlet id<OUPCarouselViewDelegate> delegate;

@property (nonatomic) IBInspectable BOOL isFeedbackEnabled NS_AVAILABLE_IOS(10_0);

/*
 Sets whether the carousel should bounce past the end and return, or stop dead. Note that this has no effect on carousel types that are designed to wrap, or where the carouselShouldWrap delegate method returns YES.
 */
@property (nonatomic, assign) BOOL bounces;

@property (nonatomic, assign, getter=isScrollEnabled) BOOL scrollEnabled;
@property (nonatomic, assign, getter=isPagingEnabled) BOOL pagingEnabled;

/*This property can be used to set the carousel scrolling at a constant speed. A value of 1.0 would scroll the carousel forwards at a rate of one item per second. The autoscroll value can be positive or negative and defaults to 0.0 (stationary). Autoscrolling will stop if the user interacts with the carousel, and will resume when they stop.*/
@property (nonatomic, assign) CGFloat autoScroll;

@property (nonatomic, assign, getter=isInfiniteScrollEnabled) BOOL infiniteScrollEnabled;

/*
 The maximum number of carousel item views to be displayed concurrently on screen . This property is important for performance optimisation, and is calculated automatically based on the carousel type and view frame.
 */
@property (nonatomic) NSInteger numberOfVisibleItems;

/*
 The spacing between item views. This value is multiplied by the item width (or height, if the carousel is vertical) to get the total space between each item, so a value of 1.0 (the default) means no space between views (unless the views already include padding, as they do in many of the example projects).
 */
@property (nonatomic) CGFloat spacing;

/*
 These four options control the fading out of carousel item views based on their offset from the currently centered item. FadeMin is the minimum negative offset an item view can reach before it begins to fade. FadeMax is the maximum positive offset a view can reach before if begins to fade. FadeRange is the distance over which the fadeout occurs, measured in multiples of an item width (defaults to 1.0), and FadeMinAlpha is the minimum alpha value to which the views will fade (defaults to 0.0 - fully transparent).
 */
@property (nonatomic) CGFloat fadeMin;    //距中间左侧开始第几个item开始淡出
@property (nonatomic) CGFloat fadeMax;    //距中间右侧开始第几个item开始淡出
@property (nonatomic) CGFloat fadeRange;  //淡出过程跨几个item
@property (nonatomic) CGFloat fadeMinAlpha;

@property (nonatomic, assign) NSInteger currentItemIndex;

- (void)registerItemViewClass:(Class)itemClass;
- (UIView*)dequeueReuseableViewForItemAtIndex:(NSInteger)index;

- (void)scrollByOffset:(CGFloat)offset duration:(NSTimeInterval)duration;
- (void)scrollToOffset:(CGFloat)offset duration:(NSTimeInterval)duration;
- (void)scrollByNumberOfItems:(NSInteger)itemCount duration:(NSTimeInterval)duration;
- (void)scrollToItemAtIndex:(NSInteger)index duration:(NSTimeInterval)duration;
- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated;

- (nullable UIView*)itemViewAtIndex:(NSInteger)index;
- (NSInteger)indexOfItemView:(UIView*)view;
- (NSInteger)indexOfItemViewOrSubview:(UIView*)view;
- (CGFloat)offsetForItemAtIndex:(NSInteger)index;
- (nullable UIView*)itemViewAtPoint:(CGPoint)point;

- (void)removeItemAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)insertItemAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)reloadItemAtIndex:(NSInteger)index animated:(BOOL)animated;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
