# OS
OS

__________________________________

使用環境

nasm(アセンブラ)

qemu
__________________________________

構築

デスクトップに「OS」というディレクトリを作成し、その中にgit cloneする

パスは 「Desktop\OS」となる

_________________________________

アセンブル(パス未登録)


..\..\tools\nasm-2.15.05\nasm ファイル -o 出力ファイル名 -l リスティングファイル名

例として「00_boot_only」内の「boot.img」をアセンブルする(アセンブルする際はboot.imgが格納されたディレクトリに移動する)

Desktop\OS\src\00_boot_only> ..\tools\nasm-2.15.05\nasm .\boot.s -o boot.img -l boot.list

__________________________________________

実行(qemuの実行環境を「C:\Program Files (x86)」に置いている場合)

"C:\Program Files (x86)\qemu\qemu-system-i386.exe" boot.img

例:ディレクトリ「00_boot_only」内のboot.imgを実行

Desktop\OS\src\00_boot_only> "C:\Program Files (x86)\qemu\qemu-system-i386.exe" boot.img



