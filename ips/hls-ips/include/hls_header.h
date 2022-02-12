//###################################################################
//AUTHOR: FARNAM KHALILI MAYBODI
//DATE: 2022/12/18
//DESCRIPTION:
// Header file of all HLS based IPs.
//###################################################################
#include <ap_int.h>
#include <hls_stream.h>
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <ap_axi_sdata.h>

using namespace hls;

typedef ap_uint<1> uint1;
typedef ap_uint<2> uint2;
typedef ap_uint<4> uint4;
typedef ap_uint<3> uint3;
typedef ap_uint<8> uint8;
typedef ap_uint<9> uint9;
typedef ap_uint<11> uint11;
typedef ap_uint<12> uint12;
typedef ap_uint<13> uint13;
typedef ap_uint<16> uint16;
typedef ap_uint<18> uint18;
typedef ap_uint<22> uint22;
typedef ap_uint<23> uint23;
typedef ap_uint<24> uint24;
typedef ap_uint<32> uint32;
typedef ap_uint<64> uint64;
typedef ap_uint<104> uint104;
typedef ap_uint<112> uint112;
typedef ap_uint<128> uint128;

typedef ap_axis<128, 0, 0, 0> uaxis128_t;
typedef ap_axis<64, 0, 0, 0> uaxis64_t;
typedef ap_axis<32, 0, 0, 0> uaxis32_t;
typedef ap_axis<16, 0, 0, 0> uaxis16_t;
typedef ap_axis<8, 0, 0, 0> uaxis8_t;


struct uaxis8_v16_t {
	ap_uint<8> data;
	ap_uint<1> keep;
	ap_uint<1> strb;
	ap_uint<1> last;
};

struct uaxis16_v16_t {
	ap_uint<16> data;
	ap_uint<2> keep;
	ap_uint<2> strb;
	ap_uint<1> last;
};

struct uaxis32_v16_t {
	ap_uint<32> data;
	ap_uint<4> keep;
	ap_uint<4> strb;
	ap_uint<1> last;
};

struct uaxis64_v16_t {
	ap_uint<64> data;
	ap_uint<8> keep;
	ap_uint<8> strb;
	ap_uint<1> last;
};

struct uaxis128_v16_t {
	ap_uint<128> data;
	ap_uint<16> keep;
	ap_uint<16> strb;
	ap_uint<1> last;
};


//###################################################################