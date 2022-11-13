module tb_spi();

    parameter T                     = 20;               // a FPGA clock period
    parameter DATA_TRANSMIT_WIDTH   = 5'd8;             // bit_width of datas 
    parameter DATA_RECEIVE_WIDTH    = 5'd12;            // bit_width of datas 
    parameter SYS_FRE               = 50_000_000;       // system clock frequency
    parameter SPI_FRE               = 1_000_000;        // spi clock frequency
    parameter DIV_FRE_FACTOR        = SYS_FRE/SPI_FRE/2;  // sys_clk divide parameter

    reg                             sys_clk;
    reg                             sys_rst_n;
    reg                             spi_start; 
    reg                             spi_miso;    
    reg  [2:0]                      addr;

    wire  [DATA_RECEIVE_WIDTH-1:0]  data_receive;
    wire                            spi_cs;
    wire                            spi_sck;

    wire                            spi_mosi;
    reg  [DATA_RECEIVE_WIDTH-1:0]   spi_miso_data;

    initial begin  
        for(integer i=0; i<=20000; i=i+1) 
            #10 sys_clk = ~sys_clk;
    end

    initial begin
        sys_clk          = 1'b0;
        sys_rst_n        = 1'b1;
        #(T*3) sys_rst_n = 1'b0;
        #(T*3) sys_rst_n = 1'b1;
    end

    initial begin
            spi_start = 1'b0; 
        #(6*T)
        #(2*T*DIV_FRE_FACTOR)
            spi_start = 1'b1;                   
        #(300*T*DIV_FRE_FACTOR)   
            spi_start = 1'b0; 
    end

    initial begin
                           addr <= 3'b100;
    #(50*T*DIV_FRE_FACTOR) addr <= 3'b100;
    #(50*T*DIV_FRE_FACTOR) addr <= 3'b101;
    #(50*T*DIV_FRE_FACTOR) addr <= 3'b110;
    #(50*T*DIV_FRE_FACTOR) addr <= 3'b111;
        
    end

    // needed to be finished
    initial begin
        spi_miso = 1'b0; 
        spi_miso_data <= 12'b1000_0000_1111;
        #(20.25*T*DIV_FRE_FACTOR)           spi_miso = spi_miso_data[11]; // 11bit
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[10]; 
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[9]; 
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[8]; 
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[7]; 
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[6]; 
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[5]; 
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[4]; 
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[3]; 
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[2]; // 2 bit  
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[1]; // 1 bit
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[0]; // 0 bit
        #(4*T*DIV_FRE_FACTOR)               spi_miso = 1'b0; 

        spi_miso_data <= 12'b1000_0000_1111;
        #(16*T*DIV_FRE_FACTOR)              spi_miso = spi_miso_data[11];
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[10]; 
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[9]; 
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[8]; 
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[7]; 
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[6]; 
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[5]; 
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[4]; 
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[3]; 
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[2]; // 2 bit  
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[1]; // 1 bit 
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[0]; // 0 bit
        #(4*T*DIV_FRE_FACTOR)               spi_miso = 1'b0; 

        spi_miso_data <= 12'b1000_0011_1111;
        #(16*T*DIV_FRE_FACTOR)              spi_miso = spi_miso_data[11];
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[10]; 
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[9]; 
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[8]; 
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[7]; 
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[6]; 
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[5]; 
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[4]; 
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[3]; 
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[2]; // 2 bit  
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[1]; // 1 bit 
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[0]; // 0 bit
        #(4*T*DIV_FRE_FACTOR)               spi_miso = 1'b0; 

        spi_miso_data <= 12'b1000_1111_1111;
        #(16*T*DIV_FRE_FACTOR)              spi_miso = spi_miso_data[11];
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[10]; 
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[9]; 
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[8]; 
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[7]; 
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[6]; 
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[5]; 
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[4]; 
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[3]; 
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[2]; // 2 bit  
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[1]; // 1 bit 
        #(4*T*DIV_FRE_FACTOR)               spi_miso = spi_miso_data[0]; // 0 bit
        #(4*T*DIV_FRE_FACTOR)               spi_miso = 1'b0; 
    end

    spi #(
        .DATA_TRANSMIT_WIDTH    (DATA_TRANSMIT_WIDTH),
        .DATA_RECEIVE_WIDTH     (DATA_RECEIVE_WIDTH),
        .SYS_FRE                (SYS_FRE),
        .SPI_FRE                (SPI_FRE)
    ) inst_spi (
        .sys_clk                (sys_clk),
        .sys_rst_n              (sys_rst_n),
        .spi_start              (spi_start),
        .spi_miso               (spi_miso),
        .addr                   (addr),

        .data_receive           (data_receive),
        .spi_cs                 (spi_cs),
        .spi_sck                (spi_sck),
        .spi_mosi               (spi_mosi)
    );

    initial 
        $vcdpluson();

    initial begin
        $fsdbDumpfile("spi.fsdb");
        $fsdbDumpvars(0);
    end

endmodule