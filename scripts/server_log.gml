///server_log(str);
ds_list_add(server_logs, argument0);
while(ds_list_size(server_logs)*32 > room_height){
    ds_list_delete(server_logs, 0);
}
    
