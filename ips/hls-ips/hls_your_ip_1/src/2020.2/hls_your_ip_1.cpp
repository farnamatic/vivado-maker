// #############################################################################
// AUTHOR: FARNAM KHALILI MAYBODI
// DATE: 2022/01/25
// DESCRIPTION:
// This is a template HLS project used for the vitis_hls 2020.2. The type of 
// uaxis64_t is an AXI stream type suitable for the Vitis 2020.2.

#include "hls_header.h"


void your_ip_1 (
							  stream<uaxis64_t> *input1,
							  stream<uaxis64_t> *input2,
							  stream<uaxis64_t> &output
							  )
{
#pragma HLS PIPELINE II=1
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE axis off port=output
#pragma HLS INTERFACE axis register both port=input2
#pragma HLS INTERFACE axis register both port=input1

	static uaxis64_t Packet1, Packet2;
	static uint1 pro1_lock=0, pro2_lock=0;

	if (input1->read_nb(Packet1) && pro1_lock == 0) {

		output.write(Packet1);
		pro1_lock = 1;

	} else if ( input2->read_nb(Packet2) && pro2_lock == 0) {

		output.write(Packet2);
		pro2_lock = 1;

	} else {

		pro1_lock = 0;
		pro2_lock = 0;

	}

}
