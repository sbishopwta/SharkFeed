//
//  GridCollectionViewController.m
//  SharkFeed
//
//  Created by Steven Bishop on 2/18/17.
//  Copyright © 2017 Steven Bishop. All rights reserved.
//

#import "GridCollectionViewController.h"
#import "PhotoCollectionViewCell.h"
#import "UIView+ReusableIdentifier.h"
#import "Photo.h"
#import "PhotoDetailViewController.h"

@interface GridCollectionViewController ()
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UIRefreshControl *pullToRefreshControl;
@property (nonatomic, strong) NSArray <Photo *> *datasource;
@end

static NSInteger const NumberOfColumns = 3;

@implementation GridCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    [self setupCollectionView];
}

- (void)setup {
    self.pullToRefreshControl = [UIRefreshControl new];
    self.pullToRefreshControl.backgroundColor = [UIColor clearColor];
    [self.pullToRefreshControl beginRefreshing];
    [self.pullToRefreshControl addTarget:self action:@selector(fetchImages) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.pullToRefreshControl];
}

- (void)setupCollectionView {
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PhotoCollectionViewCell class]) bundle:nil]
          forCellWithReuseIdentifier:[PhotoCollectionViewCell reuseIdentifier]];
    
    CGSize collectionViewSize = self.collectionView.frame.size;
    
    //TODO: Is this needed?
    double sectionInsetPadding = self.flowLayout.sectionInset.left + self.flowLayout.sectionInset.right;
    double cellDimension = ((collectionViewSize.width - sectionInsetPadding) / NumberOfColumns) - self.flowLayout.minimumLineSpacing;
    CGSize cellSize = CGSizeMake(cellDimension,
                                 cellDimension);
    self.flowLayout.itemSize = cellSize;
}

#pragma mark - Actions

- (void)fetchImages {
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:[PhotoCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
    [photoCell configureWithIndexPath:indexPath];
    
    return photoCell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoDetailViewController *detailController = [PhotoDetailViewController build];
    [self.navigationController pushViewController:detailController animated:YES];
}

@end
