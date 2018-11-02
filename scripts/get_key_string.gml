///get_key_string(value)
var string_val = "";
switch(argument0){
                case vk_up:         string_val = "UP";              break;
                case vk_left:       string_val = "LEFT";            break;
                case vk_right:      string_val = "RIGHT";           break;
                case vk_down:       string_val = "DOWN";            break;
                case vk_alt:        string_val = "ALT";             break;
                case vk_backspace:  string_val = "BACK";            break;
                case vk_control:    string_val = "CTRL";            break;
                case vk_delete:     string_val = "DELETE";          break;
                case vk_enter:      string_val = "ENTER";           break;
                case vk_escape:     string_val = "ESCAPE";          break;
                case vk_add:        string_val = "ADD";             break;
                case vk_divide:     string_val = "DIVIDE";          break;
                case vk_end:        string_val = "END";             break;
                case vk_home:       string_val = "HOME";            break;
                case vk_insert:     string_val = "INSERT";          break;
                case vk_multiply:   string_val = "MULTIPLY";        break;
                case vk_lshift:      string_val = "LSHIFT";           break;
                case vk_space:      string_val = "SPACE";           break;
                case vk_subtract:   string_val = "SUBTRACT";        break;
                case vk_tab:        string_val = "TAB";             break;
                default:            string_val = chr(argument0);      break;
                // TODO all other vk keys;
            }
            return string_val;
