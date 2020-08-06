library IEEE;
use IEEE.std_logic_1164.all;

entity adder1_tb is
end adder1_tb;

architecture adder1_tb_arq of adder1_tb is

    signal a_tb: std_logic := '0';
    signal b_tb: std_logic := '0';
    signal cin_tb: std_logic := '0';
    signal s_tb: std_logic;
    signal cout_tb: std_logic;

begin
    DUT: entity work.adder1

    port map (
        a => a_tb,
        b => b_tb,
        cin => cin_tb,

        s => s_tb,
        cout => cout_tb
    );

    a_tb <= not a_tb after 10 ns;
    b_tb <= not b_tb after 20 ns;
    cin_tb <= not cin_tb after 40 ns;

end;
