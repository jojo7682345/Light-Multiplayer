///scr_monster_move(sprint, dir);
var r = argument1;
var b = argument0;
var secconds_passed = delta_time/1000000;
if(!keyboard_check(global.sprint)){
    b = 1;
}
var mspd = spd*secconds_passed*1;

xaxis = (keyboard_check(global.right) - keyboard_check(global.left));
yaxis = (keyboard_check(global.down) - keyboard_check(global.up));

var moving = (xaxis!=0||yaxis!=0);
var rot = point_direction(0, 0, xaxis, yaxis);
if(moving){
    var dir = point_direction(0, 0, xaxis, yaxis);
    var xtarg = x+lengthdir_x(mspd, rot);
    var ytarg = y+lengthdir_y(mspd, rot);
    if(!place_meeting(xtarg, y, obj_solid)){
        x = xtarg;
    }
    if(!place_meeting(x, ytarg, obj_solid)){
        y = ytarg;
    }
    return sin(degtorad(rot - r))*tecstat.mrspd*gamemode.delta;
}
return 0;



