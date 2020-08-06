library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- https://www.electricaltechnology.org/wp-content/uploads/2018/05/schematic-of-4x4-multiplier-using-4-bit-full-adders.png

entity mul is
    generic (
        N: integer := 4
    );
    port (
        a, b: in std_logic_vector(N - 1 downto 0);
        p: out std_logic_vector(2 * N - 1 downto 0)
    );
end;

architecture mul_arq of mul is
    type array1d is array (0 to N - 1) of std_logic;
    type array2d is array (0 to N - 1) of std_logic_vector(N - 1 downto 0);

    signal aa: array2d;
    signal ab: array2d;
    signal as: array2d;
    signal ac: array1d;

begin
    adders: for i in 1 to N-1 generate
        adder: entity work.addern
            generic map(N => N)
            port map(
                a => aa(i),
                b => ab(i),
                cin => '0',

                s => as(i),
                cout => ac(i)
            );

        aa(i) <= a and b(i);

        p(i) <= as(i)(0);
    end generate;

    adders_interconnect: for i in 1 to N-2 generate
        ab(i + 1) <= ac(i) & as(i)(N - 1 downto 1);
    end generate;

    ab(1) <= '0' & (a(N - 1 downto 1) and b(0));

    p(0) <= a(0) and b(0);
    p(2 * N - 1 downto N) <= ac(N - 1) & as(N - 1)(N - 1 downto 1);

    -- process is begin
    --     wait for 15 ns;
    --     if (p /= (std_logic_vector(unsigned(a) * unsigned(b)))) then
    --         report "a = 0b" & to_string(a);
    --         report "b = 0b" & to_string(b);
    --         report "p = 0b" & to_string(p);
    --         report "* = 0b" & to_string(unsigned(a) * unsigned(b));
    --         report "";
    --     end if;
    --     wait for 5 ns;
    -- end process;
end;
