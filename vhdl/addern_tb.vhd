library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity addern_tb is
end addern_tb;

architecture addern_tb_arq of addern_tb is

    constant N: integer := 8;

    signal a_tb: std_logic_vector(N - 1 downto 0) := (others => '0');
    signal b_tb: std_logic_vector(N - 1 downto 0) := (others => '0');
    signal cin_tb: std_logic := '0';
    signal s_tb: std_logic_vector(N - 1 downto 0);
    signal cout_tb: std_logic;

begin
    DUT: entity work.addern
        generic map (N => N)
        port map (
            a => a_tb,
            b => b_tb,
            cin => cin_tb,

            s => s_tb,
            cout => cout_tb
        );

    process begin
        a_tb <= std_logic_vector(to_unsigned(0, N));
        b_tb <= std_logic_vector(to_unsigned(0, N));
        cin_tb <= '0';
        wait for 20 ns;

        a_tb <= std_logic_vector(to_unsigned(12, N));
        b_tb <= std_logic_vector(to_unsigned(45, N));
        cin_tb <= '0';
        wait for 20 ns;

        a_tb <= std_logic_vector(to_unsigned(90, N));
        b_tb <= std_logic_vector(to_unsigned(1, N));
        cin_tb <= '0';
        wait for 20 ns;
    end process;
end;
