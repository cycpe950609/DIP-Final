function [L,a,b] = getNOTMatchedTransformer( color_target , guided_image , guided_weight , NewLuminance )
    L = NewLuminance;
    a = color_target(2);
    b = color_target(3);
end