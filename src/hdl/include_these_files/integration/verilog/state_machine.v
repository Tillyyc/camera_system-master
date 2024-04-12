module prediction_state_machine(clk, reset, game_outcome, predict);

    input reset, clk;
    input game_outcome;
    output predict;

    parameter [1:0] strong_np = 2'b00, weak_np = 2'b01, weak_p = 2'b10, strong_p = 2'b11;

    parameter win = 1'b1, loss = 1'b0;

    reg [1:0] curr_state, next_state;

    always @(curr_state, game_outcome)
        case(curr_state)
            strong_np:  if(game_outcome == win) next_state = weak_np;
                        else next_state = strong_np;
            weak_np:    if(game_outcome == win) next_state = weak_p;
                        else next_state = strong_np;
            weak_p:     if(game_outcome == win) next_state = strong_p;
                        else next_state = strong_np;
            strong_p:   if(game_outcome == win) next_state = strong_p;
                        else next_state = weak_np;
        endcase
    
    always @(posedge clk)
        if(reset) curr_state <= strong_np;
        else curr_state <= next_state;
    
    assign predict = (curr_state == strong_p || curr_state == weak_p);

endmodule

module generate_prediction(clk, valid, game_outcome, next_prediction);
    input clk, valid;
    input [1:0] game_outcome;
    
    parameter [1:0] rock = 2'b10, paper = 2'b01, scissors = 2'b00;

    output [1:0] next_prediction;
    
    reg [1:0] history [2:0];
    (* ram_style = "distributed" *) reg [1:0] prediction_table [63:0];

    reg [1:0] curr_symbol;
    reg [1:0] answer;
    wire [5:0] prediction_table_index_1;
    wire [5:0] prediction_table_index_2;
    
    assign prediction_table_index_1 = {history[2], history[1], history[0]};
    assign prediction_table_index_2 = {game_outcome, history[2], history[1]};
    
    always @(posedge clk)
        if(valid)
        begin
            history[0] <= history[1];
            history[1] <= history[2];
            history[2] <= game_outcome;
        end
    
    always @(game_outcome)
    begin
        if(game_outcome == rock)
            answer = paper;
        else if(game_outcome == paper)
            answer = scissors;
        else
            answer = rock;
    
    end
    
    always @(posedge clk)
        if(valid)
            prediction_table[prediction_table_index_1] <= game_outcome;

    assign next_prediction = prediction_table[prediction_table_index_2];
    
endmodule



module fibonacci_lfsr0(clk, reset, valid, out);
  
    input clk, reset, valid;
    reg [7:0] data;
    
    output out;
    
    assign out = data[6];

    wire feedback = data[7] ^ data[3] ^ data[2] ^ data[1];

    always @(posedge clk)
        if (reset) 
            data <= 4'hf;
        else if(valid)
            data <= {data[6:0], feedback};
        else
            data <= data;

endmodule

module fibonacci_lfsr1(clk, reset, valid, out);
  
    input clk, reset, valid;
    output out;
    
    reg [6:0] data;
    
    assign out = data[6];

    wire feedback = data[6] ^ data[5] ^ data[2] ^ data[1] ^ data[0];

    always @(posedge clk)
        if (reset) 
            data <= 4'hf;
        else if(valid)
            data <= {data[5:0], feedback};
        else data <= data;

endmodule



module lfsr0 (output reg[31:0] LFSRregister, input clk);

    parameter seed = 32'b1;
    // initially register will contain seed value
    initial begin
        LFSRregister = seed;
    end

    // at edge of each clock pulse, shift and XOR required bits
    always @(posedge clk) begin
        LFSRregister = LFSRregister << 1;
        LFSRregister[0] = LFSRregister[31] ^ LFSRregister[29] ^ LFSRregister[25] ^ LFSRregister[24];
    end
endmodule

module lfsr1 (output reg[31:0] LFSRregister, input clk);

    parameter seed = 32'd7;
    // initially register will contain seed value
    initial begin
        LFSRregister = seed;
    end

    // at edge of each clock pulse, shift and XOR required bits
    always @(posedge clk) begin
        LFSRregister = LFSRregister << 1;
        LFSRregister[0] = LFSRregister[31] ^ LFSRregister[29] ^ LFSRregister[25] ^ LFSRregister[24];
    end
endmodule



module game_master(clk, reset, valid, player_gesture, go, winner, computer_gesture);

    input clk, reset, valid, go;
    input [1:0] player_gesture;
    output reg [1:0] winner;
    output [1:0] computer_gesture;
    
    reg [1:0] player_score, player_score_reg;
    reg [1:0] computer_score, computer_score_reg;
    
    parameter [2:0] round1 = 3'b000, wait1 = 3'b001, round2 = 3'b010, wait2 = 3'b011, round3 = 3'b100, 
                    results = 3'b101;
                    
    parameter [1:0] rock = 2'b10, paper = 2'b01, scissors = 2'b00;
    
    parameter [1:0] player = 2'b01, computer = 2'b10, neither = 2'b11;
    
    
    reg [2:0] current_state, next_state;
    
    wire [31:0] out0;
    wire predict;
    
    lfsr0 bit0(out0, clk);
    //lfsr1 bit1(out1, clk);
    
    wire [1:0] mod0;
    
    assign mod0 = out0 % 3;
    
    
    //wire [1:0] computer_gesture;
    
    wire [1:0] next_prediction;
    
    prediction_state_machine u1(clk, reset, outcome(player_gesture, computer_gesture), predict);
    
    generate_prediction u2(clk, valid, player_gesture, next_prediction);
    
    
    assign computer_gesture = (predict) ? next_prediction : mod0;
    
    function outcome;
        input [1:0] player_gesture, computer_gesture;
        begin
            case(computer_gesture)
            rock:   if(player_gesture == paper) outcome = 1;
                    else outcome = 0;
            paper:  if(player_gesture == scissors) outcome = 1;
                    else outcome = 0;
            scissors:   if(player_gesture == rock) outcome = 1;
                    else outcome = 0;
            default: outcome = 0;
            endcase     
        end
    endfunction
    
    
    always @(current_state, valid, go, computer_gesture, player_score, computer_score, player_gesture, player_score_reg, computer_score_reg)
        case(current_state)
            round1:
            begin
                if(valid && outcome(player_gesture, computer_gesture) == 1)
                    player_score_reg = player_score + 1;
                else
                    player_score_reg = player_score;
                //do same but for pc
                if(valid && outcome(computer_gesture, player_gesture) == 1)
                    computer_score_reg = computer_score + 1;
                else
                    computer_score_reg = computer_score;
                if(valid)
                    next_state = wait1;
                else
                    next_state = current_state;
                winner = 0;
            end
            wait1:
            begin
                if(go)
                    next_state = round2;
                else
                    next_state = wait1;
                winner = 0;
                player_score_reg = player_score;
                computer_score_reg = computer_score;           
            end
            round2:
            begin
                if(valid && outcome(player_gesture, computer_gesture) == 1)
                    player_score_reg = player_score + 1;
                else
                    player_score_reg = player_score;
                if(valid && outcome(computer_gesture, player_gesture) == 1)
                    computer_score_reg = computer_score + 1;
                else
                    computer_score_reg = computer_score;
                if(player_score_reg == 2 || computer_score_reg == 2)
                    next_state = results;
                else
                begin
                    if(valid)
                        next_state = wait2;
                    else
                        next_state = current_state;
                end
                winner = 0;
            end
            wait2:
            begin
                if(go)
                    next_state = round3;
                else
                    next_state = wait2;
                winner = 0; 
                player_score_reg = player_score;
                computer_score_reg = computer_score;          
            end
            round3:
            begin
                if(valid && outcome(player_gesture, computer_gesture) == 1)
                    player_score_reg = player_score + 1;
                else
                    player_score_reg = player_score;
                if(valid && outcome(computer_gesture, player_gesture) == 1)
                    computer_score_reg = computer_score + 1;
                else
                    computer_score_reg = computer_score;
                if(valid)
                    next_state = results;
                else
                    next_state = round3;
                winner = 0;
            end
            results:
            begin
                if(player_score > computer_score)
                    winner = player;
                else if(computer_score > player_score)
                    winner = computer;
                else
                    winner = neither;
                next_state = results;
                player_score_reg = player_score;
                computer_score_reg = computer_score;
            end
            default:
            begin
                next_state = round1;
                winner = 0;
                player_score_reg = player_score;
                computer_score_reg = computer_score;
            end
        endcase
        
    always @(posedge clk)
        if(reset)
        begin
            player_score <= 0;
            computer_score <= 0;
            current_state <= round1;
        end
        else
        begin
            current_state <= next_state;
            player_score <= player_score_reg;
            computer_score <= computer_score_reg;
        end
    
endmodule

 
   
   





