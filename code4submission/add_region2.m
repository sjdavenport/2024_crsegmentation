function add_region( region_masks, colors2use, transparent )
% add_region( region_masks, colors2use, transparent )
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%   - region_masks: Cell array of region masks.
%   - colors2use: Cell array of colors to use for each region mask.
% Optional
%   - transparent: Flag indicating whether to use transparency (default: 1).
%--------------------------------------------------------------------------
% OUTPUT
%  None, the function plots an image.
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist('transparent', 'var')
    transparent = 1;
end

if ~exist('region_masks', 'var')
    useregionmasks = 0;
    region_masks = {NaN};
else
    useregionmasks = 1;
end

if ~iscell(region_masks)
    region_masks = {region_masks};
end

if ~exist('colors2use', 'var')
    colors2use = repmat({'white'}, 1, length(region_masks));
end

if ~iscell(colors2use)
    colors2use =  repmat({colors2use}, 1, length(region_masks));
end

if length(colors2use) == 1
    colors2use =  repmat(colors2use, 1, length(region_masks));
end

if length(colors2use) ~= length(region_masks)
    error('The number of colors used must be the same as the number of regions');
end

%%  Main Function Loop
%--------------------------------------------------------------------------
hold on
for I = 1:length(region_masks)
    colored_region_mask = colorRegion2(region_masks{I}, colors2use{I});
    im2 = imagesc(colored_region_mask);
    set(im2,'AlphaData',transparent*region_masks{I});
end

end

