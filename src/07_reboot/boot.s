%include    "../modules/real/puts.s"
%include    "../modules/real/itoa.s"
%include    "../modules/real/reboot.s"

;--------------------------------------
;   文字列を表示
;--------------------------------------
cdecl   puts, .s0
cdecl   reboot