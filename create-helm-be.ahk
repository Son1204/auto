#Requires AutoHotkey v2.0
#SingleInstance Force

^k:: {
    ingressDevEnable := "false"
    ingressDevHost := "https://xspace-dev.cmctelecom.vn"
    enableOpa := "false"

    TargetFolder := DirSelect(A_WorkingDir, 1, "Chon thu muc tao helm be")
    if TargetFolder = ""
        return

    DirDelete TargetFolder, true
    DirCopy A_WorkingDir "/template/helm-be/template-service", TargetFolder, 1

    ; base info project
    projectNameCode := "#{project-name}"
    ingressDevEnableCode := "#{ingress-enable-dev}"
    ingressDevHostCode := "#{ingress-dev-host}"
    enableOpaCode := "#{enable-opa}"

    SplitPath TargetFolder, &projectName

    ; replace param in files
    Loop Files, TargetFolder "\*.*", "R"  ; Recurse into subfolders.
    {
        if RegExMatch(A_LoopFilePath, "i)templates")
            continue

        ; MsgBox A_LoopFilePath
        contentOfFile := FileRead(A_LoopFilePath)
        contentOfFileAfterProcess := StrReplace(contentOfFile, projectNameCode, projectName)
        contentOfFileAfterProcess := StrReplace(contentOfFileAfterProcess, ingressDevEnableCode, ingressDevEnable)
        contentOfFileAfterProcess := StrReplace(contentOfFileAfterProcess, ingressDevHostCode, ingressDevHost)
        contentOfFileAfterProcess := StrReplace(contentOfFileAfterProcess, enableOpaCode, enableOpa)
        file := FileOpen(A_LoopFilePath, "w")
        file.Write(contentOfFileAfterProcess)
        file.Close
    }
    MsgBox "Tao config heml be thanh cong, dir: " TargetFolder, "Thong bao"
    ExitApp
}