# OS
x86系汎用OS

# 使用環境

nasm(アセンブラ)

qemuまたはBochs(Bochs推奨)
__________________________________

# 構築

デスクトップに「OS」というディレクトリを作成し、その中にgit cloneする

パスは 「Desktop\OS」となる

Bochsやqemuをインストールしたら「env/env.bat」内の各種パス指定を各々の環境のパスに書き換える
_________________________________

# アセンブル(パス未登録)


..\ ..\tools\nasm-2.15.05\nasm ファイル -o 出力ファイル名 -l リスティングファイル名

例として「00_boot_only」内の「boot.img」をアセンブルする(アセンブルする際はboot.imgが格納されたディレクトリに移動する)

Desktop\OS\src\00_boot_only> ..\ ..\tools\nasm-2.15.05\nasm .\boot.s -o boot.img -l boot.list

__________________________________________

# qemuでの実行
(qemuの実行環境を「C:\Program Files (x86)」に置いている場合)

"C:\Program Files (x86)\qemu\qemu-system-i386.exe" boot.img

例:ディレクトリ「00_boot_only」内のboot.imgを実行

Desktop\OS\src\00_boot_only> "C:\Program Files (x86)\qemu\qemu-system-i386.exe" boot.img

___________________________________________

# Bochsでの実行
(Bochsの実行環境を「C:\Program Files (x86)」に置いている場合)

"c:\Program Files (x86)\Bochs-2.6.11\bochs.exe"

例:ディレクトリ「00_boot_only」内のboot.imgを実行

Desktop\OS\src\00_boot_only> "c:\Program Files (x86)\Bochs-2.6.11\bochs.exe"

______________________________________________

# Bochsを起動したら

①「Edit Options」内の 「Disk & Boot」をダブルクリック

②「ATA channel 0」タブ内の「First HD/CD on channel 0」をクリック

③「Type of ATA device」をdisk

④「Path or pysical device name」をboot.img

⑤「Cylinders」を20

⑥「Heads」を2

⑦「Sectors per track」を16

⑧「Boot Options」タブをクリック

⑨「Bootdrive #1」をdisk

⑩「ok」-> 「start」

⑪Panicが出るので「Continue」を選択し「ok」

_____________________________________________

# Bochsを起動(ショートカット)

上記の操作を毎回するのは面倒臭いのでバッチを作成した

①各連番のディレクトリ内に「dev.bat」があるので、それを起動する

②ターミナルが開くので

```
$ env

$ box

```

を実行するとBochsが起動する
