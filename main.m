target_name = '0001';
guided_name = '0002';

target_weight   = load(['MAToutput/',target_name,'.mat']);
guided_weight   = load(['MAToutput/',guided_name,'.mat']);

target_image    = rgb2lab( imresize( imread(['database/image/',target_name,'.png']) , [500 500] ) );
guided_image    = rgb2lab( imresize( imread(['database/image/',guided_name,'.png']) , [500 500] ) );

threshold = 0.1;


% Apply Color Transfer function on Target Image

% transformFunc = @(x) getTransformedImage( x ,target_image,guided_image , target_weight,guided_weight , i,j , threshold);
% img_rlt = arrayfun( transformFunc , target_image);

% imshow(img_rlt);
isInGuided = false(1,14);
for i = 0:13
    if(  ismember(i, guided_weight.predict_label ) )
        isInGuided(i+1) = true;
    end
end

const SKY = 0;
const COLOR_L = 1;
const COLOR_a = 2;
const COLOR_b = 3;

% Get mean for L of sky
mean_l_sky_target = getMean(target_image,target_weight.predict_label,SKY,COLOR_L);
mean_l_sky_guided = getMean(guided_image,guided_weight.predict_label,SKY,COLOR_L); 

% Get mean for a of sky
mean_a_sky_target = getMean(target_image,target_weight.predict_label,SKY,COLOR_a);
mean_a_sky_guided = getMean(guided_image,guided_weight.predict_label,SKY,COLOR_a); 

% Get mean for b of sky
mean_b_sky_target = getMean(target_image,target_weight.predict_label,SKY,COLOR_b);
mean_b_sky_guided = getMean(guided_image,guided_weight.predict_label,SKY,COLOR_b); 

% mean of color
color_diff = sqrt( ( mean_a_sky_target - mean_a_sky_guided )^2 + ( mean_b_sky_target - mean_b_sky_guided )^2 );

% Get beta
% TODO : 'Color' in paper is a and b
% TODO : Beta is mean of ( mean of a ) and ( mean of b )
cBeta = tanh(color_diff);

% Get Tn(x)
tn_x_ = zeros(1,14,'single'); 
for i = 0:13
    LIn = getMean(target_image,target_weight.predict_label,i,COLOR_L);
    LRn = getMean(guided_image,guided_weight.predict_label,i,COLOR_L);
    tn_x_(i+1) = LIn + cBeta*( LRn - LIn );
end

img_rlt = target_image;
for i = 1 : 500
    for j = 1:500
        % Get Wn_x
        wn_x_ = getNormalizeWeight(target_weight.predict_value(i,j),,SKY);

        if(isInGuided( target_weight.predict_label(i,j) + 1 ))
            % Use T(x)
            img_rlt(i,j) = getMatchedTransform( target_image(i,j) , guided_image(i,j) , tn_x_ , wn_x_ );
        else
            % Use Color Temperature transform
            img_rlt(i,j) = getNOTMatchedTransformer() ;
        end 
    end
end