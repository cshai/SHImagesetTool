#!/bin/bash

#输入输出源，根据情况自己设置
SRC_PATH="./image"
OUTPUT_PATH="../image_output"

#需要处理图片类型
needResNames=(png PNG JPG jpg)
needResLength=${#needResNames[@]}

#判断需要处理的图片资源类型
function isNeedRes(){
	local filePathWithName=$1
	for ((i=0; i<$needResLength; i++))
	do
    	if [ "${filePathWithName##*.}" = ${needResNames[$i]} ];then
			return 1
		fi
	done
	return 0
}

#拷贝需要的资源文件到输出目录，并创建需要的目录
function cpFileToImageSet(){
	local filePathWithName=$1
	local srcPath=$2
	local SRC_PATH_STRING_LEN=${#srcPath}
	local filePath=`echo ${filePathWithName%/*}`
	local relativelyPath=`echo ${filePath:SRC_PATH_STRING_LEN}`
	local toFilePath=$OUTPUT_PATH$relativelyPath
	local fileName=`basename $1`
	local folderName=`echo "$fileName" | awk -F . '{print $NR}' | awk -F @ '{print $NR}' | awk -F - '{print $NR}'`
	local newImageSetPath="$toFilePath/$folderName.imageset"
	mkdir -p $newImageSetPath
	cp -rf $filePathWithName $newImageSetPath/$fileName
	echo "Putout:" $newImageSetPath/$fileName
}

#创建Json文件
function createContentJson(){
	rm -rf $1/Contents.json
	local fileList=`ls $1` 
	local file1=`echo $fileList  | cut -d " " -f 1`
	local file2=`echo $fileList  | cut -d " " -f 2`
	local savePath=$1
	local fileJson1=""
	local fileJson2=""
	local fileJson3=""

	if [[ $file1 =~ "@2x" ]];then
		fileJson2=',"filename":"'$file1'"'
	elif [[ $file1 =~ "@3x" ]];then
		fileJson3=',"filename":"'$file1'"'
	elif [[ $file1 =~ "." ]];then
		fileJson1=',"filename":"'$file1'"'
	fi

	if [[ $file2 =~ "@3x" ]];then
		fileJson3=',"filename":"'$file2'"'
	elif [[ $file2 =~ "@2x" ]];then
		fileJson2=',"filename":"'$file2'"'
	elif [[ $file2 =~ "." ]];then
		fileJson1=',"filename":"'$file2'"'
	fi
	
	local content='{"images":[{"idiom":"universal","scale":"1x"'$fileJson1'},{"idiom":"universal","scale":"2x"'$fileJson2'},{"idiom":"universal","scale":"3x"'$fileJson3'}],"info":{"author":"xcode","version":1}}'
	echo -n $content > $savePath/Contents.json
	echo "Putout:" $savePath/Contents.json
}

#搜索原目录，拷贝资源文件到相应的位置
function cpImageFileForOutPut(){
	for element in `ls $1`
    do  
        dir_or_file=$1"/"$element
        if [ -d $dir_or_file ]
        then 
            cpImageFileForOutPut $dir_or_file
        else
            #echo $dir_or_file
            isNeedRes $dir_or_file
            local res=$?
            if [ $res == "1" ];then
            	cpFileToImageSet $dir_or_file $1
            fi
        fi
    done
}

Contentjson='{\n  "info" : {\n    "version" : 1,\n    "author" : "xcode"\n  }\n}'

#目标目录创建json文件
function createContentForOutPut(){
	for element in `find $1 -type d`
    do  
    	local path=`echo $element | grep ".imageset"`
    	if [ $path"X" == "X" ];then
			echo -ne "$Contentjson" > $element"/Contents.json"
		else
        	createContentJson $element
		fi
    done
}

function main(){
	mkdir -p $OUTPUT_PATH
	rm -rf $OUTPUT_PATH/*
	cpImageFileForOutPut $SRC_PATH
	createContentForOutPut $OUTPUT_PATH
}

main




