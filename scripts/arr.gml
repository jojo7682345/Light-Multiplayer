#define arr
///arr(data, data, ...)
var ar;
for(var i = 0; i < argument_count; i++){
    ar[i] = argument[i];
}
return ar;

#define arr2
///arr2(width, height, initial_value);
var width = argument0, height = argument1, array;
for(var xx = 0; xx < width; xx++){
    for(var yy = 0; yy < height; yy++){
        array[xx, yy] = argument2;
    }   
}
return array;