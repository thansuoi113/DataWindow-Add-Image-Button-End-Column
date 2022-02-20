$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type dw_1 from u_dw within w_main
end type
end forward

global type w_main from window
integer width = 2843
integer height = 1224
boolean titlebar = true
string title = "Add Image Button End Column"
boolean controlmenu = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
dw_1 dw_1
end type
global w_main w_main

type variables

end variables

on w_main.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on w_main.destroy
destroy(this.dw_1)
end on

event open;dw_1.of_setcolumnbmp (True)
// Register the column to trigger the data window ue_find event when the icon is clicked to process the relevant content in ue_find
//You can also specify the width of the picture, the type of side width and the triggered event, etc.
//Note that the style of the registered column must be: 'ddlb' or 'edit' or 'editmask'
dw_1.inv_colun_bmp.of_register( 'comp_code', '.\pic\FIND.BMP')
//dw_1.inv_colun_bmp.of_register( 'comp_zip', '.\pic\FIND_DW.BMP')
dw_1.inv_colun_bmp.of_register( 'comp_zip', '.\pic\FIND_DW.BMP', 'ue_click')
dw_1.inv_colun_bmp.of_register( 'comp_name', '.\pic\NAME.gif', 'ue_click')

//Because the data window has no data source and does not require data retrieval, the itemfocuschanged event will not be triggered after opening
// Therefore, we need to manually trigger the ue_changevisible event here, and this code is not needed in the data window with the data source
dw_1.Event ue_changevisible('comp_code')

end event

event close;dw_1.of_setcolumnbmp (False)

end event

type dw_1 from u_dw within w_main
event ue_click ( )
integer x = 55
integer y = 32
integer width = 2738
integer height = 1064
integer taborder = 10
string dataobject = "d_comp"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_click();String PassedString

PassedString = String(Message.LongParm, "address")

Choose Case PassedString
	Case "comp_name"
		MessageBox('Warning',This.GetItemString(This.GetRow(),"comp_name"))
	Case "comp_zip"
		MessageBox('Warning',This.GetItemString(This.GetRow(),"comp_zip"))
		open(w_response)
	Case Else
		MessageBox('','')
End Choose



end event

