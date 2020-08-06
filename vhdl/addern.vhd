library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity addern is
    generic (
        N: integer := 4
    );
    port (
        a, b: in std_logic_vector(N - 1 downto 0);
        cin: in std_logic;

        s: out std_logic_vector(N - 1 downto 0);
        cout: out std_logic
    );
end;

architecture addern_arq of addern is
    signal c: std_logic_vector(N downto 0);
begin
    adders: for i in 0 to N - 1 generate
        adder1: entity work.adder1
            port map(
                a => a(i),
                b => b(i),
                cin => c(i),

                s => s(i),
                cout => c(i + 1)
            );
    end generate;
    c(0) <= cin;
    cout <= c(N);

    -- process is begin
    --     wait for 15 ns;
    --     if (s /= (std_logic_vector(unsigned(a) + unsigned(b) + unsigned'('0'&cin)))) then
    --         report "a = 0b" & to_string(a);
    --         report "b = 0b" & to_string(b);
    --         report "c = 0b" & to_string(cin);
    --         report "s = 0b" & to_string(s);
    --         report "+ = 0b" & to_string(unsigned(a) + unsigned(b));
    --         report "";
    --     end if;
    --     wait for 5 ns;
    -- end process;
end;

