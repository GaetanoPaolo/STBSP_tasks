function sign_eig(Lambda)
eig_val = diag(Lambda);
% [max_val,max_pos] = max(eig_val);
% cur_max = max_val;
% eig_val(max_pos) = 0;
% count = 0;
% while cur_max >= 0.1*max_val
%     [cur_max,cur_pos] = max(eig_val);
%     eig_val(cur_pos) = 0;
%     count = count +1 ;
% end
%disp(eig_val)
count = 2;
cur_val = eig_val(1);
max_val = eig_val(1);
while cur_val >= 0.1*max_val
    count = count +1;
    cur_val = eig_val(count);
end
disp('Eigenvalues large enough')
disp(count)
end