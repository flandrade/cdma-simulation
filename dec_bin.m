function bin_state = dec_bin( int_state, m )

    % cambia matriz de decimal a binario

    for j = 1:length( int_state )
       for i = m:-1:1
           state(j,m-i+1) = fix( int_state(j)/ (2^(i-1)) );
           int_state(j) = int_state(j) - state(j,m-i+1)*2^(i-1);
       end
    end

    bin_state = state;

end
