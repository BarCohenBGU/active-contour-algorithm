function curvature = get_curvature(SDF_mask,ind)
% compute curvature along SDF

    [rowDim, colDim] = size(SDF_mask);        
    [row,col] = ind2sub([rowDim,colDim],ind);  % return points as loction (subscripts) insted linear index

    % neighbors loction
    rowUp = row-1; 
    leftCol = col-1; 
    rowDown = row+1; 
    rightCol = col+1;

    % bounds checking  
    rowUp(rowUp<1) = 1; 
    leftCol(leftCol<1) = 1;              
    rowDown(rowDown>rowDim)=rowDim; 
    rightCol(rightCol>colDim) = colDim;    

    % get indexes for 8 neighbors
    downNeig = sub2ind(size(SDF_mask),rowDown,col);    
    upNeig = sub2ind(size(SDF_mask),rowUp,col);
    leftNeig = sub2ind(size(SDF_mask),row,leftCol);
    rightNeig = sub2ind(size(SDF_mask),row,rightCol);
    downLeftNeig = sub2ind(size(SDF_mask),rowDown,leftCol);
    downRightNeig = sub2ind(size(SDF_mask),rowDown,rightCol);
    upLeftNeig = sub2ind(size(SDF_mask),rowUp,leftCol);
    upRightNeig = sub2ind(size(SDF_mask),rowUp,rightCol);
    
    % get Finite difference of SDF
    F_x  = 0.5*SDF_mask(rightNeig)-0.5*SDF_mask(leftNeig);
    F_y  = 0.5*SDF_mask(downNeig)-0.5*SDF_mask(upNeig);
    F_xx = SDF_mask(rightNeig)-2*SDF_mask(ind)+SDF_mask(leftNeig);
    F_yy = SDF_mask(downNeig)-2*SDF_mask(ind)+SDF_mask(upNeig);
    F_xy = 0.25*SDF_mask(downLeftNeig)-0.25*SDF_mask(upLeftNeig)-0.25*SDF_mask(downRightNeig)+0.25*SDF_mask(upRightNeig);
    F_x2 = F_x.^2;
    F_y2 = F_y.^2;

    % compute curvature (Kappa)
    curvature = ((F_x2.*F_yy + F_y2.*F_xx - 2*F_x.*F_y.*F_xy)./(F_x2 + F_y2).^(3/2));   
end

