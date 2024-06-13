module registers (
	input										axi_clk							,
	input			[11:0]						h2f_axi_awid					,
	input			[29:0]						h2f_axi_awaddr					,
	input										h2f_axi_awvalid					,
	output										h2f_axi_awready					,
	input			[31:0]						h2f_axi_wdata					,
	input			[3:0]						h2f_axi_wstrb					,
	input										h2f_axi_wlast					,
	input										h2f_axi_wvalid					,
	output										h2f_axi_wready					,
	output			[11:0]						h2f_axi_bid						,
	output			[1:0]						h2f_axi_bresp					,
	output										h2f_axi_bvalid					,
	input										h2f_axi_bready					,
	input			[11:0]						h2f_axi_arid					,
	input			[29:0]						h2f_axi_araddr					,
	input			[3:0]						h2f_axi_arlen					,
	input										h2f_axi_arvalid					,
	output										h2f_axi_arready					,
	output			[11:0] 						h2f_axi_rid						,
	output			[31:0]						h2f_axi_rdata					,
	output			[1:0]						h2f_axi_rresp					,
	output										h2f_axi_rlast					,
	output										h2f_axi_rvalid					,
	input										h2f_axi_rready					,
	input			[31:0]						reg_fpga_rev					,
	input										reg_sw1_4						,
	input										reg_sw1_3						,
	input										reg_sw1_2						,
	input										reg_sw1_1						,
	output										reg_jp3_4						,
	output										reg_jp3_3						,
	output										reg_jp3_2						,
	output										reg_jp3_1						,
	output										reg_led_8						,
	output										reg_led_7						,
	output										reg_led_6						,
	input										reg_led_5						,
	output			[20:1]						reg_jp5							,
	output			[6:1]						reg_jp4_rxn						,
	output			[6:1]						reg_jp4_rxp						,
	output			[6:1]						reg_jp4_txn						,
	output			[6:1]						reg_jp4_txp						,
	input										axi_rst							);
	
	//-----------------------------------------------------------------------------------------------
	wire			[11:0]				axi_i_awid						;
	wire			[6:2]				axi_i_awaddr					;
	wire								axi_i_awvalid					;
	wire								axi_o_awready					;
	wire			[31:0]				axi_i_wdata						;
	wire			[3:0]				axi_i_wstrb						;
	wire								axi_i_wlast						;
	wire								axi_i_wvalid					;
	wire								axi_o_wready_in					;
	reg									axi_o_wready					;
	wire			[11:0]				axi_o_bid_in					;
	reg				[11:0]				axi_o_bid						;
	wire			[1:0]				axi_o_bresp						;
	wire								axi_o_bvalid_in					;
	reg									axi_o_bvalid					;
	wire								axi_i_bready					;
	wire			[11:0]				axi_i_arid						;
	wire			[6:2]				axi_i_araddr					;
	wire			[3:0]				axi_i_arlen						;
	wire								axi_i_arvalid					;
	wire								axi_o_arready_in				;
	reg									axi_o_arready					;
	wire			[11:0] 				axi_o_rid_in					;
	reg				[11:0] 				axi_o_rid						;
	wire			[31:0]				axi_o_rdata_in					;
	reg				[31:0]				axi_o_rdata						;
	wire			[1:0]				axi_o_rresp						;
	wire								axi_o_rlast_in					;
	reg									axi_o_rlast						;
	wire								axi_o_rvalid_in					;
	reg									axi_o_rvalid					;
	wire								axi_i_rready					;
	wire								wadr_val						;
	wire								wdat_val						;
	wire								wr_act_in						;
	reg									wr_act							;
	reg				[6:2]				set_wadr_in						;
	reg				[6:2]				set_wadr						;
	wire			[6:2]				wr_adr_in						;
	reg				[6:2]				wr_adr							;
	wire			[31:0]				wr_dat_in						;
	reg				[31:0]				wr_dat							;
	wire			[3:0]				wr_stb_in						;
	reg				[3:0]				wr_stb							;
	wire								wr_done							;
	wire								radr_val						;
	reg									radr_val_1st					;
	reg									radr_val_2nd					;
	wire								rdat_val						;
	reg									rdat_val_1st					;
	reg				[6:2]				rd_adr_in						;
	reg				[6:2]				rd_adr							;
	wire								set_rdat						;
	reg				[3:0]				rd_cnt_in						;
	reg				[3:0]				rd_cnt							;
	wire								rd_cnt_zero						;
	wire								rd_cnt_last						;
	wire								rlast_set						;
	wire								rd_done_in						;
	reg									rd_done							;
	reg				[31:0]				rd_dat							;
	wire			[31:0]				fpga_rev						;
	wire								board_sw1_4						;
	wire								board_sw1_3						;
	wire								board_sw1_2						;
	wire								board_sw1_1						;
	reg									board_jp3_4						;
	reg									board_jp3_3						;
	reg									board_jp3_2						;
	reg									board_jp3_1						;
	reg									board_led_8						;
	reg									board_led_7						;
	reg									board_led_6						;
	wire								board_led_5						;
	reg				[20:1]				board_jp5						;
	reg				[6:1]				board_jp4_rxn					;
	reg				[6:1]				board_jp4_rxp					;
	reg				[6:1]				board_jp4_txn					;
	reg				[6:1]				board_jp4_txp					;
	wire			[31:0]				reg_00h							;
	wire			[31:0]				reg_04h							;
	wire			[31:0]				reg_08h							;
	wire			[31:0]				reg_0ch							;
	
	localparam PRM_RESP_OKAY	= 2'b00;
	
	localparam PRM_00H	= 5'b00000;
	localparam PRM_04H	= 5'b00001;
	localparam PRM_08H	= 5'b00010;
	localparam PRM_0CH	= 5'b00011;
	
	//=========================================================================================================
	// AXI interface Signals.
	//=========================================================================================================
	// Input signals
	assign axi_i_awvalid		= h2f_axi_awvalid;
	assign axi_i_awaddr[6:2]	= h2f_axi_awaddr[6:2];
	assign axi_i_awid			= h2f_axi_awid;
	assign axi_i_wvalid			= h2f_axi_wvalid;
	assign axi_i_wlast			= h2f_axi_wlast;
	assign axi_i_wdata			= h2f_axi_wdata;
	assign axi_i_wstrb			= h2f_axi_wstrb;
	assign axi_i_bready			= h2f_axi_bready;
	assign axi_i_arvalid		= h2f_axi_arvalid;
	assign axi_i_araddr[6:2]	= h2f_axi_araddr[6:2];
	assign axi_i_arid			= h2f_axi_arid;
	assign axi_i_arlen			= h2f_axi_arlen;
	assign axi_i_rready			= h2f_axi_rready;
	
	// Output signals
	assign h2f_axi_awready	= axi_o_awready;
	assign h2f_axi_wready	= axi_o_wready;
	assign h2f_axi_bvalid	= axi_o_bvalid;
	assign h2f_axi_bresp	= axi_o_bresp;
	assign h2f_axi_bid		= axi_o_bid;
	assign h2f_axi_arready	= axi_o_arready;
	assign h2f_axi_rvalid	= axi_o_rvalid;
	assign h2f_axi_rlast	= axi_o_rlast;
	assign h2f_axi_rdata	= axi_o_rdata;
	assign h2f_axi_rid		= axi_o_rid;
	assign h2f_axi_rresp	= axi_o_rresp;
	
	//=========================================================================================================
	// Registers interface signals
	//=========================================================================================================
	// Register input signals.
	assign board_sw1_4	= reg_sw1_4;
	assign board_sw1_3	= reg_sw1_3;
	assign board_sw1_2	= reg_sw1_2;
	assign board_sw1_1	= reg_sw1_1;
	assign fpga_rev		= reg_fpga_rev;
	assign board_led_5	= reg_led_5;
	
	// Register output signals.
	assign reg_jp3_4	= board_jp3_4;
	assign reg_jp3_3	= board_jp3_3;
	assign reg_jp3_2	= board_jp3_2;
	assign reg_jp3_1	= board_jp3_1;
	assign reg_led_8	= board_led_8;
	assign reg_led_7	= board_led_7;
	assign reg_led_6	= board_led_6;
	assign reg_jp5		= board_jp5;
	assign reg_jp4_rxn	= board_jp4_rxn;
	assign reg_jp4_rxp	= board_jp4_rxp;
	assign reg_jp4_txn	= board_jp4_txn;
	assign reg_jp4_txp	= board_jp4_txp;
	
	//=========================================================================================================
	// AXI Bus interface (Write access).
	//=========================================================================================================
	assign wadr_val = axi_o_awready & axi_i_awvalid;
	assign wdat_val = axi_o_wready  & axi_i_wvalid;
	
	// Write address control.
	always @ (posedge axi_clk)
	begin
		if(axi_rst)
		begin
			wr_act <= 1'b0;
		end
		else
		begin
			wr_act <= wr_act_in;
		end
	end
	
	assign wr_act_in = wadr_val | (wr_act & ~wr_done);
	
	assign axi_o_awready = ~wr_act;
	
	always @ (posedge axi_clk)
	begin
		set_wadr <= set_wadr_in;
	end
	
	always @ (wadr_val, wdat_val, axi_i_awaddr, set_wadr)
	begin
		case ({wadr_val, wdat_val})
			2'b10	: set_wadr_in <= axi_i_awaddr;
			2'b01	: set_wadr_in <= set_wadr + 5'b00001;
			default	: set_wadr_in <= set_wadr;
		endcase
	end
	
	// Write data control.
	always @ (posedge axi_clk)
	begin
		if(axi_rst)
		begin
			axi_o_wready <= 1'b0;
		end
		else
		begin
			axi_o_wready <= axi_o_wready_in;
		end
	end
	
	assign axi_o_wready_in = wadr_val | (axi_o_wready & ~(axi_i_wvalid & axi_i_wlast));
	
	always @ (posedge axi_clk)
	begin
		wr_adr <= wr_adr_in;
		wr_dat <= wr_dat_in;
		wr_stb <= wr_stb_in;
	end
	
	assign wr_adr_in = set_wadr;
	assign wr_dat_in = axi_i_wdata;
	assign wr_stb_in = wdat_val ? axi_i_wstrb : 4'b0000;
	
	// Response
	assign axi_o_bresp = PRM_RESP_OKAY;
	
	always @ (posedge axi_clk)
	begin
		if(axi_rst)
		begin
			axi_o_bvalid <= 1'b0;
		end
		else
		begin
			axi_o_bvalid <= axi_o_bvalid_in;
		end
	end
	
	assign axi_o_bvalid_in = (wdat_val & axi_i_wlast) | (axi_o_bvalid & ~axi_i_bready);
	
	always @ (posedge axi_clk)
	begin
		axi_o_bid <= axi_o_bid_in;
	end
	
	assign axi_o_bid_in = wadr_val ? axi_i_awid : axi_o_bid;
	
	assign wr_done = axi_o_bvalid & axi_i_bready;
	
	//=========================================================================================================
	// AXI Bus interface (Read access).
	//=========================================================================================================
	assign radr_val = axi_o_arready & axi_i_arvalid;
	assign rdat_val = axi_i_rready  & axi_o_rvalid;
	
	always @ (posedge axi_clk)
	begin
		radr_val_1st <= radr_val;
		radr_val_2nd <= radr_val_1st;
		rdat_val_1st <= rdat_val;
	end
	
	// Read address control.
	always @ (posedge axi_clk)
	begin
		if(axi_rst)
		begin
			axi_o_arready <= 1'b1;
		end
		else
		begin
			axi_o_arready <= axi_o_arready_in;
		end
	end
	
	assign axi_o_arready_in = rd_done | (axi_o_arready & ~radr_val);
	
	always @ (posedge axi_clk)
	begin
		rd_adr <= rd_adr_in;
	end
	
	always @ (radr_val, radr_val_1st, rdat_val, axi_i_araddr, rd_adr)
	begin
		case ({radr_val, (radr_val_1st | rdat_val)})
			2'b10	: rd_adr_in <= axi_i_araddr;
			2'b01	: rd_adr_in <= rd_adr + 5'b00001;
			default	: rd_adr_in <= rd_adr;
		endcase
	end
	
	// Read data control.
	always @ (posedge axi_clk)
	begin
		axi_o_rdata <= axi_o_rdata_in;
	end
	
	assign set_rdat = radr_val_2nd | rdat_val | rdat_val_1st;
	
	assign axi_o_rdata_in = set_rdat ? rd_dat : axi_o_rdata;
	
	always @ (posedge axi_clk)
	begin
		rd_cnt <= rd_cnt_in;
	end
	
	always @ (radr_val, rdat_val, axi_i_arlen, rd_cnt)
	begin
		case ({radr_val, rdat_val})
			2'b10	: rd_cnt_in <= axi_i_arlen;
			2'b01	: rd_cnt_in <= rd_cnt - 4'b0001;
			default	: rd_cnt_in <= rd_cnt;
		endcase
	end
	
	assign rd_cnt_zero = (rd_cnt == 4'b0000) ? 1'b1 : 1'b0;
	assign rd_cnt_last = (rd_cnt == 4'b0001) ? 1'b1 : 1'b0;
	
	always @ (posedge axi_clk)
	begin
		if(axi_rst)
		begin
			axi_o_rlast <= 1'b0;
		end
		else
		begin
			axi_o_rlast <= axi_o_rlast_in;
		end
	end
	
	assign rlast_set = (radr_val_2nd & rd_cnt_zero) | (rd_cnt_last & rdat_val);
	
	assign axi_o_rlast_in = rlast_set | (axi_o_rlast & ~axi_i_rready);
	
	always @ (posedge axi_clk)
	begin
		if(axi_rst)
		begin
			axi_o_rvalid <= 1'b0;
		end
		else
		begin
			axi_o_rvalid <= axi_o_rvalid_in;
		end
	end
	
	assign axi_o_rvalid_in = radr_val_2nd | (axi_o_rvalid & ~(axi_o_rlast & axi_i_rready));
	
	// Response
	assign axi_o_rresp = PRM_RESP_OKAY;
	
	always @ (posedge axi_clk)
	begin
		axi_o_rid <= axi_o_rid_in;
	end
	
	assign axi_o_rid_in = radr_val ? axi_i_arid : axi_o_rid;
	
	always @ (posedge axi_clk)
	begin
		rd_done <= rd_done_in;
	end
	
	assign rd_done_in = axi_o_rlast & rdat_val;
	
	//=========================================================================================================
	// Registers (WRITE)
	//=========================================================================================================
	always @ (posedge axi_clk)
	begin
		if(axi_rst)
		begin
			board_jp3_4		<= 1'b0;
			board_jp3_3		<= 1'b0;
			board_jp3_2		<= 1'b0;
			board_jp3_1		<= 1'b0;
			board_led_8		<= 1'b1;
			board_led_7		<= 1'b1;
			board_led_6		<= 1'b1;
			board_jp5		<= {20{1'b1}};
			board_jp4_rxn	<= {6{1'b1}};
			board_jp4_rxp	<= {6{1'b1}};
			board_jp4_txn	<= {6{1'b1}};
			board_jp4_txp	<= {6{1'b1}};
		end
		else
		begin
			if(wr_act)
			begin
				case (wr_adr[6:2])
					//-- 0x00 ------------------------------------------------------------------------------
					//			[Read only]
					//-- 0x04 ------------------------------------------------------------------------------
					PRM_04H	:
					begin
						if(wr_stb[1])	begin	board_jp3_4			<= wr_dat[11];
												board_jp3_3			<= wr_dat[10];
												board_jp3_2			<= wr_dat[09];
												board_jp3_1			<= wr_dat[08];		end
						if(wr_stb[0])	begin	board_led_8			<= wr_dat[03];
												board_led_7			<= wr_dat[02];
												board_led_6			<= wr_dat[01];		end
					end
					//-- 0x08 ------------------------------------------------------------------------------
					PRM_08H	:
					begin
						if(wr_stb[2])	begin	board_jp5[20:17]	<= wr_dat[19:16];	end
						if(wr_stb[1])	begin	board_jp5[16:09]	<= wr_dat[15:08];	end
						if(wr_stb[0])	begin	board_jp5[08:01]	<= wr_dat[07:00];	end
					end
					//-- 0x0C ------------------------------------------------------------------------------
					PRM_0CH	:
					begin
						if(wr_stb[3])	begin	board_jp4_rxn[6:1]	<= wr_dat[29:24];	end
						if(wr_stb[2])	begin	board_jp4_rxp[6:1]	<= wr_dat[21:16];	end
						if(wr_stb[1])	begin	board_jp4_txn[6:1]	<= wr_dat[13:08];	end
						if(wr_stb[0])	begin	board_jp4_txp[6:1]	<= wr_dat[05:00];	end
					end
				endcase
			end
		end
	end
	
	//=========================================================================================================
	// Registers (read)
	//=========================================================================================================
	always @ (posedge axi_clk)
	begin
		if(axi_rst)
		begin
			rd_dat <= {32{1'b0}};
		end
		else
		begin
			case (rd_adr[6:2])
				PRM_00H	: rd_dat <= reg_00h;
				PRM_04H	: rd_dat <= reg_04h;
				PRM_08H	: rd_dat <= reg_08h;
				PRM_0CH	: rd_dat <= reg_0ch;
				default	: rd_dat <= {32{1'b0}};
			endcase
		end
	end
	
	//=========================================================================================================
	// Registers Body
	//=========================================================================================================
	
	//---------------------------------------------------------------------------------------------------------
	// 00h: FPGA Information Register
	//---------------------------------------------------------------------------------------------------------
	assign reg_00h[31:00] = fpga_rev;
	
	//---------------------------------------------------------------------------------------------------------
	// 04h: HW Control Register
	//---------------------------------------------------------------------------------------------------------
	assign reg_04h[31:24] = 8'b00000000;
	assign reg_04h[23:20] = 4'b0000;
	assign reg_04h[19]    = board_sw1_4;
	assign reg_04h[18]    = board_sw1_3;
	assign reg_04h[17]    = board_sw1_2;
	assign reg_04h[16]    = board_sw1_1;
	assign reg_04h[15:12] = 4'b0000;
	assign reg_04h[11]    = board_jp3_4;
	assign reg_04h[10]    = board_jp3_3;
	assign reg_04h[09]    = board_jp3_2;
	assign reg_04h[08]    = board_jp3_1;
	assign reg_04h[07:04] = 4'b0000;
	assign reg_04h[03]    = board_led_8;
	assign reg_04h[02]    = board_led_7;
	assign reg_04h[01]    = board_led_6;
	assign reg_04h[00]    = board_led_5;
	
	//---------------------------------------------------------------------------------------------------------
	// 08h: External Signals Control Register 1
	//---------------------------------------------------------------------------------------------------------
	assign reg_08h[31:24] = 8'b00000000;
	assign reg_08h[23:20] = 4'b0000;
	assign reg_08h[19:00] = board_jp5[20:1];
	
	//---------------------------------------------------------------------------------------------------------
	// 0Ch: External Signals Control Register 2
	//---------------------------------------------------------------------------------------------------------
	assign reg_0ch[31:30] = 2'b00;
	assign reg_0ch[29:24] = board_jp4_rxn[6:1];
	assign reg_0ch[23:22] = 2'b00;
	assign reg_0ch[21:16] = board_jp4_rxp[6:1];
	assign reg_0ch[15:14] = 2'b00;
	assign reg_0ch[13:08] = board_jp4_txn[6:1];
	assign reg_0ch[07:06] = 2'b00;
	assign reg_0ch[05:00] = board_jp4_txp[6:1];
	
endmodule
