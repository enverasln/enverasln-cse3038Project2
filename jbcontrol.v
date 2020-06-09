module jbcontrol(jbout, jb_signals,status_signals);
input [2:0] jb_signals, status_signals;
output [1:0] jbout;
reg [1:0] jbout;

always @(jb_signals or status_signals)
begin
    if((~jb_signals[2] & ~jb_signals[1] & ~jb_signals[0]) & status_signals[2])
    begin
        jbout = 2'b01;
    end
    else if((~jb_signals[2] & ~jb_signals[1] & jb_signals[0]) & status_signals[1])
    begin
        jbout = 2'b01;
    end
    else if((~jb_signals[2] & jb_signals[1] & ~jb_signals[0]) & status_signals[1])
    begin
        jbout = 2'b11;
    end
    else if((jb_signals[2] & ~jb_signals[1] & ~jb_signals[0]))
    begin
        jbout = 2'b10;
    end
    else if((jb_signals[2] & ~jb_signals[1] & jb_signals[0]))
    begin
        jbout = 2'b10;
    end
    else
    begin
        jbout = 2'b00;
    end
end
endmodule