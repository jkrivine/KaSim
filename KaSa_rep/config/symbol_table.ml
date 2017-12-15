type symbol_table =
  {
    agent_open : string ;
    agent_close : string ;
    agent_sep_comma : string ;
    agent_sep_dot : string ;
    agent_sep_plus : string ;
    compact_agent_sep_comma: bool ;
    compact_agent_sep_dot: bool ;
    compact_agent_sep_plus: bool ;
    ghost_agent : string ;
    show_ghost : bool ;
    internal_state_symbol : string;
    open_internal_state : string;
    close_internal_state : string;
    open_internal_state_mod : string;
    close_internal_state_mod : string;
    internal_state_mod_symbol: string;
    open_binding_state : string;
    close_binding_state : string;
    open_binding_state_mod: string;
    binding_state_mod_symbol: string;
    close_binding_state_mod: string;
    free : string;
    bound : string;
    link_to_any : string;
    link_to_some : string;
    at : string ;
    site_sep : string ;
    btype_sep : string ;
    uni_arrow : string ;
    rev_arrow : string ;
    bi_arrow : string ;
    uni_arrow_nopoly : string ;
    breakable : bool ;
  }

let symbol_table_V3 =
  {
    bound = "!";
    open_binding_state = "";
    close_binding_state = "";
    link_to_any = "?";
    link_to_some = "!_";
    internal_state_symbol = "~";
    open_internal_state = "";
    close_internal_state = "";
    open_internal_state_mod = "";
    close_internal_state_mod = "";
    internal_state_mod_symbol = "/";
    open_binding_state_mod = "";
    close_binding_state_mod = "";
    binding_state_mod_symbol = "";
    free = "";
    at = "." ;
    agent_open = "(" ;
    agent_close =  ")" ;
    agent_sep_comma = "," ;
    agent_sep_plus = "," ;
    agent_sep_dot = "," ;
    compact_agent_sep_comma = false ;
    compact_agent_sep_plus = false ;
    compact_agent_sep_dot = false ;
    btype_sep = ".";
    site_sep = "," ;
    ghost_agent = "." ;
    show_ghost = false ;
    uni_arrow = "->" ;
    rev_arrow = "<-" ;
    bi_arrow = "<->" ;
    uni_arrow_nopoly = "-!->" ;
    breakable = true ;
  }

let lighten symbol_table =
  {symbol_table with site_sep = " "}
let to_dotnet symbol_table =
  {symbol_table with agent_sep_plus = "+" ; agent_sep_dot = "."}

let symbol_table_V4 =
  {
    bound = "";
    open_binding_state = "[";
    close_binding_state = "]";
    link_to_any = "#";
    link_to_some = "_";
    internal_state_symbol = "";
    open_internal_state = "{";
    close_internal_state = "}";
    open_internal_state_mod = "";
    close_internal_state_mod = "";
    internal_state_mod_symbol = "/";
    open_binding_state_mod = "";
    close_binding_state_mod = "";
    binding_state_mod_symbol = "";
    free = ".";
    at = "." ;
    agent_open = "(" ;
    agent_close =  ")" ;
    agent_sep_comma = "," ;
    agent_sep_plus = "," ;
    agent_sep_dot = "," ;
    compact_agent_sep_comma = false ;
    compact_agent_sep_plus = false ;
    compact_agent_sep_dot = false ;
    btype_sep = ".";
    site_sep = "," ;
    ghost_agent = "." ;
    show_ghost = true ;
    uni_arrow = "->" ;
    rev_arrow = "<-" ;
    bi_arrow = "<->" ;
    uni_arrow_nopoly = "-!->" ;
    breakable = true ;
  }

let not_breakable symbol_table = {symbol_table with breakable = false}

let symbol_table_V3_light = lighten symbol_table_V3
let symbol_table_dotnet = to_dotnet symbol_table_V3
let unbreakable_symbol_table_V3 = not_breakable symbol_table_V3
let unbreakable_symbol_table_V4 = not_breakable symbol_table_V4

let unbreakable_symbol_table_V3_light = not_breakable symbol_table_V3_light
let unbreakable_symbol_table_dotnet = not_breakable symbol_table_dotnet
