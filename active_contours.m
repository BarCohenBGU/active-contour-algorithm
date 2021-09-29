function [seg, SDF_mask] = active_contours(Image, init_mask, max_its, lambda, display)

  % bwdist computes the euclidean distance transform of the binary image BW
  % SDF_mask is a signed distance map (SDF) from mask - the sign determined by
  % whether pixle x is in mask (negative values)
  SDF_mask = bwdist(init_mask)-bwdist(1-init_mask)+init_mask-0.5;
  
  % main loop for iterations
  for iter = 1:max_its
    
    % find points beetwen -1.2 to 1.2 elements- the curve's narrow band
    ind = find(SDF_mask <= 1.2 & SDF_mask >= -1.2);
    
    % force from curvature penalty
    curvature = get_curvature(SDF_mask,ind);    
  
    % minimize the energy
    addition = minimize_energy (SDF_mask, Image, lambda, curvature, ind);
    
    %  update the curve
    SDF_mask(ind) = SDF_mask(ind) + addition;
    
    % level set re-initialization - Keep SDF smooth
    SDF_mask = re_initialization(SDF_mask, 0.5);

    % display intartions of contour    
%     if(mod(iter,20) == 0) 
%       figure(3);
%       subplot(2,5,(iter/20));
%       imshow(Image,'initialmagnification',200,'displayrange',[0 255]); hold on;
%       contour(SDF_mask, [0 0], 'g','LineWidth',4);
%       contour(SDF_mask, [0 0], 'k','LineWidth',2);
%       hold off; 
%       title([num2str(iter) ' Iterations']); 
%       drawnow;
%     end
    
    % iterations output
    if((display==true)&&(mod(iter,20) == 0))
      showCurveAndPhi(Image,SDF_mask,iter);  
    end
    
  end
  
  % final output without iterations
  if(display==false)
    showCurveAndPhi(Image,SDF_mask,iter);
  end  
  
  % make mask from SDF
   seg = SDF_mask<=0;

  
% Displays the curve contours
function showCurveAndPhi(I, phi, i)
  imshow(I,'initialmagnification',200,'displayrange',[0 255]); 
  hold on;
  contour(phi, [0 0], 'g','LineWidth',4);
  contour(phi, [0 0], 'k','LineWidth',2);
  hold off; 
  title([num2str(i) ' Iterations']); 
  drawnow; 
