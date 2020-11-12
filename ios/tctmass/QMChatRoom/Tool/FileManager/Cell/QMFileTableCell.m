//
//  QMFileTableCell.m
//  IMSDK-OC
//
//  Created by HCF on 16/8/11.
//  Copyright © 2016年 HCF. All rights reserved.
//

#import "QMFileTableCell.h"
#import "QMFileModel.h"

@interface QMFileTableCell () {
    UIImageView *_fileImageView;
    UILabel *_fileName;
    UILabel *_fileSize;
    UILabel *_fileDate;
}

@end

@implementation QMFileTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    _fileImageView = [[UIImageView alloc] init];
    _fileImageView.frame = CGRectMake(20, 10, 60, 60);
    _fileImageView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_fileImageView];
    
    _fileName = [[UILabel alloc] init];
    _fileName.frame = CGRectMake(90, 10, kScreenWidth-150, 20);
    _fileName.font = [UIFont systemFontOfSize:16];
    _fileName.textColor = [UIColor blackColor];
    [self.contentView addSubview:_fileName];
    
    _fileSize = [[UILabel alloc] init];
    _fileSize.frame = CGRectMake(90, 30, kScreenWidth-150, 20);
    _fileSize.font = [UIFont systemFontOfSize:14];
    _fileSize.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_fileSize];
    
    _fileDate = [[UILabel alloc] init];
    _fileDate.frame = CGRectMake(90, 50, kScreenWidth-150, 20);
    _fileDate.font = [UIFont systemFontOfSize:14];
    _fileDate.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_fileDate];
    
    self.pickedItemImageView = [[UIImageView alloc] init];
    self.pickedItemImageView.frame = CGRectMake(kScreenWidth-50, 25, 30, 30);
    self.pickedItemImageView.image = [UIImage imageNamed:@"ic_checkbox_pressed"];
    [self.contentView addSubview:self.pickedItemImageView];
}

- (void)configureWithModel:(QMFileModel *)model {
    _fileName.text = model.fileName;
    _fileSize.text = model.fileSize;
    _fileDate.text = model.fileDate;
    
    if ([model.fileName.pathExtension.lowercaseString isEqualToString:@"doc"]||[model.fileName.pathExtension.lowercaseString isEqualToString:@"docx"]) {
        _fileImageView.image = [UIImage imageNamed:@"custom_file_doc"];
    }else if ([model.fileName.pathExtension.lowercaseString isEqualToString:@"xlsx"]||[model.fileName.pathExtension.lowercaseString isEqualToString:@"xls"]) {
        _fileImageView.image = [UIImage imageNamed:@"custom_file_xlsx"];
    }else if ([model.fileName.pathExtension.lowercaseString isEqualToString:@"ppt"]||[model.fileName.pathExtension.lowercaseString isEqualToString:@"pptx"]) {
        _fileImageView.image = [UIImage imageNamed:@"custom_file_pptx"];
    }else if ([model.fileName.pathExtension.lowercaseString isEqualToString:@"pdf"]) {
        _fileImageView.image = [UIImage imageNamed:@"custom_file_pdf"];
    }else if ([model.fileName.pathExtension.lowercaseString isEqualToString:@"mp3"]) {
        _fileImageView.image = [UIImage imageNamed:@"custom_file_mp3"];
    }else if ([model.fileName.pathExtension.lowercaseString isEqualToString:@"mov"]||[model.fileName.pathExtension.lowercaseString isEqualToString:@"mp4"]) {
        _fileImageView.image = [UIImage imageNamed:@"custom_file_mov"];
    }else if ([model.fileName.pathExtension.lowercaseString isEqualToString:@"png"]||[model.fileName.pathExtension.lowercaseString isEqualToString:@"jpg"]||[model.fileName.pathExtension.lowercaseString isEqualToString:@"bmp"]||[model.fileName.pathExtension.lowercaseString isEqualToString:@"jpeg"]) {
        _fileImageView.image = [UIImage imageNamed:@"custom_file_bmp"];
    }else {
        _fileImageView.image = [UIImage imageNamed:@"custom_file_other"];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
