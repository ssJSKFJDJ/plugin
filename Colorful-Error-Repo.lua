json = require "json"

case = {
  "module \'(.*)\' not found",

  "attempt to call a nil value",

  "attempt to index a nil value",

  "attempt%sto%sconcatenate%sa%snil%svalue",

  "bad argument #1 to \'(.*)\' (string expected, got nil)",

  "value expected",

  "attempt to perform arithmetic on a nil value (global \'(.*)\')",

  "bad argument #%d+ to \'(.*)\'(number has no integer representation)",

  "\'}\' expected (to close \'{\' at line 169) near \'%s\'",

  "\'end\' expected (to close \'function\' at line 240) near <eof>",

  "\'then\' expected near \'end\'",

  "unexpected symbol near \'(.*)\'",

  "attempt to get length of a nil value (local \'(.*)\')",

  "attempt to add a \'string\' with a \'string\'",

  "attempt to compare number with string",

  "error loading module \'(.*)\' from file",

  "no visible label \'(.*)\' for <goto> at line %d+",

  "invalid option \'(.*)\'"

}

output = {
  "没有把被引用的lua或dll文件放在指定位置（多见于require与loadLua）",

  "解决方式：把所需文件放入Dice存档目录/plugin/或Diceki/lua/，dll文件或require对象必须置于后者 ",

  "将空变量%s用作函数（global表示被调用的是全局变量，local表示本地变量，method表示索引方法）",

  "对空变量%s使用索引（只有table等结构可以索引，形如msg.fromMsg）",

  "使用..连接字符串时连接了一个空变量%s",

  "函数%s的第1个参数类型错误，要求类型为string，但实际传入的参数为nil。特别地，got nil表示输入参数为nil或缺少参数",

  "要求参数，但没有传入",

  "将一个空变量%s当做数字表示",

  "函数format的第5个参数类型错误，要求是整数，但传入是小数，或者是其余类型不能化为整数",

  "脚本第169行的左花括号缺少配对的右花括号。此错误也可以由表格内缺少逗号分隔、括号外的中文等原因造成",

  "脚本第240行的function缺少收尾的end，<eof>表示文件结束（找到文件末也没找到）",

  "if then end逻辑结构缺少then",

  "符号%s边有无法识读的符号，比如中文字符",

  "对空变量tab作取长度运算（#）",

  "对(不能化为数字的)字符串用加法'+'（字符串只能用连接'..'）",

  "对数字和(不能化为数字的)字符串用比较运算符",

  "使用require \"%s\"时加载出错",

  "在循环结构中跳转不存在的节点",

  "传入的参数不是string或不在给定的字符串列表中"
}

CER = function(fun, arg1, arg2, arg3, arg4, arg5)
  local i
  local ret, errMessage = pcall(fun, arg1, arg2, arg3, arg4, arg5);
  wrong = ret and "false" or "true"
  --return "是否错误:\n"..错误.." \n\n出错信息:\n" .. (errMessage or "无")
  if wrong == "true" then --错误提示
    local ret, errMessage = pcall(fun, arg1, arg2, arg3, arg4, arg5)
    return "\n错误详情：\n" .. errMessage --output[i]
  else --无错误正常执行
    ret, back = pcall(fun, arg1, arg2, arg3, arg4, arg5)
    return back
  end
end
