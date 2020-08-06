library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mul_tb is
end mul_tb;

architecture mul_tb_arq of mul_tb is

    constant N: integer := 8;

    signal a_tb: std_logic_vector(N - 1 downto 0) := (others => '0');
    signal b_tb: std_logic_vector(N - 1 downto 0) := (others => '0');
    signal p_tb: std_logic_vector(2 * N - 1 downto 0);

begin
    DUT: entity work.mul
        generic map (N => N)
        port map (
            a => a_tb,
            b => b_tb,
            p => p_tb
        );

    process begin
        a_tb <= std_logic_vector(to_unsigned(0, N));
        b_tb <= std_logic_vector(to_unsigned(0, N));
        wait for 20 ns;

        a_tb <= std_logic_vector(to_unsigned(92, N));
        b_tb <= std_logic_vector(to_unsigned(2, N));
        wait for 20 ns;

        a_tb <= std_logic_vector(to_unsigned(6, N));
        b_tb <= std_logic_vector(to_unsigned(32, N));
        wait for 20 ns;
    end process;
end;
