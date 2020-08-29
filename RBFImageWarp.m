function im2 = RBFImageWarp(im, psrc, pdst)
%% basic image manipulations
% get image (matrix) size
[h,w,dim] = size(im);
im2 = im;
[X,Y] = meshgrid(1:w,1:h);

%% Compute alpha
n = size(psrc,1);
distance_psrc = squareform(pdist(psrc));
sort_distance_psrc = sort(distance_psrc);
min_distance_psrc = repmat(sort_distance_psrc(2,:),n,1);
coef_alpha = sqrt(distance_psrc.^2 + min_distance_psrc.^2);
alpha = coef_alpha \ (pdst - psrc);

%% Compute warpped image(IDW)
for i=1:h
    for j=1:w
        rep_p = repmat([i j],n,1);
        distance_psrc_p_square = sum((psrc - rep_p).^2,2);
        radial_basis = sqrt(distance_psrc_p_square' + sort_distance_psrc(2,:).^2);
        new_p = radial_basis * alpha + [i j];
        new_p_x = round(new_p(1));
        new_p_y = round(new_p(2));

        if  new_p_x > h
             new_p_x = h;
        end
        if new_p_x < 1
            new_p_x = 1;
        end
        if new_p_y > w
            new_p_y = w;
        end
        if new_p_y < 1
            new_p_y = 1;
        end
        X(i,j) = new_p_x;
        Y(i,j) = new_p_y;
    end
end

subplot(122)
axis off
Z = zeros(h,w);
S = surface(X,Y,Z,'CData',im2,'FaceColor','texturemap','EdgeColor','none');
direction = [0 0 1];
rotate(S,direction,-90);

im2 = im*0;
