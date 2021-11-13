function [ cuttedMask ] = cutMask( mask, L )
%CUTMASK Cut given mask and retain the non-zero connect segments.
% The initial mask is convolved with an L-window to enlarge the segments.

cuttedMask = {};
cellIdx = 1;

if L > 0
    mask = conv(double(mask), ones(L,1), 'same');
end

prev_zero = 1;
for idx=1:length(mask)
    if mask(idx) ~= 0
        if prev_zero
            tmpSegment = idx;
            prev_zero = 0;
        else
            tmpSegment = [tmpSegment; idx];
        end
    else
        if ~prev_zero
            cuttedMask{cellIdx} = tmpSegment;
            cellIdx = cellIdx + 1;
            prev_zero = 1;
        end
    end
end

end

