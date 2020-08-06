library IEEE;
use IEEE.std_logic_1164.all;

entity adder1 is
    port(
        a, b, cin: in std_logic;

        s, cout: out std_logic
    );
end;

architecture adder1_arq of adder1 is
begin
    s <= a xor b xor cin;
    cout <= (a and b) or (a and cin) or (b and cin);
end;


