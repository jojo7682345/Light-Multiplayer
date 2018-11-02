#define string_split
///string_split(string, char);
var str = argument0;
var char = argument1;
var section = 0;
var line = "";

for(var i = 1; i <= string_length(str); i++){
    var c = string_char_at(str, i);
    if(c != char){
        line = line+c;
    }else{
        content[section] = line;
        line = "";
        section++;
    }
}
content[section] = line;
return content;



#define string_contains
///string_contains(string, text);
var str = argument0;
var t = argument1;
var s = 0;
for(var i = 0; i < string_length(str); i++){
    var char = string_char_at(str, i);
    if(char == string_char_at(t, 1)){
        for(var j = 0; j < string_length(t); j++){
            if(string_char_at(str, i+j) == string_char_at(t, j)){
                s++;
            }else{
                s = 0;
                break;
            }
        }
    }
}
if(s == string_length(t)){
    return true;
}else{
    return false;
}



#define string_remove_space
///string_remove_space(str);
string_replace_all(argument0, " ", "");
    