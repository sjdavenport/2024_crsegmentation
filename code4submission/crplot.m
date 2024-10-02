function crplot( inner_set, outer_set, middle_set, color_scheme, background)

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'background', 'var' )
   % Default value
   background = zeros([size(inner_set), 3]);
end

%%  Main Function Loop
%--------------------------------------------------------------------------
imagesc(background); hold on

if ~exist('color_scheme', 'var')
    add_region({outer_set, middle_set, inner_set}, {'blue','yellow', 'red'})
else
    add_region({outer_set, middle_set, inner_set}, {[0, 0.4470, 0.7410],'yellow', [1,0.2,0.2]})
end

end

