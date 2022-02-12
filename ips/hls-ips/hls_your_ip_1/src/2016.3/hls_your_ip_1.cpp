//###################################################################################
// AUTHOR: FARNAM KHALILI MAYBODI
// DATE: 2022/01/02
// DESCRIPTION:
// This is an HLS based AXIS arbiter, which is used as a template HLS project
// to this repo. The types "uaxis64_v16_t" are defined in the hls_header.h
// and are adapted to the vivado hls 2016.3.


#include "hls_header.h"


void your_ip_1 (
							  stream<uaxis64_v16_t> *input1,
							  stream<uaxis64_v16_t> *input2,
							  stream<uaxis64_v16_t> &output
							  )
{
#pragma HLS PIPELINE II=1
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE axis off port=output
#pragma HLS INTERFACE axis register both port=input2
#pragma HLS INTERFACE axis register both port=input1

	static uaxis64_v16_t Packet1, Packet2;
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
