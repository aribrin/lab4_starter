module seqsm 
   (
// TODO: define your outputs and inputs
    input logic clk,
    input logic rst
      
    input logic encRqst; //encrypt request
    input logic preDone; //preamble encrypted
    input logic validIn; //incoming byte valid
    input logic pacDone; //message encrypted, packet done
      
    output logic enPre; //enable signal to data path to get preammble length 
    output logic enTap; //enable signal load tap val
    output logic enSeed; //enable signal to load seed
    output logic getNext; //get next lfsr value
    output logic loadlfsr; //initialize lfsr
    output logic incReadAddr;
    output logic incByteCnt;
    
    output logic vilidOut;
    output logic done;
    
      
    
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
      
    enPre = 0; //enable signal to data path to get preammble length 
    enTap = 0; //enable signal load tap val
    enSeed = 0; //enable signal to load seed
    getNext = 0;
    loadlfsr = 0;
    incReadAddr = 0;
    incByteCnt = 0;
    
    vilidOut = 0;
    done = 0;
      
      unique case (curState)
         Idle : begin
            if(encRqst)
               nxtState = LoadPreamble;
            else
               nxtState = Idle;
         end
         
         LoadPreamble : begin
            enPre = 1;
            incReadAddr = 1;
            nxtState = LoadTaps;
         end
         
         LoadTaps : begin
            enTap = 1;
            incReadAddr = 1;
            nxtState = LoadSeed;
         end
         
         LoadSeed : begin
            enSeed = 1;
            incReadAddr = 1;
            nxtState = InitLFSR;
         end
               
         InitLFSR : begin
            loadlfsr = 1;
            nxtState = ProcessPreamble;
         end
               
         ProcessPreamble : begin
            if(!preDone) begin
               incByteCnt = 1;
               getNext = 1;
               nxtState = ProcessPreamble;
            end
            else
               nxtState = Encrypt;
         end
         
         Encrypt : begin
            if(!pacDone)begin
               incByteCnt = 1;
               getNext = 1;
               nxtState = ProcessPreamble;
            end
            else
               nxtState = Done;
         end
         
         Done : begin
            done = 1;
         end
      endcase
    end
   
endmodule // seqsm
