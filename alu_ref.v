module alu_ref #(parameter N=8)(
input [N-1:0] opa,
input [N-1:0] opb,
input cin,
input rst,
input ce,
input mode,
input [1:0] inp_valid,
input [(N/2)-1:0] cmd,
output reg [2*N-1:0] res,
output reg oflow,cout,g,e,l,err
);
always@(*) begin
    if(rst)
    begin
      res = {2*N{1'b0}};
        oflow = 1'b0;
        cout = 1'b0;
        g = 1'b0;
        e = 1'b0;
        l = 1'b0;
        err = 1'b0;
    end
    else
     begin
        if (!ce)
        begin
        res = {2*N{1'b0}};
          oflow = 1'b0;
         cout = 1'b0;
        g = 1'b0;
         e = 1'b0;
         l = 1'b0;
       err = 1'b0;
        end
        else
        if(mode)
        begin
           case(inp_valid)

                    2'b00: begin
                      res={2*N{1'b0}};
                        oflow = 1'b0;
                     cout = 1'b0;
                      g= 1'b0;
                     e = 1'b0;
                      l = 1'b0;
                      err = 1'b1;
                    end

                    2'b01: begin
                     oflow = 1'b0;
                     cout = 1'b0;
                      g = 1'b0;
                     e = 1'b0;
                     l = 1'b0;
                      err = 1'b0;
                    case(cmd)
                            4'd4:begin res= opa + 1'b1; cout=1'b0;  end
                            4'd5:begin  res= opa - 1'b1;cout=1'b0; end
                            default: begin res = {2*N{1'b0}}; err=1'b1;end
                        endcase
                    end
                    2'b10: begin
                     oflow = 1'b0;
                     cout = 1'b0;
                     g = 1'b0;
                     e = 1'b0;
                     l = 1'b0;
                     err = 1'b0;
                        case(cmd)
                            4'd6:begin res= opb + 1'b1;cout=1'b0; end
                            4'd7:begin res= opb - 1'b1; end
                            default:  begin res= {2*N{1'b0}}; err=1'b1; end
                        endcase
                    end
                    2'b11: begin
                     res= {2*N{1'b0}};
                     oflow = 1'b0;
                     cout = 1'b0;
                     g = 1'b0;
                     e = 1'b0;
                    l = 1'b0;
                     err = 1'b0;
                        case(cmd)

                            4'd0: begin
                               {cout, res[N-1:0]} = opa + opb;
                               res[2*N-1:N]={N-1{1'b0}};
                            end

                            4'd1: begin
                                res = opa - opb;
                                oflow = (opa < opb) ? 1'b1 : 1'b0;

                            end

                            4'd2: begin
                                {cout,res[N-1:0]} = opa + opb + cin;
                                res[2*N-1:N]={N-1{1'b0}};
                               // res<=temp;
                            end

                            4'd3: begin
                                res= opa - opb - cin;
                                oflow = (opa < opb) ? 1'b1 : 1'b0;
                                //res<=temp;
                            end

                            4'd4:begin res = opa + 1'b1; cout=1'b0; end
                            4'd5:begin res= opa - 1'b1;cout=1'b0;  end
                            4'd6:begin res= opb + 1'b1;cout=1'b0; end
                            4'd7:begin res= opb - 1'b1; end
                            4'd8: begin
                                if(opa > opb) begin
                                    g = 1'b1;
                                    e = 1'b0;
                                    l = 1'b0;
                                end
                                else if(opa == opb) begin
                                    g = 1'b0;
                                    e = 1'b1;
                                    l = 1'b0;
                                end
                                else begin
                                    g = 1'b0;
                                    e = 1'b0;
                                    l = 1'b1;
                                end

                            end
                            4'd9: begin
                                   res= (opa + 1'b1) * (opb + 1'b1);
                                  end
                            4'd10:begin
                                   res= (opa << 1) * opb;
                                   end
                             4'd11: begin
                                res= $signed(opa) + $signed(opb);
                                //res<=temp;
                                oflow = (opa[N-1] == opb[N-1]) && (opa[N-1] != res[N-1]);

                                if(opa > opb) begin
                                    g = 1'b1;
                                    e = 1'b0;
                                    l = 1'b0;
                                end
                                else if(opa == opb) begin
                                    g = 1'b0;
                                    e = 1'b1;
                                    l = 1'b0;
                                end
                                else begin
                                    g = 1'b0;
                                    e = 1'b0;
                                    l = 1'b1;
                                end

                            end
                            4'd12: begin
                                res= $signed(opa) - $signed(opb);
                               // res<=temp;
                                oflow = (opa[N-1] != opb[N-1]) && (opa[N-1] != res[N-1]);

                                if($signed(opa) > $signed(opb)) begin
                                    g = 1'b1;
                                    e = 1'b0;
                                    l = 1'b0;
                                end
                                else if($signed(opa) == $signed(opb)) begin
                                    g = 1'b0;
                                    e = 1'b1;
                                    l = 1'b0;
                                end
                                else begin
                                    g = 1'b0;
                                    e = 1'b0;
                                    l = 1'b1;
                                end
                            end

                            default:  begin res= {2*N{1'b0}}; err=1'b1; end

                        endcase
                    end

                    default:  begin res = {2*N{1'b0}}; err=1'b1;end

                endcase

            end
       else
           begin

                res= {2*N{1'b0}};
                oflow = 1'b0;
                cout = 1'b0;
                g = 1'b0;
                e = 1'b0;
                l = 1'b0;
                err = 1'b0;
                case(inp_valid)

                    2'b00: begin
                 res= {2*N{1'b0}};

                oflow = 1'b0;
                cout = 1'b0;
                g = 1'b0;
                e = 1'b0;
                l = 1'b0;
                err = 1'b1;
                    end

                    2'b01: begin
                        res = {2*N{1'b0}};

                        oflow = 1'b0;
                cout = 1'b0;
                g = 1'b0;
                e = 1'b0;
                l = 1'b0;
                err = 1'b0;
                        case(cmd)
                            4'd6: begin res={{N{1'b0}},~opa}; end
                            4'd8:begin res[N-1:0] = (opa >> 1); end
                            4'd9:begin res[N-1:0]= (opa << 1); end
                            default:  begin res= {2*N{1'b0}}; err=1'b1; end
                        endcase
                    end

                    2'b10: begin
                res= {2*N{1'b0}};
                oflow = 1'b0;
                cout = 1'b0;
                g = 1'b0;
                e = 1'b0;
                l = 1'b0;
                err = 1'b0;
                        case(cmd)
                           4'd7: begin res={{N{1'b0}},~opb}; end
                            4'd10:begin res[N-1:0]= (opb >> 1); end
                            4'd11:begin res[N-1:0]= (opb << 1); end
                            default: begin res= {2*N{1'b0}}; err=1'b1; end
                        endcase
                    end
                    2'b11: begin
    res= {2*N{1'b0}};

    oflow = 1'b0;
    cout  = 1'b0;
    g    = 1'b0;
    e     = 1'b0;
    l    = 1'b0;
    err   = 1'b0;

    case(cmd)

        4'd0: begin
            res= {{N{1'b0}}, opa & opb};

        end

        4'd1: begin
            res= {{N{1'b0}}, ~(opa & opb)};

        end

        4'd2: begin
            res= {{N{1'b0}}, (opa | opb)};
        end

        4'd3: begin
           res= {{N{1'b0}}, ~(opa | opb)};
        end

        4'd4: begin
            res = {{N{1'b0}}, (opa ^ opb)};
        end

        4'd5: begin
            res = {{N{1'b0}}, ~(opa ^ opb)};
        end
        4'd6: begin res ={{N{1'b0}},~opa}; end
        4'd8:begin res = (opa >> 1); end
      4'd9:begin res[N-1:0]= (opa << 1); end
       4'd7: begin res={{N{1'b0}},~opb}; end
        4'd10:begin res[N-1:0]= (opb >> 1); end
        4'd11:begin res[N-1:0]= (opb << 1); end
        4'd12: begin
            err = (|opb[7:4]) ? 1'b1 : 1'b0;

            case(opb[2:0])

                3'b000: begin
                    res = opa;
                end

                3'b001: begin
                   res = {{N{1'b0}}, opa[6:0], opa[7]};
                end

                3'b010: begin
                    res = {{N{1'b0}}, opa[5:0], opa[7:6]};
                end

                3'b011: begin
                    res= {{N{1'b0}}, opa[4:0], opa[7:5]};
                end

                3'b100: begin
                    res  = {{N{1'b0}}, opa[3:0], opa[7:4]};
                end

                3'b101: begin
                    res = {{N{1'b0}}, opa[2:0], opa[7:3]};
                end

                3'b110: begin
                    res  = {{N{1'b0}}, opa[1:0], opa[7:2]};
                end

                3'b111: begin
                    res= {{N{1'b0}}, opa[0], opa[7:1]};
                end

                default: begin
                    res = {2*N{1'b0}};
                end
            endcase
        end

        4'd13: begin
            err = (|opb[7:4]) ? 1'b1 : 1'b0;

            case(opb[2:0])

                3'b000: begin
                    res = opa;
                end

                3'b001: begin
                    res = {{N{1'b0}}, opa[0], opa[7:1]};
                end

                3'b010: begin
                    res = {{N{1'b0}}, opa[1:0], opa[7:2]};
                end

                3'b011: begin
                    res = {{N{1'b0}}, opa[2:0], opa[7:3]};
                end

                3'b100: begin
                    res = {{N{1'b0}}, opa[3:0], opa[7:4]};
                end

                3'b101: begin
                    res = {{N{1'b0}}, opa[4:0], opa[7:5]};
                end

                3'b110: begin
                    res = {{N{1'b0}}, opa[5:0], opa[7:6]};
                end

                3'b111: begin
                    res = {{N{1'b0}}, opa[6:0], opa[7]};
                end

                default: begin
                    res = {2*N{1'b0}};
                    err = 1'b1;
                end
            endcase
        end

        default: begin
            res = {2*N{1'b0}};
            err = 1'b1;
        end
                        endcase
                    end
        default: begin
              res= {2*N{1'b0}};
            err  = 1'b1;
        end
                endcase
            end
        end
    end


endmodule

