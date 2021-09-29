function addition = minimize_energy(SDF_mask,Image, lambda, curvature, ind)

    % find interior and exterior mean
    inter_inds = find(SDF_mask<=0); % interior points
    exter_inds = find(SDF_mask>0); % exterior points
    inter_mean = sum(Image(inter_inds))/length(inter_inds); % interior mean
    exter_mean = sum(Image(exter_inds))/length(exter_inds); % exterior mean
    
    % force from image information
    inter_force = (Image(ind)-inter_mean).^2;
    exter_force = (Image(ind)-exter_mean).^2;
    Force = inter_force-exter_force;
        
    % gradient descent to minimize energy
    dphidt = Force./max(abs(Force)) + lambda*curvature;  

    % CFL condition
    dt = 0.45/max(abs(dphidt));
    
    addition = dt.*dphidt;
            
end

