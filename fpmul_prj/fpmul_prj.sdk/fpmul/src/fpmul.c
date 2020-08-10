#include "xparameters.h"
#include "xil_io.h"
#include "fpmul_ip.h"

int main (void) {
	u32 opA = 0xFF7802DD;
	u32 opB = 0x3E410611;
	u32 res = 0x00000000;// deberia ser 0xFE3B0009;

    xil_printf("-- fpmul IP -- Inicio --\r\n");

    FPMUL_IP_mWriteReg(XPAR_FPMUL_IP_S_AXI_BASEADDR, FPMUL_IP_S_AXI_SLV_REG0_OFFSET, opA);
    FPMUL_IP_mWriteReg(XPAR_FPMUL_IP_S_AXI_BASEADDR, FPMUL_IP_S_AXI_SLV_REG1_OFFSET, opB);
    res = FPMUL_IP_mReadReg(XPAR_FPMUL_IP_S_AXI_BASEADDR, FPMUL_IP_S_AXI_SLV_REG2_OFFSET);

    xil_printf("Cuenta: %x * %x = %x\r\n", opA, opB, res);
}
