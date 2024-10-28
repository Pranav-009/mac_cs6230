package mac;

//full adder
function Bit#(2) fa_op_1bit(Bit#(1) a, Bit#(1) b, Bit#(1) c);
	Bit#(1) temp = a^b;
	Bit#(1) sum = temp^c;
	Bit#(1) carry_out = (a & b)|(c & temp);
	return {carry_out, sum};
endfunction

//8 bit ripple carry adder
function Bit#(9) add_op_8(Bit#(8) a, Bit#(8) b, Bit#(1) c_in);
	Bit#(8) sum = 0;
	Bit#(9) carry = 0;
	carry[0] = c_in;
	for (Integer i = 0; i<8; i=i+1)
		begin
			Bit#(2) fa_res = fa_op_1bit(a[i], b[i], carry[i]);
			sum[i] = fa_res[0];
			carry[i+1] = fa_res[1];
		end
	return {carry[8], sum};
endfunction

//8-bit multiplier (multiplication by repeated addition)
function Bit#(16) mul8(Bit#(8) multiplicand, Bit#(8) multiplier);
	Bit#(8) temp_lower = 0;
	Bit#(8) temp_upper = 0;
	for (Integer i = 0; i<8; i=i+1)
		begin
			Bit#(8) to_add = (multiplier[i] == 0) ? 0 : multiplicand;
			Bit#(9) part_sum = add_op_8(temp_upper, to_add, 0);
			temp_lower[i] = part_sum[0];
			temp_upper = part_sum[8:1];
		end
	return {temp_upper, temp_lower};
endfunction


//32-bit ripple carry adder
function Bit#(33) add_op_32(Bit#(32) a, Bit#(32) b, Bit#(1) c_in);
	Bit#(32) sum = 0;
	Bit#(33) carry = 0;
	carry[0] = c_in;
	for (Integer i = 0; i<32; i=i+1)
		begin
			Bit#(2) fa_res = fa_op_1bit(a[i], b[i], carry[i]);
			sum[i] = fa_res[0];
			carry[i+1] = fa_res[1];
		end
	return {carry[32], sum};
endfunction

//mac (performs a*b + c, a and b are 8-bits and c is 32-bit)
function Bit#(33) mac(Bit#(8) a, Bit#(8) b, Bit#(32) c);
	Bit#(32) inter = signExtend(mul8(a,b));
	Bit#(33) res = add_op_32(inter,c,0);
	return res;
endfunction

(*synthesize*)
module mac_wrap(Ifc_mac_wrap);
	method Bit#(33) getResult(Bit#(8) a, Bit#(8) b, Bit#(32) c) = mac(a,b,c);
endmodule

interface Ifc_mac_wrap;
	method Bit#(33) getResult(Bit#(8) a, Bit#(8) b, Bit#(32) c);
endinterface

(*synthesize*)
module mkTb_mac_wrap();
	Ifc_mac_wrap ifc_mac <-mac_wrap;
	rule answer;
		$display("The answer is: %0d", ifc_mac.getResult(215,87,15000));
		$finish(0);
	endrule	
endmodule

endpackage
