module SPI_control(

input wire sys_clk,
input wire sys_rst_n,
input wire MISO,
input wire uart_rxpin,


output reg CS_n,
output wire SPI_CLK,
output reg MOSI

);




wire clk_10MHz;




localparam Wirte_Enable = 8'h06;//写使能
localparam Page_Program = 8'h02;//页写，执行该指令之前必须执行Wirte_Enable，如果要对整页进行变成最后一个字节应该写0，后跟三字节地址24'hxxxxxx
localparam Read_Data = 8'h03;//读数据,三字节地址
localparam Sector_Erase = 8'h20;//扇区擦除，执行该指令之前必须执行Wirte_Enable，三字节地址
localparam Chip_Erase = 8'h60;//或8'hC7,芯片擦除，执行该指令之前必须执行Wirte_Enable
//localparam Read_Manufacturer_Device_ID = 8'h90;//读取设备ID
//localparam Read_Unique_ID_Number = 8'h4B;//读取出场设置的唯一设备ID，64位，输入指令后等待4个字节的长度输出64位唯一ID




reg [11:0]state;
reg [11:0]state_next;


wire uart_done;
reg uart_done1;
reg uart_done2;
reg uart_done3;
reg uart_done4;
reg done;



wire [7:0]uart_rxdata;

reg [3:0]Wirte_Enable_cnt;
reg [3:0]Sector_Erase_cnt;
reg [4:0]Sector_Erase_addr_cnt;//扇区擦除地址计数器
reg [23:0]Sector_Erase_Time_cnt;//扇区擦除所需时间计数器
reg [3:0]Page_Program_instruct_cnt;
reg [4:0]Page_Program_ADDR_cnt;
reg [11:0]write_data_cnt;
reg [15:0]write_data_Time_cnt;//页写数据所需时间计数器
reg [4:0]Sector_cnt;//扇区计数器，写满一个扇区停止
reg [3:0]Read_Data_instruct_cnt;
reg [4:0]Read_Data_ADDR_cnt;
reg [15:0]read_data_cnt;//读取数据计数器
reg [3:0]Chip_Erase_cnt;
reg [23:0]read_ADDR;
reg [4:0]Page_cnt;

reg [23:0]Erase_addr;//扇区擦除地址
reg [23:0]Page_ADDR;//写数据地址
wire [7:0]wr_data;//要写入一页的数据
reg [3:0]wr_data_cnt;
reg [9:0]Byte;
reg flag;




localparam Sector_Erase_Time_MAX = 24'd4_000_000;
localparam write_data_Time_cnt_MAX = 16'd30000;

localparam 	IDLE 					= 12'b0000_0000_0000,
			Wirte_Enable_state 		= 12'b0000_0000_0001,
			Sector_Erase_state 		= 12'b0000_0000_0010,
			Sector_Erase_addr 		= 12'b0000_0000_0100,
			Sector_Erase_Time 		= 12'b0000_0000_1000,
			Page_Program_instruct 	= 12'b0000_0001_0000,
			Page_Program_ADDR 		= 12'b0000_0010_0000,
			write_data 				= 12'b0000_0100_0000,
			write_data_Time 		= 12'b0000_1000_0000,
			Read_Data_instruct 		= 12'b0001_0000_0000,
			Read_Data_ADDR 			= 12'b0010_0000_0000,
			Read_Page_data 			= 12'b0100_0000_0000,
			Chip_Erase_state 		= 12'b1000_0000_0000;
				
				
				
always@(posedge sys_clk)begin
	if(!sys_rst_n)begin
		uart_done1 <= 1'b0;
		uart_done2 <= 1'b0;
		uart_done3 <= 1'b0;
		uart_done4 <= 1'b0;
	end
	else begin 
		uart_done1 <= uart_done;
		uart_done2 <= uart_done1;
		uart_done3 <= uart_done2;
		uart_done4 <= uart_done3;
	end
end


always@(posedge sys_clk)begin
	if(!sys_rst_n)
		done <= 1'b0;
	else if(uart_done || uart_done1 || uart_done2 || uart_done3 || uart_done4)
		done <= 1'b1;
	else
		done <= 1'b0;
end




always@(posedge clk_10MHz)begin
	if(!sys_rst_n)
		Wirte_Enable_cnt <= 4'd0;	
	else if(state == Wirte_Enable_state)
		Wirte_Enable_cnt <= Wirte_Enable_cnt + 'd1;
	else 
		Wirte_Enable_cnt <= 4'd0;
end


always@(posedge clk_10MHz)begin
	if(!sys_rst_n)
		Sector_Erase_cnt <= 4'd0;
	else if(state == Sector_Erase_state)
		Sector_Erase_cnt <= Sector_Erase_cnt + 'd1;
	else 
		Sector_Erase_cnt <= 4'd0;
end


always@(posedge clk_10MHz)begin
	if(!sys_rst_n)
		Sector_Erase_addr_cnt <= 5'd0;
	else if(state == Sector_Erase_addr)
		Sector_Erase_addr_cnt <= Sector_Erase_addr_cnt + 'd1;
	else 
		Sector_Erase_addr_cnt <= 5'd0;
end


always@(posedge clk_10MHz)begin
	if(!sys_rst_n)
		Sector_Erase_Time_cnt <= 24'd0;
	else if((write_data_Time_cnt == write_data_Time_cnt_MAX && Page_cnt == 'd0) || done)
		Sector_Erase_Time_cnt <= 24'd0;
	else if(Sector_Erase_Time_cnt == Sector_Erase_Time_MAX)
		Sector_Erase_Time_cnt <= Sector_Erase_Time_cnt;
	else if(state == Sector_Erase_Time)
		Sector_Erase_Time_cnt <= Sector_Erase_Time_cnt + 'd1;
	else 
		Sector_Erase_Time_cnt <= Sector_Erase_Time_cnt;
end



always@(posedge clk_10MHz)begin
	if(!sys_rst_n)
		Page_Program_instruct_cnt <= 4'd0;
	else if(state == Page_Program_instruct)
		Page_Program_instruct_cnt <= Page_Program_instruct_cnt + 'd1;
	else 
		Page_Program_instruct_cnt <= 4'd0;
end


always@(posedge clk_10MHz)begin
	if(!sys_rst_n)
		Page_Program_ADDR_cnt <= 5'd0;
	else if(state == Page_Program_ADDR)
		Page_Program_ADDR_cnt <= Page_Program_ADDR_cnt + 'd1;
	else 
		Page_Program_ADDR_cnt <= 5'd0;
end


always@(posedge clk_10MHz)begin
	if(!sys_rst_n)
		write_data_cnt <= 12'd0;
	else if(state == write_data)
		write_data_cnt <= write_data_cnt + 'd1;
	else 
		write_data_cnt <= 12'd0;
end


always@(posedge clk_10MHz)begin
	if(!sys_rst_n)
		write_data_Time_cnt <= 16'd0;
	else if(state == write_data_Time)
		write_data_Time_cnt <= write_data_Time_cnt + 'd1;
	else 
		write_data_Time_cnt <= 16'd0;
end



always@(posedge clk_10MHz)begin
	if(!sys_rst_n)
		Sector_cnt <= 5'd0;
	else if(Sector_cnt == 5'd15 && flag == 1'b1 || done)
		Sector_cnt <= 5'd0;
	else if(flag == 1'b1)
		Sector_cnt <= Sector_cnt + 5'd1;
	else 
		Sector_cnt <= Sector_cnt;
end


always@(posedge clk_10MHz)begin
	if(!sys_rst_n)
		Read_Data_instruct_cnt <= 4'd0;
	else if(state == Read_Data_instruct)
		Read_Data_instruct_cnt <= Read_Data_instruct_cnt + 'd1;
	else 
		Read_Data_instruct_cnt <= 4'd0;
end


always@(posedge clk_10MHz)begin
	if(!sys_rst_n)
		Read_Data_ADDR_cnt <= 5'd0;
	else if(state == Read_Data_ADDR)
		Read_Data_ADDR_cnt <= Read_Data_ADDR_cnt + 'd1;
	else 
		Read_Data_ADDR_cnt <= 5'd0;
end


always@(posedge clk_10MHz)begin
	if(!sys_rst_n)
		read_data_cnt <= 16'd0;
	else if(state == Read_Page_data)
		read_data_cnt <= read_data_cnt + 'd1;
	else 
		read_data_cnt <= 16'd0;
end



always@(posedge clk_10MHz)begin
	if(!sys_rst_n)
		Erase_addr <= 24'h000000;
	else if((write_data_Time_cnt == write_data_Time_cnt_MAX && Page_cnt == 'd0 && Erase_addr == 24'h1FFF00) || state == Chip_Erase_state)
		Erase_addr <= 24'h000000;
	else if(write_data_Time_cnt == write_data_Time_cnt_MAX && Page_cnt == 'd0)
		Erase_addr <= Page_ADDR - 24'h001000;
	else if((Sector_Erase_Time_cnt == Sector_Erase_Time_MAX - 'd1) && Erase_addr == 24'h000000)
		Erase_addr <= 24'h000000;
	else if(Sector_Erase_Time_cnt == Sector_Erase_Time_MAX - 'd1)
		Erase_addr <= Erase_addr - 24'h001000;			//如果擦除当前扇区擦除地址就回到上一扇区地址
	else
		Erase_addr <= Erase_addr;
end





always@(posedge clk_10MHz)begin
	if(!sys_rst_n)
		Page_ADDR <= 24'h000000;
	else if(state == Chip_Erase_state)
		Page_ADDR <= 24'h000000;
	else if((Sector_Erase_Time_cnt == Sector_Erase_Time_MAX - 'd1) && Page_ADDR == 24'h000000)
		Page_ADDR <= 24'h000000;
	else if(Sector_Erase_Time_cnt == Sector_Erase_Time_MAX - 'd1)
		Page_ADDR <= Page_ADDR - 24'h001000;			//如果擦除当前扇区页写地址就回到上一扇区起始地址
	else if(flag == 1'b1)
		Page_ADDR <= Page_ADDR + 24'h000100;
	else
		Page_ADDR <= Page_ADDR;
end



always@(posedge clk_10MHz)begin
	if(!sys_rst_n)
		wr_data_cnt <= 4'd0;
	else if(wr_data_cnt == 4'd7)
		wr_data_cnt <= 4'd0;
	else if(state == write_data)
		wr_data_cnt <= wr_data_cnt + 'd1;
	else 
		wr_data_cnt <= 4'd0;
end




always@(posedge clk_10MHz)begin
	if(!sys_rst_n)
		read_ADDR<= 24'd0;
	else if(state == Chip_Erase_state)
		read_ADDR<= 24'd0;
	else if((Sector_Erase_Time_cnt == Sector_Erase_Time_MAX - 'd1) && read_ADDR == 24'h000000)
		read_ADDR <= 24'h000000;
	else if(Sector_Erase_Time_cnt == Sector_Erase_Time_MAX - 'd1)
		read_ADDR <= read_ADDR - 24'h001000;		//如果擦除当前扇区读地址回到上一扇区地址
	else if(write_data_Time_cnt == write_data_Time_cnt_MAX && Page_cnt == 'd0)
		read_ADDR <= Page_ADDR - 24'h001000;
	else
		read_ADDR <= read_ADDR;
end




always@(posedge clk_10MHz)begin
	if(!sys_rst_n)
		Byte <= 10'd0;
	else if(Byte == 10'd255 && wr_data_cnt == 4'd7)
		Byte <= 10'd0;
	else if(wr_data_cnt == 4'd7)
		Byte <= Byte + 10'd1;
	else 
		Byte <= Byte;
end







always@(posedge clk_10MHz)begin
	if(!sys_rst_n)
		flag <= 1'b0;
	else if(state == write_data_Time && CS_n == 1'b0)
		flag <= 1'b1;
	else
		flag <= 1'b0;
end





always@(posedge clk_10MHz)begin
	if(!sys_rst_n)
		Chip_Erase_cnt <= 4'd0;
	else if(state == Chip_Erase_state)
		Chip_Erase_cnt <= Chip_Erase_cnt + 4'd1;
	else
		Chip_Erase_cnt <= 4'd0;
end

	
	
always@(posedge clk_10MHz)begin
	if(!sys_rst_n)
		Page_cnt <= 5'd0;
	else if((Page_cnt == 5'd15 && flag == 1'b1) || (state == Sector_Erase_state) || (state == Chip_Erase_state))
		Page_cnt <= 5'd0;
	else if(flag == 1'b1)
		Page_cnt <= Page_cnt + 5'd1;
	else 
		Page_cnt <= Page_cnt;
end
	
	
	
	


always@(posedge clk_10MHz)begin
	if(!sys_rst_n)
		state <= IDLE;
	else
		state <= state_next;
end				

always@(*)begin
	if(!sys_rst_n)
		state_next <= IDLE;
	else begin
		case(state)
			IDLE:
				if(done && (uart_rxdata == Wirte_Enable || uart_rxdata == Chip_Erase || uart_rxdata == Sector_Erase))//8'h06、8'h60、8'h20
					state_next <= Wirte_Enable_state;
				else if(done && uart_rxdata == Read_Data)//8'h03
					state_next <= Read_Data_instruct;
				else
					state_next <= IDLE;
			Wirte_Enable_state:
				if( Wirte_Enable_cnt == 'd10 && uart_rxdata == Wirte_Enable)
					state_next <= Page_Program_instruct;
				else if(Wirte_Enable_cnt == 'd10 && uart_rxdata == Chip_Erase)
					state_next <= Chip_Erase_state;
				else if(Wirte_Enable_cnt == 'd10 && uart_rxdata == Sector_Erase)
					state_next <= Sector_Erase_state;
				else
					state_next <= Wirte_Enable_state;
			Chip_Erase_state:
				if(Chip_Erase_cnt == 'd7)
					state_next <= IDLE;
				else
					state_next <= Chip_Erase_state;
			Sector_Erase_state:
				if(Sector_Erase_cnt == 'd7)
					state_next <= Sector_Erase_addr;
				else
					state_next <= Sector_Erase_state;
			Sector_Erase_addr:
				if(Sector_Erase_addr_cnt == 'd23)
					state_next <= Sector_Erase_Time;
				else
					state_next <= Sector_Erase_addr;
			Sector_Erase_Time:
				if(Sector_Erase_Time_cnt == Sector_Erase_Time_MAX)
					state_next <= IDLE;
				else
					state_next <= Sector_Erase_Time;
			Page_Program_instruct:
				if(Page_Program_instruct_cnt == 'd7)
					state_next <= Page_Program_ADDR;
				else
					state_next <= Page_Program_instruct;
			Page_Program_ADDR:
				if(Page_Program_ADDR_cnt == 'd23)
					state_next <= write_data;
				else
					state_next <= Page_Program_ADDR;
			write_data:
				if(write_data_cnt == 'd2047)
					state_next <= write_data_Time;
				else
					state_next <= write_data;
			write_data_Time:
				if(write_data_Time_cnt == write_data_Time_cnt_MAX && Sector_cnt == 'd0)//Sector_cnt计数到0表示写完一个扇区
					state_next <= IDLE;
				else if(write_data_Time_cnt == write_data_Time_cnt_MAX)
					state_next <= Wirte_Enable_state;
				else
					state_next <= write_data_Time;
			Read_Data_instruct:
				if(Read_Data_instruct_cnt == 'd7)
					state_next <= Read_Data_ADDR;
				else
					state_next <= Read_Data_instruct;
			Read_Data_ADDR:
				if(Read_Data_ADDR_cnt == 'd23)
					state_next <= Read_Page_data;
				else
					state_next <= Read_Data_ADDR;
			Read_Page_data:
				if(read_data_cnt == 'd32767)//read_data_cnt为2047表示读取一页数据，read_data_cnt为32767表示读取一个扇区的数据
					state_next <= IDLE;
				else
					state_next <= Read_Page_data;
		default:state_next <= IDLE;
		endcase
	end
end




always@(posedge clk_10MHz)begin
	if(!sys_rst_n)
		MOSI <= 1'b0;
			if(state == Wirte_Enable_state)
				begin
					case(Wirte_Enable_cnt)
						4'd0:MOSI <= Wirte_Enable[7];
						4'd1:MOSI <= Wirte_Enable[6];
						4'd2:MOSI <= Wirte_Enable[5];
						4'd3:MOSI <= Wirte_Enable[4];
						4'd4:MOSI <= Wirte_Enable[3];
						4'd5:MOSI <= Wirte_Enable[2];
						4'd6:MOSI <= Wirte_Enable[1];
						4'd7:MOSI <= Wirte_Enable[0];
					default:MOSI <= 1'b0;
					endcase
				end
			else if(state == Sector_Erase_state)
			begin
				case(Sector_Erase_cnt)
					4'd0:MOSI <= Sector_Erase[7];
					4'd1:MOSI <= Sector_Erase[6];
					4'd2:MOSI <= Sector_Erase[5];
					4'd3:MOSI <= Sector_Erase[4];
					4'd4:MOSI <= Sector_Erase[3];
					4'd5:MOSI <= Sector_Erase[2];
					4'd6:MOSI <= Sector_Erase[1];
					4'd7:MOSI <= Sector_Erase[0];
					default:MOSI <= 1'b0;
					endcase
			end
			else if(state == Sector_Erase_addr)
			begin
				case(Sector_Erase_addr_cnt)
				   5'd0 :MOSI <= Erase_addr[23];
				   5'd1 :MOSI <= Erase_addr[22];
				   5'd2 :MOSI <= Erase_addr[21];
				   5'd3 :MOSI <= Erase_addr[20];
				   5'd4 :MOSI <= Erase_addr[19];
				   5'd5 :MOSI <= Erase_addr[18];
				   5'd6 :MOSI <= Erase_addr[17];
				   5'd7 :MOSI <= Erase_addr[16];
				   5'd8 :MOSI <= Erase_addr[15];
				   5'd9 :MOSI <= Erase_addr[14];
				   5'd10:MOSI <= Erase_addr[13];
				   5'd11:MOSI <= Erase_addr[12];
				   5'd12:MOSI <= Erase_addr[11];
				   5'd13:MOSI <= Erase_addr[10];
				   5'd14:MOSI <= Erase_addr[9];
				   5'd15:MOSI <= Erase_addr[8];
				   5'd16:MOSI <= Erase_addr[7];
				   5'd17:MOSI <= Erase_addr[6];
				   5'd18:MOSI <= Erase_addr[5];
				   5'd19:MOSI <= Erase_addr[4];
				   5'd20:MOSI <= Erase_addr[3];
				   5'd21:MOSI <= Erase_addr[2];
				   5'd22:MOSI <= Erase_addr[1];
				   5'd23:MOSI <= Erase_addr[0];
					default:MOSI <= 1'b0;
					endcase
			end
			else if(state == Page_Program_instruct)
			begin
				case(Page_Program_instruct_cnt)
					4'd0:MOSI <= Page_Program[7];
					4'd1:MOSI <= Page_Program[6];
					4'd2:MOSI <= Page_Program[5];
					4'd3:MOSI <= Page_Program[4];
					4'd4:MOSI <= Page_Program[3];
					4'd5:MOSI <= Page_Program[2];
					4'd6:MOSI <= Page_Program[1];
					4'd7:MOSI <= Page_Program[0];
				default:MOSI <= 1'b0;
				endcase
			end
			else if(state == Page_Program_ADDR)
			begin
				case(Page_Program_ADDR_cnt)
					5'd0 :MOSI <= Page_ADDR[23];
					5'd1 :MOSI <= Page_ADDR[22];
					5'd2 :MOSI <= Page_ADDR[21];
					5'd3 :MOSI <= Page_ADDR[20];
					5'd4 :MOSI <= Page_ADDR[19];
					5'd5 :MOSI <= Page_ADDR[18];
					5'd6 :MOSI <= Page_ADDR[17];
					5'd7 :MOSI <= Page_ADDR[16];
					5'd8 :MOSI <= Page_ADDR[15];
					5'd9 :MOSI <= Page_ADDR[14];
					5'd10:MOSI <= Page_ADDR[13];
					5'd11:MOSI <= Page_ADDR[12];
					5'd12:MOSI <= Page_ADDR[11];
					5'd13:MOSI <= Page_ADDR[10];
					5'd14:MOSI <= Page_ADDR[9];
					5'd15:MOSI <= Page_ADDR[8];
					5'd16:MOSI <= Page_ADDR[7];
					5'd17:MOSI <= Page_ADDR[6];
					5'd18:MOSI <= Page_ADDR[5];
					5'd19:MOSI <= Page_ADDR[4];
					5'd20:MOSI <= Page_ADDR[3];
					5'd21:MOSI <= Page_ADDR[2];
					5'd22:MOSI <= Page_ADDR[1];
					5'd23:MOSI <= Page_ADDR[0];
				default:MOSI <= 1'b0;
				endcase
			end
			else if(state == write_data)begin
				case(wr_data_cnt)
					4'd0:MOSI <= wr_data[7];
					4'd1:MOSI <= wr_data[6];
					4'd2:MOSI <= wr_data[5];
					4'd3:MOSI <= wr_data[4];
					4'd4:MOSI <= wr_data[3];
					4'd5:MOSI <= wr_data[2];
					4'd6:MOSI <= wr_data[1];
					4'd7:MOSI <= wr_data[0];
				default:MOSI <= 1'b0;
				endcase
			end
			else if(state == Read_Data_instruct)begin
				case(Read_Data_instruct_cnt)
					4'd0:MOSI <= Read_Data[7];
					4'd1:MOSI <= Read_Data[6];
					4'd2:MOSI <= Read_Data[5];
					4'd3:MOSI <= Read_Data[4];
					4'd4:MOSI <= Read_Data[3];
					4'd5:MOSI <= Read_Data[2];
					4'd6:MOSI <= Read_Data[1];
					4'd7:MOSI <= Read_Data[0];
				default:MOSI <= 1'b0;
				endcase
			end
			else if(state == Read_Data_ADDR)begin
					case(Read_Data_ADDR_cnt)
					5'd0 :MOSI <= read_ADDR[23];
					5'd1 :MOSI <= read_ADDR[22];
					5'd2 :MOSI <= read_ADDR[21];
					5'd3 :MOSI <= read_ADDR[20];
					5'd4 :MOSI <= read_ADDR[19];
					5'd5 :MOSI <= read_ADDR[18];
					5'd6 :MOSI <= read_ADDR[17];
					5'd7 :MOSI <= read_ADDR[16];
					5'd8 :MOSI <= read_ADDR[15];
					5'd9 :MOSI <= read_ADDR[14];
					5'd10:MOSI <= read_ADDR[13];
					5'd11:MOSI <= read_ADDR[12];
					5'd12:MOSI <= read_ADDR[11];
					5'd13:MOSI <= read_ADDR[10];
					5'd14:MOSI <= read_ADDR[9];
					5'd15:MOSI <= read_ADDR[8];
					5'd16:MOSI <= read_ADDR[7];
					5'd17:MOSI <= read_ADDR[6];
					5'd18:MOSI <= read_ADDR[5];
					5'd19:MOSI <= read_ADDR[4];
					5'd20:MOSI <= read_ADDR[3];
					5'd21:MOSI <= read_ADDR[2];
					5'd22:MOSI <= read_ADDR[1];
					5'd23:MOSI <= read_ADDR[0];
				default:MOSI <= 1'b0;
				endcase
			end
			else if(state == Chip_Erase_state)begin
				case(Chip_Erase_cnt)
					4'd0:MOSI <= Chip_Erase[7];
					4'd1:MOSI <= Chip_Erase[6];
					4'd2:MOSI <= Chip_Erase[5];
					4'd3:MOSI <= Chip_Erase[4];
					4'd4:MOSI <= Chip_Erase[3];
					4'd5:MOSI <= Chip_Erase[2];
					4'd6:MOSI <= Chip_Erase[1];
					4'd7:MOSI <= Chip_Erase[0];
				default:MOSI <= 1'b0;
				endcase
			end
		else
			MOSI <= 1'b0;
end


always@(posedge clk_10MHz)begin
	if(!sys_rst_n)
		CS_n <= 1'b1;
	else if((state ==Wirte_Enable_state  && Wirte_Enable_cnt < 4'd8) || (state == Sector_Erase_state) || 
			(state == Sector_Erase_addr) || (state == Page_Program_instruct) || 
			(state == Page_Program_ADDR) || (state == write_data) || (state == Read_Data_instruct) ||
			(state == Read_Data_ADDR) || (state == Read_Page_data) || state == Chip_Erase_state)
		CS_n <= 1'b0;
	else
		CS_n <= 1'b1;
end



assign SPI_CLK = (CS_n ||(Sector_Erase_addr_cnt == 'd25) || (write_data_Time_cnt == 4'd1 ))?(1'b0):(~clk_10MHz);




mkey_uart_rx mkey_uart_rx_inst(
    .			  sys_clk(sys_clk),                  
    .             sys_rst_n(sys_rst_n),               
    
    .			  rx(uart_rxpin),               
    .			  out_flag(uart_done),   //接收一帧数据完成标志            
    .			  out_data(uart_rxdata)              
    );
	
	
	
data data_inst(
	. sys_clk(sys_clk),
	. sys_rst_n(sys_rst_n),
	. Byte(Byte),
	
	. Data(wr_data)

    );
	

  clk_wiz_0 clk_wiz_0_inst
   (
    // Clock out ports
    .clk_out1(clk_10MHz),     // output clk_out1
    // Status and control signals
    .resetn(sys_rst_n), // input resetn
   // Clock in ports
    .clk_in1(sys_clk));      // input clk_in1
	



endmodule
