function [ start, stop ] = spike2window( spike, window )
%SPIKE2WINDOW Convert spike to spike window

start = spike - floor(window/2);
if mod(window,2) == 0
    stop = spike + window/2 - 1;
else
    stop = spike + floor(window/2);
end

end

