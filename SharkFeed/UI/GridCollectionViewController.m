//
//  GridCollectionViewController.m
//  SharkFeed
//
//  Created by Steven Bishop on 2/18/17.
//  Copyright © 2017 Steven Bishop. All rights reserved.
//

#import "GridCollectionViewController.h"
#import "FlickrAPI.h"
#import "PhotoCollectionViewCell.h"
#import "UIView+ReusableIdentifier.h"
#import "LoadingFooterView.h"
#import "Photo.h"
#import "PhotoDetailViewController.h"

@interface GridCollectionViewController ()
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UIRefreshControl *pullToRefreshControl;
@property (nonatomic, strong) NSMutableArray <Photo *> *datasource;
@property (nonatomic) NSInteger offset;
@end

@implementation GridCollectionViewController

static NSInteger const NumberOfColumns = 3;
static NSInteger const PhotoBatchSize = 25;

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    [self setupCollectionView];
    [self fetchImages];
}

- (void)setup {
    self.title = NSLocalizedString(@"SharkFeed", @"GridCollectionViewController.Title");
    self.pullToRefreshControl = [UIRefreshControl new];
    self.pullToRefreshControl.backgroundColor = [UIColor clearColor];
    [self.pullToRefreshControl beginRefreshing];
    [self.pullToRefreshControl addTarget:self action:@selector(refreshImages) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.pullToRefreshControl];
    self.offset = 1;
    self.datasource = [NSMutableArray new];
}

- (void)setupCollectionView {
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PhotoCollectionViewCell class]) bundle:nil]
          forCellWithReuseIdentifier:[PhotoCollectionViewCell reuseIdentifier]];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LoadingFooterView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:[LoadingFooterView reuseIdentifier]];
    
    CGSize collectionViewSize = self.collectionView.frame.size;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    double sectionInsetPadding = self.flowLayout.sectionInset.left + self.flowLayout.sectionInset.right;
    double cellDimension = ((collectionViewSize.width - sectionInsetPadding) / NumberOfColumns) - self.flowLayout.minimumLineSpacing;
    CGSize cellSize = CGSizeMake(cellDimension,
                                 cellDimension);
    self.flowLayout.itemSize = cellSize;
    self.flowLayout.footerReferenceSize = CGSizeMake(collectionViewSize.width, 50);
}

#pragma mark - Actions

- (void)refreshImages {
    self.datasource = [NSMutableArray new];
    self.offset = 1;
    [self.collectionView reloadData];
    [self fetchImages];
}

- (void)fetchImages {
    __weak typeof(self) weakSelf = self;
    [FlickrAPI fetchSharkImagesWithOffset:self.offset batchSize:PhotoBatchSize success:^(NSArray<Photo *> *photos) {
        weakSelf.offset++;
        [weakSelf.datasource addObjectsFromArray:photos];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadData];
            [weakSelf.pullToRefreshControl endRefreshing];
        });
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:[PhotoCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
    Photo *photo = self.datasource[indexPath.item];
    [photoCell configureWithPhoto:photo];
    
    return photoCell;
}

//TODO: Hide footer view when all images have been loaded
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    LoadingFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:[LoadingFooterView reuseIdentifier] forIndexPath:indexPath];
    
    return footerView;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger numberOfImages = self.datasource.count;
    if (indexPath.item == numberOfImages - 1 && numberOfImages >= PhotoBatchSize) {
        [self fetchImages];
    }
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Photo *photo = self.datasource[indexPath.item];
    PhotoDetailViewController *detailController = [PhotoDetailViewController buildWithPhoto:photo];
    [self.navigationController pushViewController:detailController animated:YES];
}

@end
