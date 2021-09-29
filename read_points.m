function [pts,k] = read_points(image, n)
%   Read manually-defined points from image
%   displays the image in the current figure,
%   then records the position of each click of button 1 of the mouse in the
%   figure, and stops when another button is clicked. The result is a 2 x NPOINTS matrix; each
%   column is [X; Y] for one point.
% 
%   POINTS = READPOINTS(IMAGE, N) reads up to N points only.
    if nargin < 2
        n = Inf;
        pts = zeros(2, 0);
    else
        pts = zeros(2, n);
    end
    imshow(image, []);     % display image
    str = 'Select the leaves by clicking with the mouse. When done, click any other button on the mouse';
    title(str,'Color','b','FontSize',12);
    xold = 0;
    yold = 0;
    k = 0;
    hold on;           % and keep it there while we plot
    while 1
        [xi, yi, but] = ginput(1);      % get a point
        if ~isequal(but, 1)             % stop if not button 1
            break
        end
        k = k + 1;
        pts(1,k) = xi;
        pts(2,k) = yi;
          %if xold
          %    plot([xold xi], [yold yi], 'go-');  % draw as we go
          %else
              plot(xi, yi, 'go');         % first point on its own
          %end
          if isequal(k, n)
              break
          end
          xold = xi;
          yold = yi;
      end
    hold off;
    if k < size(pts,2)
        pts = pts(:, 1:k);
    end
end