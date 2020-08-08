#include "xparameters.h"
#include "xil_io.h"
#include "fpmul_ip.h"


//====================================================

int main (void) {

	float res;
	float opA = 1256.0;
	float opB = 800.0;

    xil_printf("-- fpmul IP -- Inicio --\r\n");

    FPMUL_IP_mWriteReg(XPAR_FPMUL_IP_S_AXI_BASEADDR, FPMUL_IP_S_AXI_SLV_REG0_OFFSET, opA);
    FPMUL_IP_mWriteReg(XPAR_FPMUL_IP_S_AXI_BASEADDR, FPMUL_IP_S_AXI_SLV_REG1_OFFSET, opB);
    res = FPMUL_IP_mReadReg(XPAR_FPMUL_IP_S_AXI_BASEADDR, FPMUL_IP_S_AXI_SLV_REG2_OFFSET);

    xil_printf("Cuenta: %f + %f = %f\r\n", opA, opB, res);

}
