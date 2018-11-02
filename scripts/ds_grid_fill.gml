#define ds_grid_fill
///ds_grid_fill(id, val, x/y, row/colum = true/false);
var grid = argument0,
val = argument1,
pos = argument2,
t = argument3;
if(t){
    for(var i = 0; i < ds_grid_height(grid); i++){
        if(ds_grid_get(grid, pos, i)==-1){
            ds_grid_set(grid, pos, i, val);
            return i;
        }else{
            continue;
        }
    }
    return -1;
    
}else{
    for(var i = 0; i < ds_grid_width(grid); i++){
        if(ds_grid_get(grid, i, pos)==-1){
            ds_grid_set(grid, i, pos, val);
            return i;
        }else{
            continue;
        }
    }
    return -1;
}


#define ds_grid_find
///ds_grid_find(id, val, x/y, colum/row = true/false);
var grid = argument0,
val = argument1,
pos = argument2,
t = argument3;
if(t){
    for(var i = 0; i < ds_grid_height(grid); i++){
        if(ds_grid_get(grid, pos, i)==val){
            return i;
        }else{
            continue;
        }
    }
    
}else{
    for(var i = 0; i < ds_grid_width(grid); i++){
        if(ds_grid_get(grid, i, pos)==val){
            return i;
        }else{
            continue;
        }
    }
}
return -1;


#define ds_grid_entries
///ds_grid_entries(id, x/y, row/colum = true/false);
var grid = argument0,
pos = argument1,
t = argument2;
var total = 0;
if(t){
    for(var i = 0; i < ds_grid_width(grid); i++){
        if(ds_grid_get(grid, pos, i)!=-1){
            total++;
        }else{
            continue;
        }
    }
    
}else{
    for(var i = 0; i < ds_grid_width(grid); i++){
        if(ds_grid_get(grid, i, pos)!=-1){
            total++;
        }else{
            continue;
        }
    }
}
return total;
#define ds_grid_stack
///ds_grid_stack(id, val, x/y, row/colum = true/false);
var grid = argument0,
val = argument1,
pos = argument2,
t = argument3;
if(t){
    for(var i = 0; i < ds_grid_height(grid); i++){
        if(ds_grid_get(grid, pos, i)==-1||grid[# pos, i] == val){
            ds_grid_set(grid, pos, i, val);
            return i;
        }else{
            continue;
        }
    }
    return -1;
    
}else{
    for(var i = 0; i < ds_grid_width(grid); i++){
        if(ds_grid_get(grid, i, pos)==-1||grid[# i, pos] == val){
            ds_grid_set(grid, i, pos, val);
            return i;
        }else{
            continue;
        }
    }
    return -1;
}