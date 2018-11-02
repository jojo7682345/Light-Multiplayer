#define manage_hdisplay
///manage_hdisplay(view, window height, view height)
var ideal_height = argument1;
var ideal_width = 0;
var view_height = argument2;
var view_width = 0;
var view = argument0;
var aspect_ratio = round(display_get_width()/display_get_height());
ideal_width = ideal_height*aspect_ratio;
view_width = view_height*aspect_ratio;

if(display_get_width() mod ideal_width != 0){
    var d = round(display_get_width()/ideal_width);
    ideal_width = display_get_width()/d;
}
if(display_get_width() mod view_width != 0){
    var f = round(display_get_width()/view_width);
    view_width = display_get_width()/f;
}

if(ideal_width % 2 == 1){
    ideal_width++;
}
if(view_width % 2 == 1){
    view_width++;
}
if(ideal_height % 2 == 1){
    ideal_height++;
}
if(view_height % 2 == 1){
    view_height++;
}
for(var i = 0; i < room_last; i++){
    room_set_view_enabled(i, view);
    room_set_view(i, view, true, 0, 0, view_width, view_height, 0, 0, ideal_width, ideal_height, 0, 0, 0, 0, noone);
}
window_set_size(ideal_width, ideal_height);
surface_resize(application_surface, ideal_width, ideal_height);
window_set_fullscreen(true);



#define manage_vdisplay
///manage_vdisplay(view, window width, view width)
var ideal_height = 0;
var ideal_width = argument1;
var view_height = 0;
var view_width = argument2;
var view = argument0;
var aspect_ratio = round(display_get_width()/display_get_height());
ideal_height = ideal_width/aspect_ratio;
view_height = view_width/aspect_ratio;
for(var i = 0; i < room_last; i++){
    room_set_view_enabled(i, view);
    room_set_view(i, view, true, 0, 0, view_width, view_height, 0, 0, ideal_width, ideal_height, 0, 0, 0, 0, noone);
}
window_set_size(ideal_width, ideal_height);
surface_resize(application_surface, ideal_width, ideal_height);
window_set_fullscreen(true);