`timescale 1ns / 1ps



module data(
	input wire sys_clk,
	input wire sys_rst_n,
	input wire [9:0]Byte,
	
	output wire [7:0]Data

    );
	
	
	wire [7:0]SPI_data[0:255];
	
	assign SPI_data[0] = 8'h11;
	assign SPI_data[1] = 8'h22;
	assign SPI_data[2] = 8'h33;
	assign SPI_data[3] = 8'h44;
	assign SPI_data[4] = 8'h55;
	assign SPI_data[5] = 8'h66;
	assign SPI_data[6] = 8'h77;
	assign SPI_data[7] = 8'h88;
	assign SPI_data[8] = 8'h99;
	assign SPI_data[9] = 8'h55;
	
	assign SPI_data[10] = 8'h11;
	assign SPI_data[11] = 8'h22;
	assign SPI_data[12] = 8'h33;
	assign SPI_data[13] = 8'h44;
	assign SPI_data[14] = 8'h55;
	assign SPI_data[15] = 8'h66;
	assign SPI_data[16] = 8'h77;
	assign SPI_data[17] = 8'h88;
	assign SPI_data[18] = 8'h99;
	assign SPI_data[19] = 8'h55;
							
	assign SPI_data[20] = 8'h11;
	assign SPI_data[21] = 8'h22;
	assign SPI_data[22] = 8'h33;
	assign SPI_data[23] = 8'h44;
	assign SPI_data[24] = 8'h55;
	assign SPI_data[25] = 8'h66;
	assign SPI_data[26] = 8'h77;
	assign SPI_data[27] = 8'h88;
	assign SPI_data[28] = 8'h99;
	assign SPI_data[29] = 8'h55;
							
	assign SPI_data[30] = 8'h11;
	assign SPI_data[31] = 8'h22;
	assign SPI_data[32] = 8'h33;
	assign SPI_data[33] = 8'h44;
	assign SPI_data[34] = 8'h55;
	assign SPI_data[35] = 8'h66;
	assign SPI_data[36] = 8'h77;
	assign SPI_data[37] = 8'h88;
	assign SPI_data[38] = 8'h99;
	assign SPI_data[39] = 8'h55;
							
	assign SPI_data[40] = 8'h11;
	assign SPI_data[41] = 8'h22;
	assign SPI_data[42] = 8'h33;
	assign SPI_data[43] = 8'h44;
	assign SPI_data[44] = 8'h55;
	assign SPI_data[45] = 8'h66;
	assign SPI_data[46] = 8'h77;
	assign SPI_data[47] = 8'h88;
	assign SPI_data[48] = 8'h99;
	assign SPI_data[49] = 8'h55;
							
	assign SPI_data[50] = 8'h11;
	assign SPI_data[51] = 8'h22;
	assign SPI_data[52] = 8'h33;
	assign SPI_data[53] = 8'h44;
	assign SPI_data[54] = 8'h55;
	assign SPI_data[55] = 8'h66;
	assign SPI_data[56] = 8'h77;
	assign SPI_data[57] = 8'h88;
	assign SPI_data[58] = 8'h99;
	assign SPI_data[59] = 8'h55;
							
	assign SPI_data[60] = 8'h11;
	assign SPI_data[61] = 8'h22;
	assign SPI_data[62] = 8'h33;
	assign SPI_data[63] = 8'h44;
	assign SPI_data[64] = 8'h55;
	assign SPI_data[65] = 8'h66;
	assign SPI_data[66] = 8'h77;
	assign SPI_data[67] = 8'h88;
	assign SPI_data[68] = 8'h99;
	assign SPI_data[69] = 8'h55;
							
	assign SPI_data[70] = 8'h11;
	assign SPI_data[71] = 8'h22;
	assign SPI_data[72] = 8'h33;
	assign SPI_data[73] = 8'h44;
	assign SPI_data[74] = 8'h55;
	assign SPI_data[75] = 8'h66;
	assign SPI_data[76] = 8'h77;
	assign SPI_data[77] = 8'h88;
	assign SPI_data[78] = 8'h99;
	assign SPI_data[79] = 8'h55;
							
	assign SPI_data[80] = 8'h11;
	assign SPI_data[81] = 8'h22;
	assign SPI_data[82] = 8'h33;
	assign SPI_data[83] = 8'h44;
	assign SPI_data[84] = 8'h55;
	assign SPI_data[85] = 8'h66;
	assign SPI_data[86] = 8'h77;
	assign SPI_data[87] = 8'h88;
	assign SPI_data[88] = 8'h99;
	assign SPI_data[89] = 8'h55;
							
	assign SPI_data[90] = 8'h11;
	assign SPI_data[91] = 8'h22;
	assign SPI_data[92] = 8'h33;
	assign SPI_data[93] = 8'h44;
	assign SPI_data[94] = 8'h55;
	assign SPI_data[95] = 8'h66;
	assign SPI_data[96] = 8'h77;
	assign SPI_data[97] = 8'h88;
	assign SPI_data[98] = 8'h99;
	assign SPI_data[99] = 8'h55;
	
	assign SPI_data[100] = 8'h11;
	assign SPI_data[101] = 8'h22;
	assign SPI_data[102] = 8'h33;
	assign SPI_data[103] = 8'h44;
	assign SPI_data[104] = 8'h55;
	assign SPI_data[105] = 8'h66;
	assign SPI_data[106] = 8'h77;
	assign SPI_data[107] = 8'h88;
	assign SPI_data[108] = 8'h99;
	assign SPI_data[109] = 8'h55;
							 
	assign SPI_data[110] = 8'h11;
	assign SPI_data[111] = 8'h22;
	assign SPI_data[112] = 8'h33;
	assign SPI_data[113] = 8'h44;
	assign SPI_data[114] = 8'h55;
	assign SPI_data[115] = 8'h66;
	assign SPI_data[116] = 8'h77;
	assign SPI_data[117] = 8'h88;
	assign SPI_data[118] = 8'h99;
	assign SPI_data[119] = 8'h55;
							 
	assign SPI_data[120] = 8'h11;
	assign SPI_data[121] = 8'h22;
	assign SPI_data[122] = 8'h33;
	assign SPI_data[123] = 8'h44;
	assign SPI_data[124] = 8'h55;
	assign SPI_data[125] = 8'h66;
	assign SPI_data[126] = 8'h77;
	assign SPI_data[127] = 8'h88;
	assign SPI_data[128] = 8'h99;
	assign SPI_data[129] = 8'h55;
							 
	assign SPI_data[130] = 8'h11;
	assign SPI_data[131] = 8'h22;
	assign SPI_data[132] = 8'h33;
	assign SPI_data[133] = 8'h44;
	assign SPI_data[134] = 8'h55;
	assign SPI_data[135] = 8'h66;
	assign SPI_data[136] = 8'h77;
	assign SPI_data[137] = 8'h88;
	assign SPI_data[138] = 8'h99;
	assign SPI_data[139] = 8'h55;
							 
	assign SPI_data[140] = 8'h11;
	assign SPI_data[141] = 8'h22;
	assign SPI_data[142] = 8'h33;
	assign SPI_data[143] = 8'h44;
	assign SPI_data[144] = 8'h55;
	assign SPI_data[145] = 8'h66;
	assign SPI_data[146] = 8'h77;
	assign SPI_data[147] = 8'h88;
	assign SPI_data[148] = 8'h99;
	assign SPI_data[149] = 8'h55;
							 
	assign SPI_data[150] = 8'h11;
	assign SPI_data[151] = 8'h22;
	assign SPI_data[152] = 8'h33;
	assign SPI_data[153] = 8'h44;
	assign SPI_data[154] = 8'h55;
	assign SPI_data[155] = 8'h66;
	assign SPI_data[156] = 8'h77;
	assign SPI_data[157] = 8'h88;
	assign SPI_data[158] = 8'h99;
	assign SPI_data[159] = 8'h55;
							 
	assign SPI_data[160] = 8'h11;
	assign SPI_data[161] = 8'h22;
	assign SPI_data[162] = 8'h33;
	assign SPI_data[163] = 8'h44;
	assign SPI_data[164] = 8'h55;
	assign SPI_data[165] = 8'h66;
	assign SPI_data[166] = 8'h77;
	assign SPI_data[167] = 8'h88;
	assign SPI_data[168] = 8'h99;
	assign SPI_data[169] = 8'h55;
							 
	assign SPI_data[170] = 8'h11;
	assign SPI_data[171] = 8'h22;
	assign SPI_data[172] = 8'h33;
	assign SPI_data[173] = 8'h44;
	assign SPI_data[174] = 8'h55;
	assign SPI_data[175] = 8'h66;
	assign SPI_data[176] = 8'h77;
	assign SPI_data[177] = 8'h88;
	assign SPI_data[178] = 8'h99;
	assign SPI_data[179] = 8'h55;
							 
	assign SPI_data[180] = 8'h11;
	assign SPI_data[181] = 8'h22;
	assign SPI_data[182] = 8'h33;
	assign SPI_data[183] = 8'h44;
	assign SPI_data[184] = 8'h55;
	assign SPI_data[185] = 8'h66;
	assign SPI_data[186] = 8'h77;
	assign SPI_data[187] = 8'h88;
	assign SPI_data[188] = 8'h99;
	assign SPI_data[189] = 8'h55;
							 
	assign SPI_data[190] = 8'h11;
	assign SPI_data[191] = 8'h22;
	assign SPI_data[192] = 8'h33;
	assign SPI_data[193] = 8'h44;
	assign SPI_data[194] = 8'h55;
	assign SPI_data[195] = 8'h66;
	assign SPI_data[196] = 8'h77;
	assign SPI_data[197] = 8'h88;
	assign SPI_data[198] = 8'h99;
	assign SPI_data[199] = 8'h55;
							 
	assign SPI_data[200] = 8'h11;
	assign SPI_data[201] = 8'h22;
	assign SPI_data[202] = 8'h33;
	assign SPI_data[203] = 8'h44;
	assign SPI_data[204] = 8'h55;
	assign SPI_data[205] = 8'h66;
	assign SPI_data[206] = 8'h77;
	assign SPI_data[207] = 8'h88;
	assign SPI_data[208] = 8'h99;
	assign SPI_data[209] = 8'h55;
							 
	assign SPI_data[210] = 8'h11;
	assign SPI_data[211] = 8'h22;
	assign SPI_data[212] = 8'h33;
	assign SPI_data[213] = 8'h44;
	assign SPI_data[214] = 8'h55;
	assign SPI_data[215] = 8'h66;
	assign SPI_data[216] = 8'h77;
	assign SPI_data[217] = 8'h88;
	assign SPI_data[218] = 8'h99;
	assign SPI_data[219] = 8'h55;
							 
	assign SPI_data[220] = 8'h11;
	assign SPI_data[221] = 8'h22;
	assign SPI_data[222] = 8'h33;
	assign SPI_data[223] = 8'h44;
	assign SPI_data[224] = 8'h55;
	assign SPI_data[225] = 8'h66;
	assign SPI_data[226] = 8'h77;
	assign SPI_data[227] = 8'h88;
	assign SPI_data[228] = 8'h99;
	assign SPI_data[229] = 8'h55;
							 
	assign SPI_data[230] = 8'h11;
	assign SPI_data[231] = 8'h22;
	assign SPI_data[232] = 8'h33;
	assign SPI_data[233] = 8'h44;
	assign SPI_data[234] = 8'h55;
	assign SPI_data[235] = 8'h66;
	assign SPI_data[236] = 8'h77;
	assign SPI_data[237] = 8'h88;
	assign SPI_data[238] = 8'h99;
	assign SPI_data[239] = 8'h55;
							 
	assign SPI_data[240] = 8'h11;
	assign SPI_data[241] = 8'h22;
	assign SPI_data[242] = 8'h33;
	assign SPI_data[243] = 8'h44;
	assign SPI_data[244] = 8'h55;
	assign SPI_data[245] = 8'h66;
	assign SPI_data[246] = 8'h77;
	assign SPI_data[247] = 8'h88;
	assign SPI_data[248] = 8'h99;
	assign SPI_data[249] = 8'h55;
							 
	assign SPI_data[250] = 8'h11;
	assign SPI_data[251] = 8'h22;
	assign SPI_data[252] = 8'h33;
	assign SPI_data[253] = 8'h44;
	assign SPI_data[254] = 8'h55;
	assign SPI_data[255] = 8'h66;

	
	
	assign Data = SPI_data[Byte];
	
	
	
endmodule
