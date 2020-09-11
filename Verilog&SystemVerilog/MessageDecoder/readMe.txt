Please find the attached state machine diagram in the same directory with the file name: FSM.png

The first key requirement of Avalon streaming interface slave is that the "in_ready" line must be high when the slave isn’t busy. This keeps us from suffering from a stall signal when a read request is made. The transaction then starts with the data request, as indicated by "in_valid" & "in_startofpayload". In transaction mode (TRANS state), the data is received until "in_ready" signal becomes low and the state is changed to HOLD. "in_valid" effectively goes low but as soon as "in_ready" is reasserted, the state is changed again back to TRANS. Only after reception of "in_endofpayload" END state is achieved marking end of the transaction which effectively changes to IDLE with "in_ready" signal.

Please find the attached code in the same directory with names msgDecoder.sv & msgDecoder_tb.sv for source and testbench respectively. The vivado project is included as well MessageDecoder.tar.gz. Intermediate Versions of code, References the FSM and also the Waveform can be found out in the directory. 

Trade-offs of the design: It takes a few cycles to compute the msg length and detect a msg but that is mandatory given the problem statement. That wil add to the latency and the interval. It was a bit convoluted to implement and hard to recode/repair but I can safely say that it is the best scenario amongst my alternative approaches.(One can find the Intermediate approaches in the folder: IntermediateVersions) I tried writing the statemachine for the message encoding but it took more clock cycles and the complexity rose going forward. I also tried another approach of using a buffer in between but then data is coming at every clock cycle and getting the data serially can lead to massive delays. I also thought of altering ready signal to reduce the load but due to ready latency= 1 that would anyway need some storage. According to me there was a clear tradeoff between memory and delays/time. I chose to utilise more memory as time is a crucial factor in similar data streaming platforms. Higher the size of payload, percentage of the latency almost the same. However memory requirement would increase.


*************************************************************************************************************************************************************************************************************************************************

FPGA_Engineer_Assignment.pdf        : Problem Statement 
FSM.png                             : Finite State Machine
input.txt                           : Input to the code
msgDecoder.sv                       : Source code 
msgDecoder_tb.sv                    : Testbench of source code
output.txt                          : Output from the code
Waveform.png                        : Waveform of the tesbench
