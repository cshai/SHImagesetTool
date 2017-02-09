# SHImagesetTool

使用SHImagesetTool.sh 可以更具ios切图，生成Xcode项目中对应的imageset文件目录

## 一、背景

当你自己将大量切图拖拽到Xcode，是否觉得卡的不行，想砸电脑，心里还在痛骂XX。有了这个脚本，每次运行一下脚步，从切图到imageset，只需一键

## 二、运行脚本

打开 `SHImagesetTool.sh` ，填写你的切图图片文件夹路径、图片输出文件夹路径（可以直接到项目路径）。

``` shell
#输入输出源，根据情况自己设置
SRC_PATH="./image"
OUTPUT_PATH="../image_output"
```

运行脚本：

``` ruby
./SHImagesetTool.sh
```
