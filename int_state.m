function int_state = int_state( state )
% Copyright 1996 Matthew C. Valenti
% MPRG lab, Virginia Tech.
% for academic use only

% converts a row vector of m bits into a integer (base 10)

[dummy, m] = size( state );

for i = 1:m
   vect(i) = 2^(m-i);
end

int_state = state*vect';
