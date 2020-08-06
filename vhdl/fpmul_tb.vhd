library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use IEEE.numeric_std.all;
use std.textio.all;

entity fpmul_tb is
end entity fpmul_tb;

architecture fpmul_tb_arq of fpmul_tb is
	constant TCK: time:= 20 ns; 		-- periodo de reloj
	constant DELAY: natural:= 0; 		-- retardo de procesamiento del DUT
	constant WORD_SIZE_T: natural:= 32;	-- tama�o de datos
	constant EXP_SIZE_T: natural:= 8;   -- tama�o exponente

	signal clk: std_logic:= '0';
	signal a_file: std_logic_vector(WORD_SIZE_T-1 downto 0):= (others => '0');
	signal b_file: std_logic_vector(WORD_SIZE_T-1 downto 0):= (others => '0');
	signal z_file: std_logic_vector(WORD_SIZE_T-1 downto 0):= (others => '0');
	signal z_del: std_logic_vector(WORD_SIZE_T-1 downto 0):= (others => '0');
	signal z_dut: std_logic_vector(WORD_SIZE_T-1 downto 0):= (others => '0');

	signal ciclos: natural := 0;
	signal errores: natural := 0;

	-- La senal z_del_aux se define por un problema de conversi�n
	signal z_del_aux: std_logic_vector(WORD_SIZE_T-1 downto 0):= (others => '0');

	file datos: text open read_mode is "/home/dessaya/cese/materias/clp/tp/fpmul-vhdl/test-files/test_mul_float_"&integer'image(WORD_SIZE_T)&"_"&integer'image(EXP_SIZE_T)&"_bin.txt";

	-- Declaracion de la linea de retardo
	component delay_gen is
		generic(
			N: natural:= 26;
			DELAY: natural:= 0
		);
		port(
			clk: in std_logic;
			A: in std_logic_vector(N-1 downto 0);
			B: out std_logic_vector(N-1 downto 0)
		);
	end component;
begin
	-- Generacion del clock del sistema
	clk <= not(clk) after TCK/ 2; -- reloj

	Test_Sequence: process
		variable l: line;
		variable ch: character:= ' ';
        variable i : integer := WORD_SIZE_T - 1;
	begin
		while not(endfile(datos)) loop 		-- si se quiere leer de stdin se pone "input"
			wait until rising_edge(clk);
			ciclos <= ciclos + 1;			-- solo para debugging
			readline(datos, l);
            i := WORD_SIZE_T - 1;
            while i >= 0 loop
                read(l, ch);
                next when ch /= '1' and ch /= '0';
                if ch = '1' then
                    a_file(i) <= '1';
                else
                    a_file(i) <= '0';
                end if;
                i := i - 1;
            end loop;
            i := WORD_SIZE_T - 1;
            while i >= 0 loop
                read(l, ch);
                next when ch /= '1' and ch /= '0';
                if ch = '1' then
                    b_file(i) <= '1';
                else
                    b_file(i) <= '0';
                end if;
                i := i - 1;
            end loop;
            i := WORD_SIZE_T - 1;
            while i >= 0 loop
                read(l, ch);
                next when ch /= '1' and ch /= '0';
                if ch = '1' then
                    z_file(i) <= '1';
                else
                    z_file(i) <= '0';
                end if;
                i := i - 1;
            end loop;
		end loop;

		file_close(datos);		-- se cierra del archivo
		wait for TCK*(DELAY+1);
		assert false report		-- se aborta la simulacion (fin del archivo)
			"Fin de la simulacion" severity failure;
	end process Test_Sequence;

	-- Instanciacion del DUT
	DUT: entity work.fpmul
			generic map(
				N => WORD_SIZE_T,
				E => EXP_SIZE_T
			)
			port map(
				a => std_logic_vector(a_file),
				b => std_logic_vector(b_file),
				p => z_dut
			);

	-- Instanciacion de la linea de retardo
	del: delay_gen
			generic map(WORD_SIZE_T, DELAY)
			port map(clk, std_logic_vector(z_file), z_del_aux);

	z_del <= z_del_aux;

	-- Verificacion de la condicion
	verificacion: process
	begin
        wait for TCK * 3/4;
        report "TEST: " & to_hstring(a_file) & " * " & to_hstring(b_file) & " = " & to_hstring(z_file);
        assert z_del = z_dut report
            "Error: Salida del DUT no coincide con referencia (esperado = " &
            integer'image(to_integer(unsigned(z_del))) &
            ", dut = " &
            integer'image(to_integer(unsigned(z_dut))) & ")"
            severity error;
        if z_del /= z_dut then
            errores <= errores + 1;
        end if;
        wait for TCK * 1/4;
	end process;

end architecture fpmul_tb_arq;
