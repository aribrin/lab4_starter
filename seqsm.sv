module seqsm 
   (
// TODO: define your outputs and inputs
    input logic clk,
    input logic rst
      
    
    );


   // TODO: define your states
   // TODO: here is one suggestion, but you can implmenet any number of states
   // TODO: you like
    typedef enum {
               	 Idle, LoadPreamble, LoadTaps, LoadSeed, InitLFSR, 
            		 ProcessPreamble, Encrypt, Done
            	    } states_t;
   // TODO: for example
   // TODO:  1: Idle -> 
   // TODO:  2: LoadPreamble (read the preamble from the ROM and capture it in some registers) ->
   // TODO:  3: LoadTaps (read the taps from the ROM and capture it in some registers) ->
   // TODO:  4: LoadSeed (read the seed from the ROM and capture it in some registers) ->
   // TODO:  5: InitLFSR (load the LFSR with the taps and seed) ->
   // TODO:  6: ProcessPremble (encrypt preamble until byteCount is the same as preamble length) ->
   // TODO:  7: Encrypt rest of packet until byteCount == 32 (max packet length)
   // TODO:  8: Done
   // TODO:
   // TODO: implement your state machine
   // TODO:
   // TODO: sequential part
   
   state_t curState;
   state_t nxtState;
   
    always_ff @(posedge clk) 
    begin 
      if (rst)
         curState <= Idle;
      else
         curState <= nxtState;
    end
   // TODO:
   always_comb begin
      unique case (curState)
         Idle : begin
            if(loadPreamble)
               nxtState = LoadPreamble;
            else
               nxtState = Idle;
         end
         
      endcase
    end
   
endmodule // seqsm
