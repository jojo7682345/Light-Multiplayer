///change_resolution(value);
var f = argument0;
var current_page = (menu_pages[page])
var current_array = current_page[# 4, menu_option[page]];
var i = string_split(current_array[f], "x");
var width = real(i[0]);
var height = real(i[1]);
window_set_size(width, height);
for(var i = 0; i <= room_last; i++){
    room_set_view(i, 0, true, 0, 0, 240*(width/height), 240, 0, 0, width, height, 0, 0, 0, 0, noone);
    room_set_view_enabled(i, true);
}
surface_resize(application_surface, width*2, height*2);

