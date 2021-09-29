function SDF_mask = re_initialization(SDF_mask, dt)

    % forward/backward differences
    a = SDF_mask - shiftRight(SDF_mask); % backward for cols
    b = shiftLeft(SDF_mask) - SDF_mask; % forward for cols
    c = SDF_mask - shiftDown(SDF_mask); % backward for rows
    d = shiftUp(SDF_mask) - SDF_mask; % forward for rows
    
    % variables for + and - for each a,b,c,d
    a_positive = a;  
    a_negative = a; 
    b_positive = b;  
    b_negative = b;
    c_positive = c;  
    c_negative = c;
    d_positive = d;  
    d_negative = d;

    % Split a,b,c,d to positive and negative
    a_positive(a < 0) = 0;
    a_negative(a > 0) = 0;
    b_positive(b < 0) = 0;
    b_negative(b > 0) = 0;
    c_positive(c < 0) = 0;
    c_negative(c > 0) = 0;
    d_positive(d < 0) = 0;
    d_negative(d > 0) = 0;

    gMask = zeros(size(SDF_mask));
    mask_pos_ind = find(SDF_mask > 0);
    mask_neg_ind = find(SDF_mask < 0);
    
    gMask(mask_pos_ind) = sqrt(max(a_positive(mask_pos_ind).^2, b_negative(mask_pos_ind).^2) ...
                       + max(c_positive(mask_pos_ind).^2, d_negative(mask_pos_ind).^2)) - 1;
    gMask(mask_neg_ind) = sqrt(max(a_negative(mask_neg_ind).^2, b_positive(mask_neg_ind).^2) ...
                       + max(c_negative(mask_neg_ind).^2, d_positive(mask_neg_ind).^2)) - 1;

    SDF_mask = SDF_mask - dt .* sign_function(SDF_mask) .* gMask;

end
  
% transpose the matrix and shift down
function shift = shiftDown(M)
  shift = shiftRight(M')';
end

% each column moves to the left\ each row moves up
function shift = shiftLeft(M)
  shift = [ M(:,2:size(M,2)) M(:,size(M,2)) ];
end

% each column moves to the right\ each row moves down
function shift = shiftRight(M)
  shift = [ M(:,1) M(:,1:size(M,2)-1) ];
end

% transpose the matrix and shift up
function shift = shiftUp(M)
  shift = shiftLeft(M')';
end
  
function S = sign_function(SDF_mask)
  S = SDF_mask ./ sqrt(SDF_mask.^2 + 1);  
end

