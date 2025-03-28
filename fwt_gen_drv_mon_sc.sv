//Generator-Driver-Monitor-Scoreboard-style testbench implementation
//fwt: four_way_traffic

import states::*;
//Transaction class
class fwt_transaction;
    rand bit rst;
    randc state_t init_state;
    logic [1:0] n_lights, s_lights, e_lights, w_lights;
endclass


//Interface
interface fwt_if(input bit clk);
    bit rst;
    state_t init_state;
    logic [1:0] n_lights, s_lights, e_lights, w_lights;
endinterface


//Generator class
class fwt_generator;
    mailbox #(fwt_transaction) gen2drv;
    fwt_transaction tr;
    
    function new(mailbox #(fwt_transaction) m);
        gen2drv = m;
    endfunction

    task run();
        repeat (10) begin
            tr = new();
            if (!tr.randomize()) 
                $fatal(1, "Randomization failed!");
            $display("[GEN] Generated reset: %b, initial state: %s", 
                 tr.rst, tr.init_state.name());
            gen2drv.put(tr);
            #10; // Delay before next transaction
        end
    endtask
endclass


//Driver class
class fwt_driver;
    virtual fwt_if vif;
    mailbox #(fwt_transaction) drv_mbox;
    fwt_transaction tr;
    
    function new(mailbox #(fwt_transaction) m, virtual fwt_if vif);
        drv_mbox = m;
        this.vif = vif;
    endfunction

    task run();
        forever begin
            drv_mbox.get(tr);
            vif.rst = tr.rst;
            vif.init_state = tr.init_state;          
            $display("[DRV] Driven to DUT: reset: %b, initial state: %s", vif.rst, vif.init_state.name());
            #10; //#5; // Apply reset for a few cycles
            //vif.rst = 0;
        end
    endtask
endclass


//Monitor class
class fwt_monitor;
    virtual fwt_if vif;
    mailbox #(fwt_transaction) mon2scb;
    fwt_transaction tr;
    function new(mailbox #(fwt_transaction) m, virtual fwt_if vif);
        mon2scb = m;
        this.vif = vif;
    endfunction

    task run();
        forever begin
            tr = new();
            tr.n_lights = vif.n_lights;
            tr.s_lights = vif.s_lights;
            tr.e_lights = vif.e_lights;
            tr.w_lights = vif.w_lights;
            $display("[MON] Received N_lights: %b, s_lights: %b, e_lights:%b, w_lights:%b", tr.n_lights, tr.s_lights, tr.e_lights, tr.w_lights);
            #10; 
            mon2scb.put(tr);
        end
    endtask
endclass


//Scoreboard class
class fwt_scoreboard;
    mailbox #(fwt_transaction) mon_mbox;
    fwt_transaction tr;
    function new(mailbox #(fwt_transaction) m);
        mon_mbox = m;
    endfunction

    task run();
        forever begin
            mon_mbox.get(tr);
            if (tr.n_lights == 2'b10)
                $display("[SCB] North Green detected.");
            else if (tr.n_lights == 2'b01)
                $display("[SCB] North Yellow detected.");
            else if (tr.s_lights == 2'b10)
                $display("[SCB] South Green detected.");
            else if (tr.s_lights == 2'b01)
                $display("[SCB] South Yellow detected.");
            else if (tr.e_lights == 2'b10)
                $display("[SCB] East Green detected.");
            else if (tr.e_lights == 2'b01)
                $display("[SCB] East Yellow detected.");
            else if (tr.w_lights == 2'b10)
                $display("[SCB] West Green detected.");
            else if (tr.w_lights == 2'b01)
                $display("[SCB] West Yellow detected.");
            #10;
        end
    endtask
endclass


module four_way_traffic_tb;
    bit clk = 0;
    always #5 clk = ~clk;

    // Interface instance
    fwt_if tb_if (clk);

    // DUT instance
    four_way_traffic dut (
        .clk(tb_if.clk), .rst(tb_if.rst),
        .start_state(tb_if.init_state),
        .n_lights(tb_if.n_lights), .s_lights(tb_if.s_lights),
        .e_lights(tb_if.e_lights), .w_lights(tb_if.w_lights)
    );

    // Mailboxes for communication
    mailbox #(fwt_transaction) gen2drv = new();
    mailbox #(fwt_transaction) mon2scb = new();

    // Testbench components
    fwt_generator gen = new(gen2drv);
    fwt_driver drv = new(gen2drv, tb_if);
    fwt_monitor mon = new(mon2scb, tb_if);
    fwt_scoreboard scb = new(mon2scb);

    initial begin
        $display("Starting Traffic Light FSM Testbench...");
        
        fork
            gen.run();
            drv.run();
            mon.run();
            scb.run();
        join_none

        #200 $finish;
    end
endmodule

