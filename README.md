# OperatorSystem

## Compile.
```
nasm xxx.asm
or
nasm xxx.asm -o xxx
```
得到文件，假如是boot.bin.

## Install bochs in windows.
```
scoop install bochs
```

## Create a floppy iamge file.[1.44M,fd]
```
bximage
```
得到a.img文件,文件大小为1.44M。

## Write boot.bin to Image file.
```
dd if=boot.bin of=a.img bs=512 count=1 conv=notrunc
```
conv=notrunc 表示不裁剪a.img文件，保持a.img为1.44M.

## Launch simulator.
```
bochs
```
