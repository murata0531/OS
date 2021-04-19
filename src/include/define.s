;************************************************************************
;	メモリイメージ
;************************************************************************

		;---------------------------------------
		;           |            | 
		;           |____________| 
		; 0000_7A00 |            | ( 512) スタック
		;           |____________| 
		; 0000_7C00 |            | (  8K) ブート
		;           =            = 
		;           |____________| 
		; 0000_9C00 |            | (  8K) カーネル（一時展開）
		;           =            = 
		;           |____________| 
		; 0000_BC00 |////////////| 
		;           =            = 
		;           |____________| 
		; 0010_0000 |       (2K) | 割り込みディスクリプタテーブル
		;           |____________| 
		; 0010_0800 |       (2K) | カーネルスタック
		;           |____________| 
		; 0010_1000 |       (8K) | カーネルプログラム
		;           |            | 
		;           =            = 
		;           |____________| 
		; 0010_3000 |       (8K) | タスク用スタック
		;           |            | （各タスク1K）
		;           =            = 
		;           |____________| 
		; 0010_5000 |            | Dir
		;      6000 |____________| Page
		; 0010_7000 |            | Dir
		;      8000 |____________| Page
		; 0010_9000 |////////////| 
		;           |            | 


        BOOT_LOAD			equ		0x7C00			; ブートプログラムのロード位置
        BOOT_SIZE			equ		(1024 * 8)		; ブートサイズ
        SECT_SIZE			equ		(512)			; セクタサイズ
        BOOT_SECT			equ		(BOOT_SIZE   / SECT_SIZE)	; ブートプログラムのセクタ数

        E820_RECORD_SIZE	equ		20