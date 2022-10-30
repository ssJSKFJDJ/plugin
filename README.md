# plugin

[![License](https://img.shields.io/github/license/ssJSKFJDJ/plugin.svg)](http://www.gnu.org/licenses)
[![Downloads](https://img.shields.io/github/downloads/ssJSKFJDJ/plugin/total.svg)](https://github.com/ssJSKFJDJ/plugin/releases)
[![GitHub last commit](https://img.shields.io/github/last-commit/ssJSKFJDJ/plugin.svg)](https://github.com/ssJSKFJDJ/plugin/commits)

[![issue数量](https://img.shields.io/github/issues/ssJSKFJDJ/plugin.svg)](https://github.com/ssJSKFJDJ/plugin/issues)
[![PR数量](https://img.shields.io/github/issues-pr/ssJSKFJDJ/plugin.svg)](https://github.com/ssJSKFJDJ/plugin/pulls)
[![单个lua文件](https://img.shields.io/github/directory-file-count/ssJSKFJDJ/plugin/Single%20lua%20File?extension=lua&label=Single%20File&type=file)](https://github.com/ssJSKFJDJ/plugin/tree/main/Single%20File)
[![多个lua文件](https://img.shields.io/github/directory-file-count/ssJSKFJDJ/plugin/Mutiple%20Files?label=Mutiple%20lua%20File&type=dir)](https://github.com/ssJSKFJDJ/plugin/tree/main/Single%20File)
# WARNING

注意，请**按照格式和规范**提交pr:

1. 若您提交的是单个`*.lua`文件，请在脚本前四行务必写上如下注释，否则审核将会被打回：
   ```lua
   -------------------------------
   -- @脚本名 by 你的名字或联系方式
   -- @license 协议名(比如MIT.)
   -------------------------------
   ```
   这么做的理由是为了让您的脚本在被他人下载使用时，让他人知晓作者是谁，(若有报错)如何联系，能否二次演绎(协议)。
   随后请将你的lua脚本提交至Single File文件夹，并在plugin的master分支下的README.md最新一行按照如下格式填写:
   ```md
   #（时间），（脚本名），（作者联系方式或作者名）
   2022年10月30日，DailyNews.lua，简律纯
   ```
2. 若您的脚本包含`*.lua`文件数量过多或是包含文件夹，请将它们全部放在一个以脚本名命名的文件夹内上传，并附上`README.md`简单介绍各个文件的作用以及一些作者信息。
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
   `README.md`文件内可以这样写：
   ```markdown
   脚本名：plugin_name
   part1.lua:用于接受配置指令
   part2.lua:脚本主体
   dir:配置文件存放文件夹
   file1:配置文件1
   ...:...
   作者:xxx
   联系方式：xxx@xxx.xxxx
   ```
   随后请将你的文件夹提交至Mutiple Files文件夹，并在master分支下的README.md里找到Mutiple Files栏，在最新一栏按照如下格式填写:
   ```md
   #（时间），（文件夹名），（作者联系方式或作者名）
   2022年10月30日，team call，pine
   ```
