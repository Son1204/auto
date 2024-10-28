#Requires AutoHotkey v2.0
#SingleInstance Force

^k:: {

    TargetFolder := DirSelect(A_WorkingDir, 1, "Chon project can ap dung sonarqube")
    if TargetFolder = ""
        return

    ; if FileExist(A_WorkingDir "/output.gradle")
    ;     FileDelete A_WorkingDir "/output.gradle"

    AddAtLine(TargetFolder "/settings.gradle", 14, "    id 'org.sonarqube' version `"${sonarVersion}`" apply false")
    AddAtLine(TargetFolder "/gradle.properties", 26, "sonarVersion=4.2.1.3168")
    AddAtLine(TargetFolder "/build.gradle", 11, "    apply plugin: 'org.sonarqube'")

    
    ; Loop read, TargetFolder "/settings.gradle", TargetFolder "/settings.gradle"
    ; {
    ;     FileAppend(A_LoopReadLine "`n")
    ;     if InStr(A_LoopReadLine, "id 'io.spring.dependency-management' version")
    ;         FileAppend("    id 'org.sonarqube' version `"${sonarVersion}`" apply false`n")
    ; }

    ; FileAppend "Another line.`n", TargetFolder "/gradle.properties"

    ; Loop read, TargetFolder "/build.gradle", TargetFolder "/build.gradle"
    ; {
    ;     FileAppend(A_LoopReadLine "`n")
    ;     if InStr(A_LoopReadLine, "apply plugin: 'io.spring.dependency-management'")
    ;         FileAppend("    apply plugin: 'org.sonarqube'`n")
    ; }


    ; ingressDevEnable := "false"
    ; ingressDevHost := "https://xspace-dev.cmctelecom.vn"
    ; enableOpa := "false"

    ; TargetFolder := DirSelect(A_WorkingDir, 1, "Chon thu muc tao helm be")
    ; if TargetFolder = ""
    ;     return

    ; DirDelete TargetFolder, true
    ; DirCopy A_WorkingDir "/template/helm-be/template-service", TargetFolder, 1

    ; ; base info project
    ; projectNameCode := "#{project-name}"
    ; ingressDevEnableCode := "#{ingress-enable-dev}"
    ; ingressDevHostCode := "#{ingress-dev-host}"
    ; enableOpaCode := "#{enable-opa}"

    ; SplitPath TargetFolder, &projectName

    ; ; replace param in files
    ; Loop Files, TargetFolder "\*.*", "R"  ; Recurse into subfolders.
    ; {
    ;     if RegExMatch(A_LoopFilePath, "i)templates")
    ;         continue

    ;     ; MsgBox A_LoopFilePath
    ;     contentOfFile := FileRead(A_LoopFilePath)
    ;     contentOfFileAfterProcess := StrReplace(contentOfFile, projectNameCode, projectName)
    ;     contentOfFileAfterProcess := StrReplace(contentOfFileAfterProcess, ingressDevEnableCode, ingressDevEnable)
    ;     contentOfFileAfterProcess := StrReplace(contentOfFileAfterProcess, ingressDevHostCode, ingressDevHost)
    ;     contentOfFileAfterProcess := StrReplace(contentOfFileAfterProcess, enableOpaCode, enableOpa)
    ;     file := FileOpen(A_LoopFilePath, "w")
    ;     file.Write(contentOfFileAfterProcess)
    ;     file.Close
    ; }
    MsgBox "Tao config heml be thanh cong, dir: ", "Thong bao"
    ExitApp
}

AddAtLine(Path, LineNum, Content)
{
	file := FileOpen(Path, 0x3|0x4)
	if (!file)
		return
	buffer := file.Read()
	array := StrSplit(buffer, "`n")
	array.InsertAt(LineNum, Content)
	buffer := ""
	for _,line in array
		buffer .= line "`n"
	file.Seek(0)
	file.Write(buffer)
}