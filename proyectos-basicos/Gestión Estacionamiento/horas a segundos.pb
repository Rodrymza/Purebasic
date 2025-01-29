Procedure horaAseg(hora$)
  
  resultado=(Val(Mid(hora$,1,2))*3600)+(Val(Mid(hora$,4,5))*60)
  
  ProcedureReturn resultado
EndProcedure

hora$=FormatDate("%hh:%ii",Date())
segundos=horaAseg(hora$)

Debug segundos
; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; Folding = -
; EnableXP
; DPIAware