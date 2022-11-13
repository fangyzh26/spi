module spi #(
    parameter DATA_TRANSMIT_WIDTH   = 5'd8,         // bit_width of datas 
    parameter DATA_RECEIVE_WIDTH    = 5'd12,        // bit_width of datas 
    parameter SYS_FRE               = 50_000_000,   // system clock frequency
    parameter SPI_FRE               = 1_000_000     // spi clock frequency
    )
    (
    input                               sys_clk,
    input                               sys_rst_n,
    input                               spi_start,  
    input                               spi_miso,    
    input  [2:0]                        addr, // adc's channel selecting

    output  [DATA_RECEIVE_WIDTH-1:0]    data_receive,
    output                              spi_cs,
    output  reg                         spi_sck,
    output  reg                         spi_mosi
    );
 
    parameter DIV_FRE_FACTOR = SYS_FRE/SPI_FRE-1;      // sys_clk divide parameter

    reg                              receive_done;
    reg  [9:0]                       div_cnt;              // counting for dividing system clock
    reg  [9:0]                       spi_sck_edge_cnt;     // counting for spi_scl's posedge and negedge
    reg  [DATA_RECEIVE_WIDTH-1:0]    data_receive_temp;    // received data temporarily saving
    reg  [DATA_TRANSMIT_WIDTH-1:0]   data_transmit_temp;   // transmitting data temporarily saving
   
   
    //--- counting for dividing system frequency,preparing for spi_sck assignment -------------------------------
    always @(posedge sys_clk, negedge sys_rst_n) begin 
        if(!sys_rst_n)
            div_cnt <= 'd0; // div_cnt = 0 when spi_start = 0
        else if(spi_start) begin
            if(div_cnt == DIV_FRE_FACTOR)
                div_cnt <= 'd0;
            else 
                div_cnt <= div_cnt + 1'd1;
        end
        else 
            div_cnt <= 'd0;
    end


    //--- spi_cs assignment,depends on spi_start -----------------------------------------------------------------
    assign spi_cs = ~spi_start;


    //--- spi_sck assignment ---------------------------------------------------------------------------------------
     always @(posedge sys_clk, negedge sys_rst_n) begin
        if(!sys_rst_n)
            spi_sck <= 1'b1; // spi = 1 when in idle state
        else if(!spi_cs) begin
            if(div_cnt == DIV_FRE_FACTOR)
                spi_sck <= ~spi_sck;
            else 
                spi_sck <= spi_sck;
        end
        else 
            spi_sck <= 1'b1; // spi = 1 when in idle state
    end


    //--- the counting of spi_sck's (pos+neg)edge, preparing for transmitting data and receiving data -------------
    always @(posedge spi_sck,negedge spi_sck, negedge sys_rst_n) begin
        if(!sys_rst_n) 
            spi_sck_edge_cnt <= 10'd0;
        else if(!spi_cs) 
            if(spi_sck_edge_cnt ==  10'd31)
                spi_sck_edge_cnt <= 10'd0;
            else
                spi_sck_edge_cnt <= spi_sck_edge_cnt + 1'd1;
        else 
            spi_sck_edge_cnt <= 10'd0; 
    end 


    //--- transmitting data ----------------------------------------------------------------------------------------
    assign data_transmit_temp = (spi_sck_edge_cnt=='d0) ? {2'b11,addr,3'b111} : data_transmit_temp; //when cnt=0, get new transmitting data 

    always @(negedge spi_sck, negedge sys_rst_n) begin
        if(!sys_rst_n) 
            spi_mosi <= 1'b0;
        else if(!spi_cs && (spi_sck_edge_cnt<=2*(DATA_TRANSMIT_WIDTH-1)))  
            spi_mosi <= data_transmit_temp[DATA_TRANSMIT_WIDTH-1-(spi_sck_edge_cnt/2)];
        else
            spi_mosi <= 1'b0;          
    end

    //--- receiving data ---------------------------------------------------------------------------------------
    always @(posedge spi_sck, negedge sys_rst_n) begin
        if(!sys_rst_n) begin
            data_receive_temp   <= 'b0;
        end
        else if(!spi_cs && (spi_sck_edge_cnt>='d9) && (spi_sck_edge_cnt<='d32) )
            data_receive_temp[DATA_RECEIVE_WIDTH-1-(spi_sck_edge_cnt-10'd9)/2] <= spi_miso; 
        else
            data_receive_temp <= data_receive_temp;
    end
    assign data_receive = (spi_sck_edge_cnt=='d0) ? data_receive_temp : data_receive;

endmodule