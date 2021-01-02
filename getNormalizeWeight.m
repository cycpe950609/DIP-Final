% NOTE : if label is not in the image , weight must be ZERO
function rtv_weights = getNormalizeWeight(weights,threshold,label)% label : 因為天空的weight要為0
    rtv_weights = weights;

    for i = 1 : 14
        if( rtv_weights < threshold ) 
            rtv_weights(i) = 0;
        end
    end

    rtv_weights = rtv_weights./sum(rtv_weights);
end