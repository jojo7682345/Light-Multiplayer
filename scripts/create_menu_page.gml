///create_menu_page
///@args [name1, type, data...]
///@args [name2, type, data...]

var arg, i = 0;
repeat(argument_count){
    arg[i] = argument[i];
    i++;
}

var ds_grid_id = ds_grid_create(5, argument_count);
i = 0; repeat(argument_count){
    var array = arg[i];
    var array_len = array_length_1d(arg[i]);
    
    var xx = 0; repeat(array_len){
        ds_grid_id[# xx, i] = array[xx];
        xx++;
    }
    
    i++;
}


return ds_grid_id;
