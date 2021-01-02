function [L,a,b] = getMatchedTransformer( color_target , color_guided , tn_x_ , wn_x_ )
    L = sum( wn_x_ .* tn_x_ , 'all');
    a = color_target(2) ; 
    b = color_target(3) ; 
end