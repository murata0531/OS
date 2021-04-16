itoa:
        ;--------------------------------------------
        ;   【スタックフレームの構築】
        ;--------------------------------------------
                                                    ;    +12 | フラグ
                                                    ;    +10 | 基数
                                                    ;    +8  | バッファサイズ
                                                    ;    +6  | バッファアドレス
                                                    ;    +2  | IP(戻り番地)
        push    bp                                  ; BP +0  | BP(元の値)
        mov     bp,sp                               ;--------+----------------

        ;--------------------------------------------
        ;   【レジスタの保存】
        ;--------------------------------------------
        push    ax
        push    bx
        push    cx
        push    dx
        push    si
        push    di

        ;-------------------------------------------
        ;   引数を取得
        ;-------------------------------------------
        mov     ax,[bp + 4]                        ; val = 数値
        mov     si,[bp + 6]                        ; dst = バッファアドレス
        mov     cx,[bp + 8]                        ; siza = 残りバッファサイズ

        mov     di,si                              ; バッファの最後尾↓
        add     di,cx                              ; dst = &dst[size - 1]
        dec     di
        
        mov     bx,word[bp + 12]                   ; flags = オプション

        ;-------------------------------------------
        ;   符号付き判定
        ;-------------------------------------------
        test    bx,0b0001                          ; if(flags & 0x01)
.10Q:   je      .10E                               ; {
        cmp     ax,0                               ;    if(val < 0)
.12Q:   jge     .12F                               ;    {
        or      bx,0b0010                          ;        flags |= 2 //符号表示
.12E:                                              ;    }
.10E:                                              ; }

        ;-------------------------------------------
        ;   符号出力判定
        ;-------------------------------------------
        test    bx,0b0010                          ; if(flags & 0x02) 
.20Q:   je      .20E                               ; {
        cmp     ax,0                               ;    if(val < 0)
.22Q:   jge     .22F                               ;    {
        neg     ax                                 ;        val *= -1 //符号反転
        mov     [si],byte '-'                      ;        *dst = '-' //符号表示
        jmp     .22E                               ;    }
.22F:                                              ;    else
                                                   ;    {
        mov     [si],byte '+'                      ;        *dst = '+' //符号表示
.22E:                                              ;    }
        dec     cx                                 ;    size-- //残りバッファサイズの減算
.20E:                                              ; }

        ;------------------------------------------
        ;   ASCII変換                              
        ;------------------------------------------
        mov     bx,[bp + 10]                       ; BX = 基数

.30L:                                              ; do
                                                   ; {
        mov     dx,0                               ;    DX = DX:AX % 基数
        div     bx                                 ;    AX = DX:AX / 基数

        mov     si,dx                              ;    //テーブル参照
        mov     dl,byte [.ascii + si]              ;    DL = ASCII[DX]

        mov     [di],dl                            ;    *dst = DL
        dec     di                                 ;    dst--

        cmp     ax,0                               
        loopnz  .30L                               ; }while(AX);
.30E:

        ;------------------------------------------
        ;   空欄を埋める
        ;------------------------------------------
        cmp     cx,0                               ; if(size != 0)
.40Q:   je      .40E                               ; {
        mov     al,' '                             ;    AL = ' ' //空白で埋める
        cmp     [bp + 12],word 0b0100              ;    if(flags & 0x04)
.42Q:   jne     .42E                               ;    {
        mov     al,'0'                             ;        AL = '0' //0で埋める
.42E:                                              ;    }
        std                                        ;    //DF = 1 (-方向)
        rep     stosb                              ;    while(--CX) *DI-- = '';
.40E:                                              ; }

        ;------------------------------------------
        ;   【レジスタの復帰】
        ;------------------------------------------
        pop     di
        pop     si
        pop     dx
        pop     cx
        pop     bx
        pop     ax

        ;------------------------------------------
        ;   【スタックフレームの破棄】
        ;------------------------------------------
        mov     sp,bp
        pop     bp

        ret

.ascii  db      "0123456789ABCDEF"                 ; 変換テーブル