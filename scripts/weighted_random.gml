///weighted_random(val1, weight, val2, weight, val3, weight, val4, weight, val5, weight, val6, weight, val7, weight, val8, weight, val9, weight, val10, weight)
list = ds_list_create();
for(var i = 0; i < argument_count; i+=2){
    repeat(argument[i+1]){
        ds_list_add(list, argument[i]);
    }
}
ds_list_shuffle(list);
return ds_list_find_value(list, 0);
ds_list_destroy(list);


