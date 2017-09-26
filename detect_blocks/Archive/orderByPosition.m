function C_out = orderByPosition(C_in)
    C_out = C_in;

    [sortedX, sortedX_idx] = sort(C_out(:,1));
    C_out(1:size(sortedX_idx,1),:) = C_in(sortedX_idx(:),:); 
end
