library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fpmul is
    generic (
        N: integer := 32;
        E: integer := 8
    );
    port (
        clk: in std_logic;
        a, b: in std_logic_vector(N - 1 downto 0);
        p: out std_logic_vector(N - 1 downto 0)
    );
end;

architecture fpmul_arq of fpmul is
    constant NP: integer := N - E - 1;

    constant BIAS: integer := 2 ** (E - 1) - 1;

    constant E_MAX: integer := BIAS;
    constant E_MIN: integer := -BIAS + 1;
begin
    -- sign                    fraction/significand/mantissa (NP bits)
    --  |                      /                                     \
    --  |  exponent (E bits)  /                                       \
    --  |   /           \    /                                         \
    --  0  1 0 0 0 0 0 0 0  1 0 0 1 0 0 1 0 0 0 0 1 1 1 1 1 1 0 1 1 0 1 1
    --
    -- N-1 N-2  ......  NP  NP-1                                        0

    process (clk) is
        variable a_sign: std_logic;
        variable b_sign: std_logic;

        variable a_exp: unsigned(E - 1 downto 0);
        variable b_exp: unsigned(E - 1 downto 0);

        variable a_frac: unsigned(NP downto 0);
        variable b_frac: unsigned(NP downto 0);

        variable p_frac_prod: unsigned(2 * NP + 1 downto 0);
        variable p_frac_u: unsigned(NP - 1 downto 0);
        variable p_exp_i: integer;

        variable p_sign: std_logic;
        variable p_exp: std_logic_vector(E - 1 downto 0);
        variable p_frac: std_logic_vector(NP - 1 downto 0);
    begin
        if rising_edge(clk) then
            -- extract signs
            a_sign := a(N - 1);
            b_sign := b(N - 1);

            -- extract exponents
            a_exp := unsigned(a(N - 2 downto NP));
            b_exp := unsigned(b(N - 2 downto NP));

            -- extract mantissas, adding the implicit 1.
            a_frac := unsigned('1' & a(NP - 1 downto 0));
            b_frac := unsigned('1' & b(NP - 1 downto 0));

            -- p_frac_prod is (2NP + 1 downto 0) (must discard down to NP)
            p_frac_prod := a_frac * b_frac;

            -- p_exp is (E downto 0) (must discard one bit)
            p_exp_i := to_integer(a_exp) + to_integer(b_exp) - BIAS;
            if p_frac_prod(p_frac_prod'left) = '1' then
                p_exp_i := p_exp_i + 1;
                p_frac_u := p_frac_prod(2 * NP downto NP + 1);
            else
                p_frac_u := p_frac_prod(2 * NP - 1 downto NP);
            end if;

            if p_exp_i - BIAS > E_MAX then
                -- report "overflow!";
                p_sign := a_sign xor b_sign;
                p_exp := (0 => '0', others => '1');
                p_frac := (others => '1');
            elsif p_exp_i - BIAS < E_MIN then
                -- report "underflow!";
                p_sign := '0';
                p_exp := (others => '0');
                p_frac := (others => '0');
            else
                p_sign := a_sign xor b_sign;
                p_exp := std_logic_vector(to_unsigned(p_exp_i, E));
                p_frac := std_logic_vector(p_frac_u);
            end if;

            p(N - 1) <= p_sign;
            p(N - 2 downto NP) <= p_exp;
            p(NP - 1 downto 0) <= p_frac;

            -- report "a_sign = " & std_logic'image(a_sign);
            -- report "b_sign = " & std_logic'image(b_sign);
            -- report "p_sign = " & std_logic'image(p_sign);
            -- report "";
            -- report "a_exp = " & integer'image(to_integer(a_exp)) & " (" & integer'image(to_integer(unsigned(a_exp) - BIAS)) & ")";
            -- report "b_exp = " & integer'image(to_integer(b_exp)) & " (" & integer'image(to_integer(unsigned(b_exp) - BIAS)) & ")";
            -- report "p_exp_inter = " & integer'image(to_integer(unsigned(p_exp))) & " (" & integer'image(to_integer(unsigned(p_exp) - BIAS)) & ")";
            -- report "";
            -- report "a_frac = " & integer'image(to_integer(a_frac));
            -- report "b_frac = " & integer'image(to_integer(b_frac));
            -- report "p_frac = " & integer'image(to_integer(unsigned(p_frac)));
            -- report "";
        end if;
    end process;

end;
