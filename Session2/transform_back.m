function [result] = transform_back(A,s)

for i=1:size(A,2)
    result(:,i)=A(:,i).*s;
    figure;topoplot(result(:,i),'22system10_20deze.loc');
end
