Para ejecutar las simulaciones (Requiere GHDL y GTKWave):

* Componente `adder1`: `make -f Makefile.adder1`
* Componente `addern`: `make -f Makefile.addern`
* Componente `mul`: `make -f Makefile.mul`
* Componente `fpmul`: `make`

Para correr los tests: `make test` (configurar `WORD_SIZE_T` y `EXP_SIZE_T`
en `fpmul_tb.vhd`) para utilizar el archivo correspondiente en la carpeta `test-files`.

Presentación: https://docs.google.com/presentation/d/1Kuh-zIYmyQBW3Cxa-VgkS_nisQxdfyCZypiP9ngEYx0/edit?usp=sharing
