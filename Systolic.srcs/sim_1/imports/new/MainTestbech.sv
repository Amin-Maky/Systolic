`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Am/148
// Engineer: AminMaky
// Dependencies: Not Completed ...
//////////////////////////////////////////////////////////////////////////////////

interface Systolic_Int #(parameter Num = 3, intop  = 8, inleft = 8)(input logic Clock, Reset);
    // Inputs
    logic LoudIn;
    logic [intop  - 1:0] LoudUp   [Num-1:0][Num-1:0];
    logic [inleft - 1:0] LoudLeft [Num-1:0][Num-1:0];

    // Output
    logic [(intop + inleft + Num) : 0] Result [Num - 1 : 0] [Num - 1 : 0];
    logic FinishLoudFlag;
    logic EndFlag;
endinterface

module MainTestbech;

    logic Reset;
    logic Clock;
    
    // Parameters
    parameter Num = 3;
    parameter intop  = 8;
    parameter inleft = 8;
    
    // Clock generation
    always #5 Clock = ~Clock;

    // Interface instance
    Systolic_Int #(.Num(Num), .intop(intop), .inleft(inleft)) Intf (.Clock(Clock), .Reset(Reset));
    
    // Instantiate the Unit Under Test (UUT)
    Datapath #(.Num(Num), .intop(intop), .inleft(inleft)) UUT (
        .Reset(Reset),
        .Clock(Clock),
        .LoudIn(Intf.LoudIn),
        .LoudUp(Intf.LoudUp),
        .LoudLeft(Intf.LoudLeft),
        .Result(Intf.Result),
        .FinishLoudFlag(Intf.FinishLoudFlag),
        .EndFlag(Intf.EndFlag)
    );
    
    task Generator(int num_tests);
    for (int i = 0; i < num_tests; i++) 
    begin
        int A[Num][Num];
        int B[Num][Num];
        int C_expected[Num][Num];
        @(posedge Clock);
        Intf.LoudIn = 1;
        
        for (int i = 0; i < Num; i++) begin
            for (int j = 0; j < Num; j++) begin
                A[i][j] = $urandom_range(0, 15);
                B[i][j] = $urandom_range(0, 15);
                Intf.LoudUp[i][j]    = A[i][j];
                Intf.LoudLeft[i][j]  = B[i][j];
            end
        end
        /*
        Intf.LoudUp[0][0] = $urandom();   Intf.LoudUp[0][1] = $urandom();   Intf.LoudUp[0][2] = $urandom();
        Intf.LoudUp[1][0] = $urandom();   Intf.LoudUp[1][1] = $urandom();   Intf.LoudUp[1][2] = $urandom();
        Intf.LoudUp[2][0] = $urandom();   Intf.LoudUp[2][1] = $urandom();   Intf.LoudUp[2][2] = $urandom();
        
        Intf.LoudLeft[0][0] = $urandom(); Intf.LoudLeft[0][1] = $urandom(); Intf.LoudLeft[0][2] = $urandom();
        Intf.LoudLeft[1][0] = $urandom(); Intf.LoudLeft[1][1] = $urandom(); Intf.LoudLeft[1][2] = $urandom();
        Intf.LoudLeft[2][0] = $urandom(); Intf.LoudLeft[2][1] = $urandom(); Intf.LoudLeft[2][2] = $urandom();
        */
        @(posedge Clock);
        Intf.LoudIn = 0; // and Start calculations
        
        for (int i = 0; i < Num; i++) begin
            for (int j = 0; j < Num; j++) begin
                C_expected[i][j] = 0;
                for (int k = 0; k < Num; k++) begin
                    C_expected[i][j] += A[i][k] * B[k][j];
                end
            end
        end

        wait(Intf.FinishLoudFlag == 0);
        wait(Intf.EndFlag == 1);
        
        Checker(C_expected);
    end
    endtask
    
    task Checker(int C_expected[Num][Num]);

    for (int i = 0; i < Num; i++) begin
        for (int j = 0; j < Num; j++) begin
            if (Intf.Result[i][j] !== C_expected[i][j]) begin
                $display("ERROR at [%0d][%0d]: Expected = %0d, Got = %0d", i, j, C_expected[i][j], Intf.Result[i][j]);
            end 
            else begin
                $display("OK at [%0d][%0d]: %0d", i, j, Intf.Result[i][j]);
            end
        end
    end
    
    
    endtask
    
    initial
    begin
        // Initial values and apply reset
        Clock = 0;
        Reset = 1;
        Intf.LoudIn = 0;

        // Clear LoudUp and LoudLeft
        for (int i = 0; i < Num; i++) begin
            for (int j = 0; j < Num; j++) begin
                Intf.LoudUp  [i][j] = 0;
                Intf.LoudLeft[i][j] = 0;
            end
        end

        // Reseting is finished
        @(posedge Clock);
        Reset = 0;

        // Load new values (3 x 3)
        Generator(10);
        $finish;
        
    end
    
    
    
endmodule
