#define client_connect
///client_connect(ip, port, type);
var ip = argument0,
port = argument1,
type = argument2;

socket = network_create_socket(type);
var connect = 0;
connect = network_connect_raw(socket, ip, port);
if(connect < 0){
    show_error("could not join the server", true);
}
send_buffer = buffer_create(256, buffer_fixed, 1);
gamemode.gamestate = mode.lobby;
clients = ds_grid_create(MAX_CLIENTS, 2);
ds_grid_set_region(clients, 0, 0, ds_grid_width(clients), ds_grid_height(clients), -1);


#define client_handle_data
///client_handle_data(buffer);
var buffer = argument0;

while(buffer_tell(buffer) != buffer_get_size(buffer)){
    
    var message = buffer_read(buffer, buffer_u8);
    switch(message){
        case M_JOIN:
            client_id = buffer_read(buffer, buffer_u8);
            for(var i = 0; i < MAX_CLIENTS; i++){
                var connected = buffer_read(buffer, buffer_bool);
                if(connected){
                    clients[# i, 0] = noone;
                }else{
                    clients[# i, 0] = -1;
                }
            }
        break;
        case M_CONNECT:
            var clientid = buffer_read(buffer, buffer_s8);
            clients[# clientid, 0] = noone;
            multiplayerstats.players = buffer_read(buffer, buffer_u8);
            show_debug_message(string(multiplayerstats.players));
        break;
        case M_DISCONNECT:
            var disconnected = buffer_read(buffer, buffer_u8);
            if(clients[# disconnected, 0] != -1 && clients[# disconnected, 0] != noone){
                instance_destroy(clients[# disconnected, 0]);  
            }
            clients[# disconnected, 0] = -1;
            multiplayerstats.players = buffer_read(buffer, buffer_u8);
            show_debug_message(string(multiplayerstats.players));
        break;
        case M_GAMEMODE:
            var gmd = buffer_read(buffer, buffer_u8);
            gamemode.gamestate = gmd;
            show_debug_message("gamemode changed to " + string(gmd));
        break;
        case M_POS:
            var clientid = buffer_read(buffer, buffer_u8);
            var xx = buffer_read(buffer, buffer_u16);
            var yy = buffer_read(buffer, buffer_u16);
            var dir = buffer_read(buffer, buffer_u16);
            var clientobj = clients[# clientid, 0];
            clientobj.prx = clientobj.x;
            clientobj.pry = clientobj.y;
            clientobj.tox = xx;
            clientobj.toy = yy;
            clientobj.todir = dir;
            clientobj.tim = 0;
        break;
        case M_CRATE:
            var crate_id = buffer_read(buffer, buffer_u8);
            var item_count = buffer_read(buffer, buffer_u8);
            for(var i = 0; i < item_count; i++){
                var current_item = instance_create(0, 0, obj_item);
                current_item.item_id = buffer_read(buffer, buffer_u8);
                current_item.x = buffer_read(buffer, buffer_u16);
                current_item.y = buffer_read(buffer, buffer_u16);
                current_item.image_angle = buffer_read(buffer, buffer_u16);
                current_item.image_index = current_item.item_id;      
            }
            instance_destroy(global.crateMap[? string(crate_id)]);
        break;
        case M_ITEM_OBTAINED:
            var item_id = buffer_read(buffer, buffer_u8);
            instance_destroy(global.itemMap[? string(item_id)]);
        break;
        case M_ITEM:
            var clientid = buffer_read(buffer, buffer_u8);
            var item = buffer_read(buffer, buffer_u8);
            clients[# clientid, 0].item = item;
        break;
        case M_INFECT:
            var clientid = buffer_read(buffer, buffer_u8);
            if(clientid == client_id){
                player.infected = true;
            }else{
                clients[# clientid, 0].infected = true;
            }
        break;
        case M_ITEM_DROPPED:
            var current_item = instance_create(0, 0, obj_item);
                current_item.item_id = buffer_read(buffer, buffer_u8);
                current_item.x = buffer_read(buffer, buffer_u16);
                current_item.y = buffer_read(buffer, buffer_u16);
                current_item.image_angle = buffer_read(buffer, buffer_u16);
                current_item.image_index = current_item.item_id; 
        break;
    }

}


#define client_send_bool
///client_send_bool(buffer, message_type, message);
var buffer = argument0,
type = argument1,
message = argument2;
buffer_seek(buffer, buffer_seek_start, 0);
buffer_write(buffer, buffer_u8, type);
buffer_write(buffer, buffer_bool, message);
network_send_raw(socket, buffer, buffer_tell(buffer));


#define client_send_position
///client_send_position(buffer, x, y, dir);
var buffer = argument0,
xx = argument1,
yy = argument2,
dir = argument3;

buffer_seek(buffer, buffer_seek_start, 0);
buffer_write(buffer, buffer_u8, M_POS);
buffer_write(buffer, buffer_u16, round(xx));
buffer_write(buffer, buffer_u16, round(yy));
buffer_write(buffer, buffer_u16, round(dir));
network_send_raw(socket, buffer, buffer_tell(buffer));
#define client_send_item
///client_send_item(item, amount);
buffer_seek(send_buffer, buffer_seek_start, 0);
buffer_write(send_buffer, buffer_u8, M_ITEM);
if(argument1!=0){
  buffer_write(send_buffer, buffer_u8, argument0+1);  
}else{
    buffer_write(send_buffer, buffer_u8, 0);
}

network_send_raw(socket, send_buffer, buffer_tell(send_buffer));