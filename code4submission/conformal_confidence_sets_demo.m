%% Load in the scores and ground truth masks
% Note that these have been resized to [50,50] images from [352, 352] images
% to save space.
addpath(genpath('./'))
load('./resized_data/gt_masks.mat');
load('./resized_data/gt_masks_bb.mat');
load('./resized_data/scores.mat');
load('./resized_data/scores_BB.mat');
load('./resized_data/scores_DT.mat');
load('./resized_data/learning_idx.mat');

%% Obtain indices for the calibration and validation datasets
non_learning_idx = setdiff(1:1798, learning_idx);
cal_sample = randsample(1500, 1000);
val_sample = setdiff(1:1500, cal_sample);
cal_idx = non_learning_idx(cal_sample);
val_idx = non_learning_idx(val_sample);

cal_scores = scores_resized(:,:,cal_idx);
cal_scores_DT = scores_DT_resized(:,:,cal_idx);
cal_scores_BB_inner = scores_BB_inner_resized(:,:,cal_idx);
cal_scores_BB_outer = scores_BB_outer_resized(:,:,cal_idx);

cal_gt_masks = gt_masks_resized(:,:,cal_idx);

%% Run the calibration to obtain the conformal thresholds
% Generate inner sets
[threshold_inner, max_vals_inner] = CI_fwer(cal_scores, cal_gt_masks, 0.1);

% Generate outer sets
[threshold_outer, max_vals_dist_outer] = CI_fwer(-cal_scores_DT, 1-cal_gt_masks, 0.1);

%% Combining the original and distance transformed scores
for I = 1:15
    ex = val_idx(I);
    subplot(3,5,I)
    score_im = scores_resized(:,:,ex);
    score_im_DT = scores_DT_resized(:,:,ex);

    % Obtain the ground truth mask
    mask = gt_masks_resized(:,:,ex);

    % Obtain the inner confidence set by thresholding the scores
    predicted_inner = score_im > threshold_inner;

    % Obtain the outer confidence set by thresholding the distance transformed scores
    predicted_outer = 1 - ( (-score_im_DT) > threshold_outer);

    % Plot the result
    crplot(predicted_inner, predicted_outer, mask)
    axis image off
end

%% Obtaining calibration thresholds for the bounding box scores
% Generate inner sets
[threshold_inner_bb, max_vals_inner_bb] = CI_fwer(cal_scores_BB_inner, cal_gt_masks, 0.1);

% Generate outer sets
[threshold_outer_bb, max_vals_outer_Bb] = CI_fwer(-cal_scores_BB_outer, 1-cal_gt_masks, 0.1);

%% Conformal confidence sets for the bounding boxes
for J = 1:2
    figure
    for I = 1:15
        ex = val_idx(I);
        subplot(3,5,I)
        score_im_inner = scores_BB_inner_resized(:,:,ex);
        score_im_outer = scores_BB_outer_resized(:,:,ex);

        % Obtain the ground truth mask
        if J == 1
            mask = gt_masks_resized(:,:,ex);
        else
            mask = bb_masks_resized(:,:,ex);
        end

        % Obtain the inner confidence set by thresholding the scores
        predicted_inner = score_im_inner > threshold_inner_bb;

        % Obtain the outer confidence set by thresholding the distance transformed scores
        predicted_outer = 1 - ( (-score_im_outer) > threshold_outer_bb);

        % Plot the result
        crplot(predicted_inner, predicted_outer, mask)
        axis image off
    end
end