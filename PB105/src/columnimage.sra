$PBExportHeader$columnimage.sra
$PBExportComments$Generated Application Object
forward
global type columnimage from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type columnimage from application
string appname = "columnimage"
end type
global columnimage columnimage

on columnimage.create
appname="columnimage"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on columnimage.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;open(w_main)
end event

