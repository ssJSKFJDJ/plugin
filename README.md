### plugin(Lua插件)

> 如果你是Dice!脚本作者，那么你可以[fork plugin](https://github.com/ssJSKFJDJ/plugin/fork)仓库，然后按格式提交PR。

[![License](https://img.shields.io/github/license/ssJSKFJDJ/plugin.svg)](http://www.gnu.org/licenses)
[![Downloads](https://img.shields.io/github/downloads/ssJSKFJDJ/plugin/total.svg)](https://github.com/ssJSKFJDJ/plugin/releases)
[![GitHub last commit](https://img.shields.io/github/last-commit/ssJSKFJDJ/plugin.svg)](https://github.com/ssJSKFJDJ/plugin/commits)

[![issue数量](https://img.shields.io/github/issues/ssJSKFJDJ/plugin.svg)](https://github.com/ssJSKFJDJ/plugin/issues)
[![PR数量](https://img.shields.io/github/issues-pr/ssJSKFJDJ/plugin.svg)](https://github.com/ssJSKFJDJ/plugin/pulls)
[![单个lua文件](https://img.shields.io/github/directory-file-count/ssJSKFJDJ/plugin/Single%20File?extension=lua&label=Single%20Lua%20File&type=file)](https://github.com/ssJSKFJDJ/plugin/tree/main/Single%20File)
[![多个lua文件](https://img.shields.io/github/directory-file-count/ssJSKFJDJ/plugin/Mutiple%20Files?label=Mutiple%20lua%20File&type=dir)](https://github.com/ssJSKFJDJ/plugin/tree/main/Single%20File)

## 提交单个`*.lua`文件"

1. 若您提交的是单个`*.lua`文件，请在脚本前四行务必写上如下注释，否则审核将会被打回，这么做的理由是为了让您的脚本在被他人下载使用时，让他人知晓作者是谁，(若有报错)如何联系，能否二次演绎(协议)。
```lua title="Single.lua"
-------------------------------
-- @脚本名 by 你的名字或联系方式
-- @license 协议名(比如MIT.)
-------------------------------
```
2. 随后请将你的lua脚本提交至[Single File](https://github.com/ssJSKFJDJ/plugin/tree/main/Single%20File)文件夹，并在该文件夹下的[README.md](https://github.com/ssJSKFJDJ/plugin/blob/main/Single%20File/README.md)内找到当天日期（如没有就添加一个）写上:
```yaml
日期:
      - 脚本文件（包含.lua扩展名） by 作者名（联系方式)
#比如:
2022年10月30日:
      - DailyNews.lua by 简律纯
      - xxx.lua by xxx
```

## 提交多个`*.lua`文件甚至文件夹"

1. 若您的脚本包含`*.lua`文件数量过多或是包含文件夹，请将它们全部放在一个以脚本名命名的文件夹内上传，并附上`README.md`简单介绍各个文件的作用以及一些作者信息。
它们将会是这样的:
```
plugin_name
      |-README.md
      |-part1.lua
      |-part2.lua
      |————dir
            |-file1
            |-file2
```
`README.md`文件内可以这样写(只是为了表现层次，所以尽量使用文件树)：
```markdown
plugin_name
      |  |-part1.lua #用于接受配置指令
      |  |-part2.lua #脚本主体
      |
      |-dir #配置文件存放文件夹
         |-file1 #配置文件..
      
作者:xxx
联系方式：xxx@xxx.xxxx
```
2. 随后请将你的文件夹提交至[Mutiple Files](https://github.com/ssJSKFJDJ/plugin/tree/main/Mutiple%20Files)文件夹,并在该文件夹下的[README.md](https://github.com/ssJSKFJDJ/plugin/blob/main/Mutiple%20Files/README.md)内找到当天日期（如没有就添加一个）写上:
```yaml
日期:
      - 你上传的文件夹名称 by 作者名（联系方式)
#比如:
2022年10月30日:
      - team call by Pine
      - xxx by xxx
```
