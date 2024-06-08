% Step 1: Load grayscale image into variable 'im'
im = imread('butterfly.jpg');
im = rgb2gray(im); % Convert to grayscale if it's a color image

% Step 2: Implement Otsu's method
step = 50;
maxVariance = 0;
optimalLevel = 0;

for level = 50:step:250
    whites = sum(im(:) > level);
    blacks = sum(im(:) <= level);
    
    mean_wh = mean(im(im > level));
    mean_bl = mean(im(im <= level));
    
    variance = whites * blacks * ((mean_wh / whites) - (mean_bl / blacks))^2;

    fprintf('Level: %d, Variance: %f\n', level, variance); % Debugging output

    if variance > maxVariance
        maxVariance = variance;
        optimalLevel = level;
    end
end

optimalLevel

% Binarize the image using the optimal level
binarized_im = imbinarize(im, optimalLevel / 255); % imbinarize() expects level in the range [0,1]

% Apply histogram equalization
im_eq = histeq(im);

% Perform Otsu's method on the equalized image
level_eq = graythresh(im_eq) * 255;
binarized_im_eq = imbinarize(im_eq, level_eq / 255);

% Show original image, binarized image using Otsu, and binarized image after histogram equalization
figure;
subplot(1,3,1);
imshow(im);
title('Original Grayscale Image');

subplot(1,3,2);
imshow(binarized_im);
title('Binarized Image with Otsu');

subplot(1,3,3);
imshow(binarized_im_eq);
title('Binarized Image after Histogram Equalization');

% Create filter masks
meanMask = fspecial('average', [3, 3]); % 3x3 mean filter mask
gaussMask = fspecial('gaussian', [3, 3], 1); % 3x3 Gaussian filter mask
prewittMask = fspecial('prewitt'); % Prewitt filter mask
sobelMask = fspecial('sobel'); % Sobel filter mask
logMask = fspecial('log', [5, 5], 0.5); % Laplacian of Gaussian filter mask

% Apply filters using imfilter
meanFiltered = imfilter(im, meanMask);
gaussFiltered = imfilter(im, gaussMask);
prewittFiltered = imfilter(im, prewittMask);
sobelFiltered = imfilter(im, sobelMask);
logFiltered = imfilter(im, logMask);

% Display original and filtered images
figure;
subplot(2, 3, 1);
imshow(im);
title('Original Image');

subplot(2, 3, 2);
imshow(meanFiltered);
title('Mean Filtered');

subplot(2, 3, 3);
imshow(gaussFiltered);
title('Gaussian Filtered');

subplot(2, 3, 4);
imshow(prewittFiltered);
title('Prewitt Filtered');

subplot(2, 3, 5);
imshow(sobelFiltered);
title('Sobel Filtered');

subplot(2, 3, 6);
imshow(logFiltered);
title('Laplacian of Gaussian Filtered');

% Define 1-dimensional filter function
function result = my_filter(im, mask)
    result = conv2(im, mask, 'same');
end

% Apply 1-dimensional filters along rows and columns for mean and median masks
meanFilteredRow = my_filter(im, meanMask);
meanFilteredCol = my_filter(im', meanMask)'; % Transpose back after filtering rows
medianFilteredRow = my_filter(im, ones(1, 3) / 3); % 1D median filter along rows
medianFilteredCol = my_filter(im', ones(1, 3) / 3)'; % 1D median filter along columns

% Display mean and median filtered images
figure;
subplot(2, 2, 1);
imshow(meanFilteredRow);
title('Mean Filtered (Row)');

subplot(2, 2, 2);
imshow(meanFilteredCol);
title('Mean Filtered (Column)');

subplot(2, 2, 3);
imshow(medianFilteredRow);
title('Median Filtered (Row)');

subplot(2, 2, 4);
imshow(medianFilteredCol);
title('Median Filtered (Column)');
