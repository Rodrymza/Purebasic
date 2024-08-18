

Procedure buscarArray(Array vector$(1), busqueda$)
  
  For j=0 To ArraySize(vector$())
    
    For i=1 To Len(vector$(j))-(Len(busqueda$)-1)
      If Mid(vector$(j),i,Len(busqueda$))=busqueda$
        Debug j
        resultado=j
      EndIf 
    Next
  Next
  ProcedureReturn resultado
  
EndProcedure


Dim vector$(2)
vector$(0)="hola me llamo rodri"
vector$(1)="hola me llamo roci"
vector$(2)="hola me llamo juan"
MessageRequester("","Encontre lo buscado en el Array " + Str(buscarArray(vector$(),"o roc")))

; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 22
; Folding = -
; EnableXP
; DPIAware