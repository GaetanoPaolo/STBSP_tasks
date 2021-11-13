function [ sens, prec ] = validateDetections( detectionCell, labelCell )
%VALIDATEDETECTIONS Return sensitivity and precision for the given
% detection segments cell and label segments cell. 

% initialise overlap matrix
overlapMatrix = zeros(length(detectionCell),length(labelCell));

% fill overlap matrix
work = length(detectionCell) * length(labelCell);
f = waitbar(0, 'Comparing detections with labels');
for idx=1:length(detectionCell)
    for jdx=1:length(labelCell)
        detection = detectionCell{idx};
        label = labelCell{jdx};
        
        intersection = intersect(detection, label);
        overlapMatrix(idx,jdx) = length(intersection);
    end
    waitbar((idx*jdx)/work, f);
end

close(f);

TP = 0;
for jdx=1:length(labelCell)
    if any(overlapMatrix(:,jdx))
        TP = TP + 1;
    end
end

sens = TP / length(labelCell);
prec = TP / length(detectionCell);

end

