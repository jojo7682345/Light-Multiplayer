#define server_create
///server_create(port, type);
var port = argument0,
type = argument1;

var connect = 0;
connect = network_create_server_raw(type, port, MAX_CLIENTS);
if(connect < 0){show_error("could not create server", true);}

send_buffer = buffer_create(256, buffer_fixed, 1);

clients = ds_grid_create(MAX_CLIENTS, 2);
ds_grid_set_region(clients, 0, 0, ds_grid_width(clients), ds_grid_height(clients), -1);


#define server_destroy
///server_destroy();
ds_grid_destroy(clients);
network_destroy(connect);


#define server_handle_connect
///server_handle_connect(socket);
if(gamemode.gamestate == mode.connecting){
    var socket = argument0;
    var clientid = ds_grid_fill(clients, socket, 0, false)
    if(clientid==-1){
        network_destroy(socket);
    }
    server_log("client connected with id:" + string(clientid) + " socket:" + string(socket));
    var size = ds_grid_entries(clients, 0, false);
    
    server_send_connection_message(send_buffer, M_CONNECT, clientid, size);
    buffer_seek(send_buffer, buffer_seek_start, 0);
    buffer_write(send_buffer, buffer_u8, M_JOIN);
    buffer_write(send_buffer, buffer_u8, clientid);
    for(var i = 0; i < MAX_CLIENTS; i++){
        if(clients[# i, 0]==-1){
            buffer_write(send_buffer, buffer_bool, false);
        }else{
            buffer_write(send_buffer, buffer_bool, true);
        }
    }
    network_send_raw(socket, send_buffer, buffer_tell(send_buffer));
}else{
    network_destroy(argument0);
    server_log("client refused: game already started");
}



#define server_handle_data
///server_handle_data(socket, buffer);
var buffer= argument1,
socket = argument0;
var current_client = ds_grid_find(clients, socket, 0, false);
while(buffer_tell(buffer)!=buffer_get_size(buffer)){
    
    var message = buffer_read(buffer, buffer_u8);
    switch(message){
        case M_LOADED:
            var loaded = true;
            clients[# current_client, 1] = buffer_read(buffer, buffer_bool);
            for(var i = 0; i < ds_grid_width(clients); i++){
                if(clients[# i, 0] != -1 && clients[# i, 1]!= true){
                    loaded = false;
                    break;
                }
            }
            if(loaded){
                server_send_gamemode_message(send_buffer, M_GAMEMODE, mode.in_game);
                gamemode.gamestate = mode.in_game;
                buffer_seek(send_buffer, buffer_seek_start, 0);
                buffer_write(send_buffer, buffer_u8, M_INFECT);
                randomize();
                buffer_write(send_buffer, buffer_u8, irandom_range(0, ds_grid_entries(clients, 0, false)-1));
                for(var i = 0; i < ds_grid_width(clients); i++){
                    network_send_raw(clients[# i, 0], send_buffer, buffer_tell(send_buffer));
                }
                server_log("game running");
            }
        break;
        case M_POS:
            var xx = buffer_read(buffer, buffer_u16);
            var yy = buffer_read(buffer, buffer_u16);
            var dir = buffer_read(buffer, buffer_u16);
            
            buffer_seek(send_buffer, buffer_seek_start, 0);
            buffer_write(send_buffer, buffer_u8, M_POS);
            buffer_write(send_buffer, buffer_u8, current_client);
            buffer_write(send_buffer, buffer_u16, xx);
            buffer_write(send_buffer, buffer_u16, yy);
            buffer_write(send_buffer, buffer_u16, dir);
            
            for(var i = 0; i < ds_grid_width(clients); i++){
                if(i != current_client){
                    network_send_raw(clients[# i, 0], send_buffer, buffer_tell(send_buffer));
                }
            }
            
        break;
        case M_CRATE:
            var crate_id = buffer_read(buffer, buffer_u8);
            var item_count = buffer_read(buffer, buffer_u8);
            var item;
            for(var i = 0; i < item_count; i++){
                var current_item = ds_map_create();
                current_item[? "material"] = buffer_read(buffer, buffer_u8);
                current_item[? "x"] = buffer_read(buffer, buffer_u16);
                current_item[? "y"] = buffer_read(buffer, buffer_u16);
                current_item[? "dir"] = buffer_read(buffer, buffer_u16);
                item[i] = current_item;
            }  
            buffer_seek(send_buffer, buffer_seek_start, 0);
            buffer_write(send_buffer, buffer_u8, M_CRATE);
            buffer_write(send_buffer, buffer_u8, crate_id);
            buffer_write(send_buffer, buffer_u8, item_count);
            for(var i = 0; i < item_count; i++){
                var inst = item[i];
                buffer_write(send_buffer, buffer_u8, inst[? "material"]);
                buffer_write(send_buffer, buffer_u16, inst[? "x"]);
                buffer_write(send_buffer, buffer_u16, inst[? "y"]);
                buffer_write(send_buffer, buffer_u16, inst[? "dir"]);
            }
            for(var i = 0; i < ds_grid_width(clients); i++){
                if(i != current_client){
                    network_send_raw(clients[# i, 0], send_buffer, buffer_tell(send_buffer));
                }
            }
        break;  
        case M_ITEM_OBTAINED:
            var item_id = buffer_read(buffer, buffer_u8);
            buffer_seek(send_buffer, buffer_seek_start, 0);
            buffer_write(send_buffer, buffer_u8, M_ITEM_OBTAINED);
            buffer_write(send_buffer, buffer_u8, item_id);
            for(var i = 0; i < ds_grid_width(clients); i++){
                if(i != current_client){
                    network_send_raw(clients[# i, 0], send_buffer, buffer_tell(send_buffer));
                }
            }
        break;
        case M_ITEM:
            var item = buffer_read(buffer, buffer_u8);
            buffer_seek(send_buffer, buffer_seek_start, 0);
            buffer_write(send_buffer, buffer_u8, M_ITEM);
            buffer_write(send_buffer, buffer_u8, current_client);
            buffer_write(send_buffer, buffer_u8, item);
            for(var i = 0; i < ds_grid_width(clients); i++){
                if(i != current_client){
                    network_send_raw(clients[# i, 0], send_buffer, buffer_tell(send_buffer));
                }
            }
        break;
        case M_ITEM_DROPPED:
            var mat = buffer_read(buffer, buffer_u8);
            var xx = buffer_read(buffer, buffer_u16);
            var yy = buffer_read(buffer, buffer_u16);
            var dir = buffer_read(buffer, buffer_u16);
            
            buffer_seek(send_buffer, buffer_seek_start, 0);
            buffer_write(send_buffer, buffer_u8, M_ITEM_DROPPED);
            buffer_write(send_buffer, buffer_u8, mat);
            buffer_write(send_buffer, buffer_u16, xx);
            buffer_write(send_buffer, buffer_u16, yy);
            buffer_write(send_buffer, buffer_u16, dir);
            for(var i = 0; i < ds_grid_width(clients); i++){
                if(i != current_client){
                    network_send_raw(clients[# i, 0], send_buffer, buffer_tell(send_buffer));
                }
            }
        break;
    }

}


#define server_handle_disconnect
///server_handle_disconnect(socket);
var socket = argument0;
var pos = ds_grid_find(clients, socket, 0, false);
ds_grid_set(clients, pos, 0, -1);
ds_grid_set(clients, pos, 1, false);
server_send_connection_message(send_buffer, M_DISCONNECT, pos, ds_grid_entries(clients, 0, false)); 
server_log("client " + string(pos) + " disconnected");


#define server_send_connection_message
///server_send_connection_message(buffer, type, clientid, data);
var buffer= argument0,
type = argument1,
clientid = argument2,
data = argument3;

buffer_seek(buffer, buffer_seek_start, 0);
buffer_write(buffer, buffer_u8, type);
if(clientid != -1){
    buffer_write(buffer, buffer_s8, clientid);
}
buffer_write(buffer, buffer_u8, data);
for(var i = 0; i < ds_grid_width(clients); i++){
    network_send_raw(clients[# i, 0], buffer, buffer_tell(buffer));
}


#define server_send_gamemode_message
///server_send_gamemode_message(buffer, message_type, data);
var buffer= argument0,
type = argument1,
data = argument2;

buffer_seek(buffer, buffer_seek_start, 0);
buffer_write(buffer, buffer_u8, type);
buffer_write(buffer, buffer_u8, data);
for(var i = 0; i < ds_grid_width(clients); i++){
    network_send_raw(clients[# i, 0], buffer, buffer_tell(buffer));
}