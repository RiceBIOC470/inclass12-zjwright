%Inclass 12. 

% Continue with the set of images you used for inclass 11, the same time 
% point (t = 30)
file1='011917-wntDose-esi017-RI_f0016.tif';
reader=bfGetReader(file1);
chan1=1; chan2=2; time=30; zplane=1;
iplane=reader.getIndex(zplane-1, chan2-1, time-1)+1; 
img2=bfGetPlane(reader, iplane);
imshow(img2, [500 1500]);

iplane=reader.getIndex(zplane-1, chan1-1, time-1)+1; 
img1=bfGetPlane(reader, iplane);
imshow(img1, [500 5000]);

% 1. Use the channel that marks the cell nuclei. Produce an appropriately
% smoothed image with the background subtracted. 
img2_smooth=imfilter(img2, fspecial('gaussian', 4, 2));
img2_bg=imopen(img2_smooth, strel('disk', 100));
img2_smooth_bgsub=imsubtract(img2_smooth, img2_bg);
imshow(img2_smooth, [500 1500]);

% 2. threshold this image to get a mask that marks the cell nuclei. 
img2_dil=imdilate(img2_smooth_bgsub, strel('disk',1));
figure(1)
imshow(img2_dil, [100 1000]);

% 3. Use any morphological operations you like to improve this mask (i.e.
% no holes in nuclei, no tiny fragments etc.)
%fill in holes
figure(2)
img2_closed = imclose(img2_dil, strel('disk', 6));
imshow(img2_closed, [100 1000]);
%get rid of small spots
img2_mask_final = imopen(img2_closed, strel('disk', 5));
figure(3)
imshow(img2_mask_final, [100 1000])
% 4. Use the mask together with the images to find the mean intensity for
% each cell nucleus in each of the two channels. Make a plot where each data point 
% represents one nucleus and these two values are plotted against each other
figure
img2show=cat(3, imadjust(img1), imadjust(img2_mask_final), zeros(size(img1)));
imshow(img2show)

cell_info_1 = regionprops(img2_mask_final,img1,'MeanIntensity','MaxIntensity','PixelValues','Area','Centroid');
cell_info_2 = regionprops(img2_mask_final,img2,'MeanIntensity','MaxIntensity','PixelValues','Area','Centroid');
img1_intensities=[cell_info_1.MeanIntensity];
img2_intensities=[cell_info_2.MeanIntensity];
plot(img1_intensities,img2_intensities)