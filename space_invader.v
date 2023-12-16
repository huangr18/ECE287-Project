module space_invader(
    input clk,
    input rst,
	 input start,
	 input left,
	 input right,
	 output reg [9:0]player_x_pos,
	 output reg done
	 );

reg [6:0]S;
reg [6:0]NS;

parameter START = 7'd0,
			 START_GAME = 7'd1,
			 PLAYER_WIN = 7'd2,
			 ENEMY_WIN = 7'd3,
			 WIN = 7'd4,
			 GAME_OVER = 7'd5,
			 ERROR = 7'd6;

parameter width = 15,
			 height = 15,
			 i = 0;
			 
reg all_enemy_die = 0;
reg player_die = 0;
// reg start_draw_player = 0;
// draw player
// reg [9:0]player_x_pos;
// draw enemy
reg [7:0] score;
reg [9:0] enemy1_x_pos;
reg [9:0] enemy1_y_pos;
// draw player bullet
reg [9:0] p_bullet_x_pos;
reg [9:0] p_bullet_y_pos;

always @(*)
begin
	case (S)
		START:
		begin
			if (start == 1'b1)
				NS = START_GAME;
			else
				NS = START;
		end
		
		START_GAME:
		begin
			if (all_enemy_die)
				NS = WIN;
			else if (player_die)
				NS = GAME_OVER;
			else
				NS = START_GAME;
		end
		
		PLAYER_WIN: 
		if(done == 1'b1)
			NS = WIN;
		
		ENEMY_WIN: 
		if(done == 1'b1)
			NS = GAME_OVER;
		
		WIN:
		begin 
			if(start == 1'b1)
				NS = START;
			else
				NS = WIN;
		end
		
		GAME_OVER: 
		begin
				if(start == 1'b1)
				NS = START;
			else
				NS = WIN;
		end
		
		default NS = ERROR;
	endcase
end

always @(posedge clk or negedge rst)
begin
	if (rst == 1'b0)
	begin
		done = 1'b0;
		// draw_player
		player_x_pos = 320; 
		// draw_enemy
		enemy1_x_pos = 320; 
		enemy1_y_pos = 240;
		score = 0;
		// draw_bullet
		p_bullet_x_pos = 320;
		p_bullet_y_pos = 15;	
	end
	
	else
		case (S)
			START_GAME: 
			begin
			// draw_player
				if (~done) begin
					if ((left == 1) && (player_x_pos >= 15))
						player_x_pos = player_x_pos - 6;
					if ((right == 1) && (player_x_pos <= 625))
						player_x_pos = player_x_pos + 6;
					else if (player_x_pos >=625)
						player_x_pos = 625;
					else if (player_x_pos <=14)
						player_x_pos = 15;
				end
			// draw_player end
			
			//	draw_enemy
				if (~done) begin
					enemy1_x_pos = enemy1_x_pos - 1;
					if (enemy1_x_pos <= 14) 
					begin
						enemy1_x_pos = enemy1_x_pos + 1;
						
						if (enemy1_x_pos >=625)
						begin
							enemy1_y_pos = enemy1_y_pos - 1;
							score = score + 1;
							if (enemy1_y_pos <= 15)
							begin
								player_die = 1'b1;
							end
						end
					end
				end
			
			// draw_enemy end
			
			// draw bullet
				
			// draw bullet end
			
			end
			
			PLAYER_WIN: done = 1'b1;
			
			ENEMY_WIN: done = 1'b1;
		endcase
end

/* FSM init and NS always */
always @(posedge clk or negedge rst)
begin
	if (rst == 1'b0)
	begin
		S <= START;
	end
	else
	begin
		S <= NS;
	end
end

// write frame
/*frame write_frame(
	address,
	clock,
	data,
	wren,
	q);*/

// start drawing player
/*draw_player Draw_Player(.clk(clk),
								.rst(rst),
								.start_draw_player(start_draw_player),
								.done(done),
								.left(left),
								.right(right),
								.player_x_pos(player_x_pos));*/

			 
endmodule