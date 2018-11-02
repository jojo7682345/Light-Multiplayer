#define scr_player_move
///scr_player_move(sprint);
var b = argument0;
var secconds_passed = delta_time/1000000;
if(!keyboard_check(global.sprint)){
    b = 1;
}
var mspd = spd*secconds_passed*b;

xaxis = (keyboard_check(global.right) - keyboard_check(global.left));
yaxis = (keyboard_check(global.down) - keyboard_check(global.up));

var moving = (xaxis!=0||yaxis!=0);
if(moving){
    var dir = point_direction(0, 0, xaxis, yaxis);
    var xtarg = x+lengthdir_x(mspd, dir);
    var ytarg = y+lengthdir_y(mspd, dir);
    if(!place_meeting(xtarg, y, obj_solid)){
        x = xtarg;
    }
    if(!place_meeting(x, ytarg, obj_solid)){
        y = ytarg;
    }
}



#define scr_player_item
///scr_player_item();
if(drop_timer > 0){
 drop_timer -= gamemode.delta;
}
if(instance_exists(obj_item)){
                if(place_meeting(x, y, obj_item)){
                            var inst = instance_place(x, y, obj_item);
                            var item = inst.item_id;
                            if(total_items*ITEM_WEIGHT < ITEM_LIMIT && drop_timer <= 0){
                                inv[item-1]++;
                                total_items++;
                                with(client){
                                    buffer_seek(send_buffer, buffer_seek_start, 0);
                                    buffer_write(send_buffer, buffer_u8, M_ITEM_OBTAINED);
                                    buffer_write(send_buffer, buffer_u8, inst.itemID);
                                    network_send_raw(socket, send_buffer, buffer_tell(send_buffer));
                                    client_send_item(item-1, other.inv[other.selected]);
                                }
                                instance_destroy(inst);
                            }  

                    
                    
                        
                }
                }
                
if(keyboard_check_released(global.drop)){
    if(inv[selected] > 0){
        inv[selected]--;
        total_items--;
        drop_timer = 1;
        var item = instance_create(x, y, obj_item);
        item.image_angle = dir-90;
        item.item_id = selected+1;
        item.image_index = selected+1;
        with(client){
            buffer_seek(send_buffer, buffer_seek_start, 0);
            buffer_write(send_buffer, buffer_u8, M_ITEM_DROPPED);
            buffer_write(send_buffer, buffer_u8, item.item_id);
            buffer_write(send_buffer, buffer_u16, round(item.x));
            buffer_write(send_buffer, buffer_u16, round(item.y));
            buffer_write(send_buffer, buffer_u16, round(item.image_angle));
            network_send_raw(socket, send_buffer, buffer_tell(send_buffer));
        }
        with(client){
                    client_send_item(other.selected, other.inv[other.selected]);
                }
    }
}
                

#define scr_player_rotate
///scr_player_rotate();
var mdir = point_direction(x, y, mouse_x, mouse_y);
dir += sin(degtorad(mdir - dir))*tecstat.rspd*gamemode.delta;
            