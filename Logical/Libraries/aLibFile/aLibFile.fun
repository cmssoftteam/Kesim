(********************************************************************
 * COPYRIGHT --  B&R Industrial Automation GmbH 
 *******************************************************************
 * Library: myLibFile
 * Author: kay3a 
 * Created: August 27, 2024/4:53 PM 
 *******************************************************************
 * Description: Bu Library içerisinde file/ folder ile ilgili 
                       ihtiyaç duydugunuz birçok islemi yapabileceginiz 
                       FB ler mevcut.
 ********************************************************************)

{REDUND_ERROR} FUNCTION_BLOCK FbDirDelete (*- Folder silme FB.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Enable : BOOL; (*- FB Enable.*)
		Execute : BOOL; (*- FB Execute cmd.*)
		ErrorReset : BOOL; (*- FB ErrorReset cmd.*)
		Parameters : Par_DirDelete_typ; (*- FB Parameters.*)
	END_VAR
	VAR_OUTPUT
		Active : BOOL; (*- FB Activated.*)
		CommandBusy : BOOL; (*- FB CommandBusy flag.*)
		CommandDone : BOOL; (*- FB CommandDone flag.*)
		Error : BOOL; (*- FB Error flag.*)
		StatusID : DINT; (*- FB Error Status ID.*)
	END_VAR
	VAR
		Internal : Int_DirDelete_typ; (*- FB Internal variables.*)
		zzEdge00000 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK FbDirRead (*- Folder içindekileri okuma FB.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Enable : BOOL; (*- Folder okuma FB.*)
		Execute : BOOL; (*- FB Execute cmd.*)
		ErrorReset : BOOL; (*- FB ErrorReset cmd.*)
		Parameters : Par_DirRead_typ; (*- FB Parameters.*)
	END_VAR
	VAR_OUTPUT
		Active : BOOL; (*- FB Activated.*)
		ListedFile : ARRAY[0..999] OF STRING[80]; (*- Listelenen file lar.*)
		CommandBusy : BOOL; (*- FB CommandBusy flag.*)
		CommandDone : BOOL; (*- FB CommandDone flag.*)
		Error : BOOL; (*- FB Error flag.*)
		StatusID : DINT; (*- FB Error Status ID.*)
	END_VAR
	VAR
		Internal : Int_DirRead_typ; (*- FB Internal variables.*)
		zzEdge00000 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK FbDirCreate (*- Folder olusturma FB.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Enable : BOOL; (*- Folder olusturma FB.*)
		Execute : BOOL; (*- FB Execute cmd.*)
		ErrorReset : BOOL; (*- FB ErrorReset cmd.*)
		Parameters : Par_DirCreate_typ; (*- FB Parameters.*)
	END_VAR
	VAR_OUTPUT
		Active : BOOL; (*- FB Activated.*)
		CommandBusy : BOOL; (*- FB CommandBusy flag.*)
		CommandDone : BOOL; (*- FB CommandDone flag.*)
		Error : BOOL; (*- FB Error flag.*)
		StatusID : DINT; (*- FB Error Status ID.*)
	END_VAR
	VAR
		Internal : Int_DirCreate_typ; (*- FB Internal variables.*)
		zzEdge00000 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK FbFileCreate (*- Folder içerisine File olusturma FB.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Enable : BOOL; (*- Folder olusturma FB.*)
		Execute : BOOL; (*- FB Execute cmd.*)
		ErrorReset : BOOL; (*- FB ErrorReset cmd.*)
		Parameters : Par_FileCreate_typ; (*- FB Parameters.*)
	END_VAR
	VAR_OUTPUT
		Active : BOOL; (*- FB Activated.*)
		CommandBusy : BOOL; (*- FB CommandBusy flag.*)
		CommandDone : BOOL; (*- FB CommandDone flag.*)
		Error : BOOL; (*- FB Error flag.*)
		StatusID : DINT; (*- FB Error Status ID.*)
	END_VAR
	VAR
		Internal : Int_FileCreate_typ; (*- FB Internal variables.*)
		zzEdge00000 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK FbFileWrite (*- File içine yazma FB.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Enable : BOOL; (*- File içerisine yazma FB.*)
		Execute : BOOL; (*- FB Execute cmd.*)
		ErrorReset : BOOL; (*- FB ErrorReset cmd.*)
		Parameters : Par_FileWrite_typ; (*- FB Parameters.*)
		WriteData : STRING[99999]; (*- Okunan data.*)
	END_VAR
	VAR_OUTPUT
		Active : BOOL; (*- FB Activated.*)
		CommandBusy : BOOL; (*- FB CommandBusy flag.*)
		CommandDone : BOOL; (*- FB CommandDone flag.*)
		Error : BOOL; (*- FB Error flag.*)
		StatusID : DINT; (*- FB Error Status ID.*)
	END_VAR
	VAR
		Internal : Int_FileWrite_typ; (*- FB Internal variables.*)
		zzEdge00000 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK FbFileRead (*- File içerisini okuma FB.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Enable : BOOL; (*- File içerisini okuma FB.*)
		Execute : BOOL; (*- FB Execute cmd.*)
		ErrorReset : BOOL; (*- FB ErrorReset cmd.*)
		Parameters : Par_FileRead_typ; (*- FB Parameters.*)
	END_VAR
	VAR_OUTPUT
		ReadData : STRING[99999]; (*- Okunan data.*)
		Active : BOOL; (*- FB Activated.*)
		CommandBusy : BOOL; (*- FB CommandBusy flag.*)
		CommandDone : BOOL; (*- FB CommandDone flag.*)
		Error : BOOL; (*- FB Error flag.*)
		StatusID : DINT; (*- FB Error Status ID.*)
	END_VAR
	VAR
		Internal : Int_FileRead_typ; (*- FB Internal variables.*)
		zzEdge00000 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK FbFileDelete (*- File silme FB.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Enable : BOOL; (*- File silme FB.*)
		Execute : BOOL; (*- FB Execute cmd.*)
		ErrorReset : BOOL; (*- FB ErrorReset cmd.*)
		Parameters : Par_FileDelete_typ; (*- FB Parameters.*)
	END_VAR
	VAR_OUTPUT
		Active : BOOL; (*- FB Activated.*)
		CommandBusy : BOOL; (*- FB CommandBusy flag.*)
		CommandDone : BOOL; (*- FB CommandDone flag.*)
		Error : BOOL; (*- FB Error flag.*)
		StatusID : DINT; (*- FB Error Status ID.*)
	END_VAR
	VAR
		Internal : Int_FileDelete_typ; (*- FB Internal variables.*)
		zzEdge00000 : BOOL;
	END_VAR
END_FUNCTION_BLOCK
