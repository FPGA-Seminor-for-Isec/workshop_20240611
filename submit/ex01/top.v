module top (
	//---- hps section ----------------------------------------------------------
	output			[14:0]						pin_hps_ddr_mem_a				,
	output			[2:0]						pin_hps_ddr_mem_ba				,
	output										pin_hps_ddr_mem_ck				,
	output										pin_hps_ddr_mem_ck_n			,
	output										pin_hps_ddr_mem_cke				,
	output										pin_hps_ddr_mem_cs_n			,
	output										pin_hps_ddr_mem_ras_n			,
	output										pin_hps_ddr_mem_cas_n			,
	output										pin_hps_ddr_mem_we_n			,
	output										pin_hps_ddr_mem_reset_n			,
	inout			[31:0]						pin_hps_ddr_mem_dq				,
	inout			[3:0]						pin_hps_ddr_mem_dqs				,
	inout			[3:0]						pin_hps_ddr_mem_dqs_n			,
	output										pin_hps_ddr_mem_odt				,
	output			[3:0]						pin_hps_ddr_mem_dm				,
	input										pin_hps_ddr_oct_rzqin			,
	output										pin_hps_io_emac0_inst_TX_CLK	,
	output										pin_hps_io_emac0_inst_TXD0		,
	output										pin_hps_io_emac0_inst_TXD1		,
	output										pin_hps_io_emac0_inst_TXD2		,
	output										pin_hps_io_emac0_inst_TXD3		,
	input										pin_hps_io_emac0_inst_RXD0		,
	inout										pin_hps_io_emac0_inst_MDIO		,
	output										pin_hps_io_emac0_inst_MDC		,
	input										pin_hps_io_emac0_inst_RX_CTL	,
	output										pin_hps_io_emac0_inst_TX_CTL	,
	input										pin_hps_io_emac0_inst_RX_CLK	,
	input										pin_hps_io_emac0_inst_RXD1		,
	input										pin_hps_io_emac0_inst_RXD2		,
	input										pin_hps_io_emac0_inst_RXD3		,
	inout										pin_hps_io_sdio_inst_CMD		,
	inout										pin_hps_io_sdio_inst_D0			,
	inout										pin_hps_io_sdio_inst_D1			,
	output										pin_hps_io_sdio_inst_CLK		,
	inout										pin_hps_io_sdio_inst_D2			,
	inout										pin_hps_io_sdio_inst_D3			,
	input										pin_hps_io_uart0_inst_RX		,
	output										pin_hps_io_uart0_inst_TX		,
	inout										pin_hps_io_i2c0_inst_SDA		,
	inout										pin_hps_io_i2c0_inst_SCL		,
	inout										pin_hps_io_gpio_inst_GPIO23		,	// Ethernet-PHY reset (Active Low)
	inout										pin_hps_io_gpio_inst_GPIO20		,	// LED1
	inout										pin_hps_io_gpio_inst_GPIO21		,	// LED2
	inout										pin_hps_io_gpio_inst_GPIO51		,	// LED3
	inout										pin_hps_io_gpio_inst_GPIO52		,	// LED4
	inout										pin_hps_io_gpio_inst_GPIO57		,	// GPIO1
	inout										pin_hps_io_gpio_inst_GPIO58		,	// GPIO2
	inout										pin_hps_io_gpio_inst_GPIO63		,	// GPIO3
	inout										pin_hps_io_gpio_inst_GPIO64		,	// GPIO4
	//---- fpga section ---------------------------------------------------------
	output		[4:1]							pin_fpga_led					,
	input		[4:1]							pin_fpga_sw						,
	output		[4:1]							pin_fpga_gpio					,
	output		[6:1]							pin_jp4_rxn						,
	output		[6:1]							pin_jp4_rxp						,
	output		[6:1]							pin_jp4_txn						,
	output		[6:1]							pin_jp4_txp						,
	output		[20:1]							pin_jp5							);
	
	//-----------------------------------------------------------------------------------------------
	wire								axi_clk							;	// 50 MHz
	wire	[11:0]						h2f_axi_awid					;
	wire	[29:0]						h2f_axi_awaddr					;
	wire								h2f_axi_awvalid					;
	wire								h2f_axi_awready					;
	wire	[31:0]						h2f_axi_wdata					;
	wire	[3:0]						h2f_axi_wstrb					;
	wire								h2f_axi_wlast					;
	wire								h2f_axi_wvalid					;
	wire								h2f_axi_wready					;
	wire	[11:0]						h2f_axi_bid						;
	wire	[1:0]						h2f_axi_bresp					;
	wire								h2f_axi_bvalid					;
	wire								h2f_axi_bready					;
	wire	[11:0]						h2f_axi_arid					;
	wire	[29:0]						h2f_axi_araddr					;
	wire	[3:0]						h2f_axi_arlen					;
	wire								h2f_axi_arvalid					;
	wire								h2f_axi_arready					;
	wire	[11:0] 						h2f_axi_rid						;
	wire	[31:0]						h2f_axi_rdata					;
	wire	[1:0]						h2f_axi_rresp					;
	wire								h2f_axi_rlast					;
	wire								h2f_axi_rvalid					;
	wire								h2f_axi_rready					;
	wire								axi_rst							;
	wire	[7:0]						fpga_dev						;
	wire	[7:0]						fpga_fun						;
	wire	[15:0]						fpga_rev						;
	wire	[31:0]						reg_fpga_rev					;
	wire								reg_sw1_4_in					;
	wire								reg_sw1_3_in					;
	wire								reg_sw1_2_in					;
	wire								reg_sw1_1_in					;
	reg									reg_sw1_4						;
	reg									reg_sw1_3						;
	reg									reg_sw1_2						;
	reg									reg_sw1_1						;
	wire								reg_jp3_4						;
	wire								reg_jp3_3						;
	wire								reg_jp3_2						;
	wire								reg_jp3_1						;
	reg		[31:0]						hb_cnt							;
	wire								heat_beat_in					;
	reg									heat_beat						;
	wire								reg_led_8						;
	wire								reg_led_7						;
	wire								reg_led_6						;
	wire								reg_led_5						;
	wire	[20:1]						reg_jp5							;
	wire	[6:1]						reg_jp4_rxn						;
	wire	[6:1]						reg_jp4_rxp						;
	wire	[6:1]						reg_jp4_txn						;
	wire	[6:1]						reg_jp4_txp						;
	
	//=========================================================================================================
	// FPGA version.
	//=========================================================================================================
	assign fpga_dev = 8'h02;
	assign fpga_fun = 8'h01;
	assign fpga_rev = 16'h0001;
	
	assign reg_fpga_rev = {fpga_dev, fpga_fun, fpga_rev};
	
	//=========================================================================================================
	// Switch
	//=========================================================================================================
	always @ (posedge axi_clk)
	begin
		reg_sw1_4 <= reg_sw1_4_in;
		reg_sw1_3 <= reg_sw1_3_in;
		reg_sw1_2 <= reg_sw1_2_in;
		reg_sw1_1 <= reg_sw1_1_in;
	end
	
	assign reg_sw1_4_in = ~pin_fpga_sw[4];
	assign reg_sw1_3_in = ~pin_fpga_sw[3];
	assign reg_sw1_2_in = ~pin_fpga_sw[2];
	assign reg_sw1_1_in = ~pin_fpga_sw[1];
	
	//=========================================================================================================
	// On board header
	//=========================================================================================================

	assign pin_fpga_gpio[4] = reg_jp3_4;
	assign pin_fpga_gpio[3] = reg_jp3_3;
	assign pin_fpga_gpio[2] = reg_jp3_2;
	assign pin_fpga_gpio[1] = reg_jp3_1;

	//=========================================================================================================
	// LED
	//=========================================================================================================
	assign pin_fpga_led[4] = reg_led_8;
	assign pin_fpga_led[3] = reg_led_7;
	assign pin_fpga_led[2] = reg_led_6;
	assign pin_fpga_led[1] = reg_led_5;
	
	//add by hamamoto
	if(reg_jp3_1 == 1'b1)
		reg_led_8 <= 1'b1;
	else
		reg_led_8 <= 1'b0;
	
	assign reg_led_5 = heat_beat;
	
	// Heatbeat led
	always @ (posedge axi_clk)
	begin
		heat_beat <= heat_beat_in;
	end
	
	always @ (posedge axi_clk)
	begin
		hb_cnt <= hb_cnt + 1'b1;
	end
	
	assign heat_beat_in =   ((~hb_cnt[26]) & (~hb_cnt[25]) & (~hb_cnt[24]) & (~hb_cnt[23]))
	                      | ((~hb_cnt[26]) & (~hb_cnt[25]) & ( hb_cnt[24]) & (~hb_cnt[23]));
	                      
	//=========================================================================================================
	// External Signals (all signals use single-end io-standard.)
	//=========================================================================================================
	assign pin_jp5[20:1] = reg_jp5[20:1];
	
	assign pin_jp4_rxn[6:1] = reg_jp4_rxn[6:1];
	assign pin_jp4_rxp[6:1] = reg_jp4_rxp[6:1];
	assign pin_jp4_txn[6:1] = reg_jp4_txn[6:1];
	assign pin_jp4_txp[6:1] = reg_jp4_txp[6:1];
	
	//=========================================================================================================
	// Port maps
	//=========================================================================================================
	alice_qsys alice_qsys_inst (
		.axi_i_clk_clk						( axi_clk						)	,	//	input	wire			
		.axi_o_clk_clk						( axi_clk						)	,	//	output	wire			
		.h2f_axi_awid						( h2f_axi_awid					)	,	//	output	wire	[11:0]	
		.h2f_axi_awaddr						( h2f_axi_awaddr				)	,	//	output	wire	[29:0]	
		.h2f_axi_awlen						( 								)	,	//	output	wire	[3:0]	
		.h2f_axi_awsize						( 								)	,	//	output	wire	[2:0]	
		.h2f_axi_awburst					( 								)	,	//	output	wire	[1:0]	
		.h2f_axi_awlock						( 								)	,	//	output	wire	[1:0]	
		.h2f_axi_awcache					( 								)	,	//	output	wire	[3:0]	
		.h2f_axi_awprot						( 								)	,	//	output	wire	[2:0]	
		.h2f_axi_awvalid					( h2f_axi_awvalid				)	,	//	output	wire			
		.h2f_axi_awready					( h2f_axi_awready				)	,	//	input	wire			
		.h2f_axi_wid						( 								)	,	//	output	wire	[11:0]	
		.h2f_axi_wdata						( h2f_axi_wdata					)	,	//	output	wire	[31:0]	
		.h2f_axi_wstrb						( h2f_axi_wstrb					)	,	//	output	wire	[3:0]	
		.h2f_axi_wlast						( h2f_axi_wlast					)	,	//	output	wire			
		.h2f_axi_wvalid						( h2f_axi_wvalid				)	,	//	output	wire			
		.h2f_axi_wready						( h2f_axi_wready				)	,	//	input	wire			
		.h2f_axi_bid						( h2f_axi_bid					)	,	//	input	wire	[11:0]	
		.h2f_axi_bresp						( h2f_axi_bresp					)	,	//	input	wire	[1:0]	
		.h2f_axi_bvalid						( h2f_axi_bvalid				)	,	//	input	wire			
		.h2f_axi_bready						( h2f_axi_bready				)	,	//	output	wire			
		.h2f_axi_arid						( h2f_axi_arid					)	,	//	output	wire	[11:0]	
		.h2f_axi_araddr						( h2f_axi_araddr				)	,	//	output	wire	[29:0]	
		.h2f_axi_arlen						( h2f_axi_arlen					)	,	//	output	wire	[3:0]	
		.h2f_axi_arsize						( 								)	,	//	output	wire	[2:0]	
		.h2f_axi_arburst					( 								)	,	//	output	wire	[1:0]	
		.h2f_axi_arlock						( 								)	,	//	output	wire	[1:0]	
		.h2f_axi_arcache					( 								)	,	//	output	wire	[3:0]	
		.h2f_axi_arprot						( 								)	,	//	output	wire	[2:0]	
		.h2f_axi_arvalid					( h2f_axi_arvalid				)	,	//	output	wire			
		.h2f_axi_arready					( h2f_axi_arready				)	,	//	input	wire			
		.h2f_axi_rid						( h2f_axi_rid					)	,	//	input	wire	[11:0]	
		.h2f_axi_rdata						( h2f_axi_rdata					)	,	//	input	wire	[31:0]	
		.h2f_axi_rresp						( h2f_axi_rresp					)	,	//	input	wire	[1:0]	
		.h2f_axi_rlast						( h2f_axi_rlast					)	,	//	input	wire			
		.h2f_axi_rvalid						( h2f_axi_rvalid				)	,	//	input	wire			
		.h2f_axi_rready						( h2f_axi_rready				)	,	//	output	wire			
		.pin_hps_io_emac0_inst_TX_CLK		( pin_hps_io_emac0_inst_TX_CLK	)	,	//	output	wire			
		.pin_hps_io_emac0_inst_TXD0			( pin_hps_io_emac0_inst_TXD0	)	,	//	output	wire			
		.pin_hps_io_emac0_inst_TXD1			( pin_hps_io_emac0_inst_TXD1	)	,	//	output	wire			
		.pin_hps_io_emac0_inst_TXD2			( pin_hps_io_emac0_inst_TXD2	)	,	//	output	wire			
		.pin_hps_io_emac0_inst_TXD3			( pin_hps_io_emac0_inst_TXD3	)	,	//	output	wire			
		.pin_hps_io_emac0_inst_RXD0			( pin_hps_io_emac0_inst_RXD0	)	,	//	input	wire			
		.pin_hps_io_emac0_inst_MDIO			( pin_hps_io_emac0_inst_MDIO	)	,	//	inout	wire			
		.pin_hps_io_emac0_inst_MDC			( pin_hps_io_emac0_inst_MDC		)	,	//	output	wire			
		.pin_hps_io_emac0_inst_RX_CTL		( pin_hps_io_emac0_inst_RX_CTL	)	,	//	input	wire			
		.pin_hps_io_emac0_inst_TX_CTL		( pin_hps_io_emac0_inst_TX_CTL	)	,	//	output	wire			
		.pin_hps_io_emac0_inst_RX_CLK		( pin_hps_io_emac0_inst_RX_CLK	)	,	//	input	wire			
		.pin_hps_io_emac0_inst_RXD1			( pin_hps_io_emac0_inst_RXD1	)	,	//	input	wire			
		.pin_hps_io_emac0_inst_RXD2			( pin_hps_io_emac0_inst_RXD2	)	,	//	input	wire			
		.pin_hps_io_emac0_inst_RXD3			( pin_hps_io_emac0_inst_RXD3	)	,	//	input	wire			
		.pin_hps_io_sdio_inst_CMD			( pin_hps_io_sdio_inst_CMD		)	,	//	inout	wire			
		.pin_hps_io_sdio_inst_D0			( pin_hps_io_sdio_inst_D0		)	,	//	inout	wire			
		.pin_hps_io_sdio_inst_D1			( pin_hps_io_sdio_inst_D1		)	,	//	inout	wire			
		.pin_hps_io_sdio_inst_CLK			( pin_hps_io_sdio_inst_CLK		)	,	//	output	wire			
		.pin_hps_io_sdio_inst_D2			( pin_hps_io_sdio_inst_D2		)	,	//	inout	wire			
		.pin_hps_io_sdio_inst_D3			( pin_hps_io_sdio_inst_D3		)	,	//	inout	wire			
		.pin_hps_io_uart0_inst_RX			( pin_hps_io_uart0_inst_RX		)	,	//	input	wire			
		.pin_hps_io_uart0_inst_TX			( pin_hps_io_uart0_inst_TX		)	,	//	output	wire			
		.pin_hps_io_i2c0_inst_SDA			( pin_hps_io_i2c0_inst_SDA		)	,	//	inout	wire			
		.pin_hps_io_i2c0_inst_SCL			( pin_hps_io_i2c0_inst_SCL		)	,	//	inout	wire			
		.pin_hps_io_gpio_inst_GPIO20		( pin_hps_io_gpio_inst_GPIO20	)	,	//	inout	wire			
		.pin_hps_io_gpio_inst_GPIO21		( pin_hps_io_gpio_inst_GPIO21	)	,	//	inout	wire			
		.pin_hps_io_gpio_inst_GPIO23		( pin_hps_io_gpio_inst_GPIO23	)	,	//	inout	wire			
		.pin_hps_io_gpio_inst_GPIO51		( pin_hps_io_gpio_inst_GPIO51	)	,	//	inout	wire			
		.pin_hps_io_gpio_inst_GPIO52		( pin_hps_io_gpio_inst_GPIO52	)	,	//	inout	wire			
		.pin_hps_io_gpio_inst_GPIO57		( pin_hps_io_gpio_inst_GPIO57	)	,	//	inout	wire			
		.pin_hps_io_gpio_inst_GPIO58		( pin_hps_io_gpio_inst_GPIO58	)	,	//	inout	wire			
		.pin_hps_io_gpio_inst_GPIO63		( pin_hps_io_gpio_inst_GPIO63	)	,	//	inout	wire			
		.pin_hps_io_gpio_inst_GPIO64		( pin_hps_io_gpio_inst_GPIO64	)	,	//	inout	wire			
		.pin_hps_ddr_mem_a					( pin_hps_ddr_mem_a				)	,	//	output	wire	[14:0]	
		.pin_hps_ddr_mem_ba					( pin_hps_ddr_mem_ba			)	,	//	output	wire	[2:0]	
		.pin_hps_ddr_mem_ck					( pin_hps_ddr_mem_ck			)	,	//	output	wire			
		.pin_hps_ddr_mem_ck_n				( pin_hps_ddr_mem_ck_n			)	,	//	output	wire			
		.pin_hps_ddr_mem_cke				( pin_hps_ddr_mem_cke			)	,	//	output	wire			
		.pin_hps_ddr_mem_cs_n				( pin_hps_ddr_mem_cs_n			)	,	//	output	wire			
		.pin_hps_ddr_mem_ras_n				( pin_hps_ddr_mem_ras_n			)	,	//	output	wire			
		.pin_hps_ddr_mem_cas_n				( pin_hps_ddr_mem_cas_n			)	,	//	output	wire			
		.pin_hps_ddr_mem_we_n				( pin_hps_ddr_mem_we_n			)	,	//	output	wire			
		.pin_hps_ddr_mem_reset_n			( pin_hps_ddr_mem_reset_n		)	,	//	output	wire			
		.pin_hps_ddr_mem_dq					( pin_hps_ddr_mem_dq			)	,	//	inout	wire	[31:0]	
		.pin_hps_ddr_mem_dqs				( pin_hps_ddr_mem_dqs			)	,	//	inout	wire	[3:0]	
		.pin_hps_ddr_mem_dqs_n				( pin_hps_ddr_mem_dqs_n			)	,	//	inout	wire	[3:0]	
		.pin_hps_ddr_mem_odt				( pin_hps_ddr_mem_odt			)	,	//	output	wire			
		.pin_hps_ddr_mem_dm					( pin_hps_ddr_mem_dm			)	,	//	output	wire	[3:0]	
		.pin_hps_ddr_oct_rzqin				( pin_hps_ddr_oct_rzqin			)	,	//	input	wire			
		.rst_axi_reset						( axi_rst						)	);	//	output	wire			
		
	registers registers_inst (
		.axi_clk							( axi_clk						)	,	//	input					
		.h2f_axi_awid						( h2f_axi_awid					)	,	//	input			[11:0]	
		.h2f_axi_awaddr						( h2f_axi_awaddr				)	,	//	input			[29:0]	
		.h2f_axi_awvalid					( h2f_axi_awvalid				)	,	//	input					
		.h2f_axi_awready					( h2f_axi_awready				)	,	//	output					
		.h2f_axi_wdata						( h2f_axi_wdata					)	,	//	input			[31:0]	
		.h2f_axi_wstrb						( h2f_axi_wstrb					)	,	//	input			[3:0]	
		.h2f_axi_wlast						( h2f_axi_wlast					)	,	//	input					
		.h2f_axi_wvalid						( h2f_axi_wvalid				)	,	//	input					
		.h2f_axi_wready						( h2f_axi_wready				)	,	//	output					
		.h2f_axi_bid						( h2f_axi_bid					)	,	//	output			[11:0]	
		.h2f_axi_bresp						( h2f_axi_bresp					)	,	//	output			[1:0]	
		.h2f_axi_bvalid						( h2f_axi_bvalid				)	,	//	output					
		.h2f_axi_bready						( h2f_axi_bready				)	,	//	input					
		.h2f_axi_arid						( h2f_axi_arid					)	,	//	input			[11:0]	
		.h2f_axi_araddr						( h2f_axi_araddr				)	,	//	input			[29:0]	
		.h2f_axi_arlen						( h2f_axi_arlen					)	,	//	input			[3:0]	
		.h2f_axi_arvalid					( h2f_axi_arvalid				)	,	//	input					
		.h2f_axi_arready					( h2f_axi_arready				)	,	//	output					
		.h2f_axi_rid						( h2f_axi_rid					)	,	//	output			[11:0]	
		.h2f_axi_rdata						( h2f_axi_rdata					)	,	//	output			[31:0]	
		.h2f_axi_rresp						( h2f_axi_rresp					)	,	//	output			[1:0]	
		.h2f_axi_rlast						( h2f_axi_rlast					)	,	//	output					
		.h2f_axi_rvalid						( h2f_axi_rvalid				)	,	//	output					
		.h2f_axi_rready						( h2f_axi_rready				)	,	//	input					
		.reg_fpga_rev						( reg_fpga_rev					)	,	//	input			[31:0]	
		.reg_sw1_4							( reg_sw1_4						)	,	//	input					
		.reg_sw1_3							( reg_sw1_3						)	,	//	input					
		.reg_sw1_2							( reg_sw1_2						)	,	//	input					
		.reg_sw1_1							( reg_sw1_1						)	,	//	input					
		.reg_jp3_4							( reg_jp3_4						)	,	//	output					
		.reg_jp3_3							( reg_jp3_3						)	,	//	output					
		.reg_jp3_2							( reg_jp3_2						)	,	//	output					
		.reg_jp3_1							( reg_jp3_1						)	,	//	output					
		.reg_led_8							( reg_led_8						)	,	//	output					
		.reg_led_7							( reg_led_7						)	,	//	output					
		.reg_led_6							( reg_led_6						)	,	//	output					
		.reg_led_5							( reg_led_5						)	,	//	input					
		.reg_jp5							( reg_jp5						)	,	//	output			[20:1]	
		.reg_jp4_rxn						( reg_jp4_rxn					)	,	//	output			[6:1]	
		.reg_jp4_rxp						( reg_jp4_rxp					)	,	//	output			[6:1]	
		.reg_jp4_txn						( reg_jp4_txn					)	,	//	output			[6:1]	
		.reg_jp4_txp						( reg_jp4_txp					)	,	//	output			[6:1]	
		.axi_rst							( axi_rst						)	);	//	input					
		
endmodule
