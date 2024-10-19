#Requires AutoHotkey v2.0
#SingleInstance Force

^k:: {

    BOM_VERSION := "3.21.0"
    DATABASE_URL := ""
    DATABASE_USERNAME := ""
    DATABASE_PASSWORD := ""
    GRADLE_URL := "https\://services.gradle.org/distributions/gradle-8.4-bin.zip"

    TargetFolder := DirSelect(A_WorkingDir, 1, "Chon thu muc")
    if TargetFolder = ""
        return

    DirDelete TargetFolder, true
    DirCopy A_WorkingDir "/template/template-code-be", TargetFolder, 1

    ; base info project
    projectNameCode := "#{project-name}"
    packageNameCode := "#{package-name}"
    bomVersionCode := "#{insight-bom-version}"
    classNameCode := "#{class-name}"

    ;database config
    databaseUrlCode := "#{database-url}"
    usernameCode := "#{database-username}"
    passwordCode := "#{database-password}"

    ; gradle
    gradleUrlCode := "#{gradle-url}"


    SplitPath TargetFolder, &projectName
    ; MsgBox projectName

    ; rename folder
    DirMove TargetFolder "/template-api", TargetFolder "/" projectName "-api", "R"
    DirMove TargetFolder "/template-service", TargetFolder "/" projectName "-service", "R"

    apiFolder := TargetFolder "/" projectName "-api/src/main/java/vn/cmctelecom/dx/template"
    serviceFolder := StrReplace(apiFolder, "-api", "-service")
    DirMove apiFolder, TargetFolder "/" projectName "-api/src/main/java/vn/cmctelecom/dx/" projectName, "R"
    DirMove serviceFolder, TargetFolder "/" projectName "-service/src/main/java/vn/cmctelecom/dx/" projectName, "R"

    DirMove TargetFolder "/_charts/template-service", TargetFolder "/_charts/" projectName "-service", "R"

    className := StrReplace(StrTitle(StrReplace(projectName, "-", " ")), " ", "")
    ; rename file application
    FileMove TargetFolder "/" projectName "-service/src/main/java/vn/cmctelecom/dx/" projectName "/TemplateServiceApplication.java", TargetFolder "/" projectName "-service/src/main/java/vn/cmctelecom/dx/" projectName "/" className "ServiceApplication.java"

    ; replace param in files
    Loop Files, TargetFolder "\*.*", "R"  ; Recurse into subfolders.
    {
        if RegExMatch(A_LoopFilePath, "i)templates")
            continue

        ; MsgBox A_LoopFilePath
        contentOfFile := FileRead(A_LoopFilePath)
        contentOfFileAfterProcess := StrReplace(contentOfFile, projectNameCode, projectName)
        contentOfFileAfterProcess := StrReplace(contentOfFileAfterProcess, packageNameCode, StrReplace(projectName, "-", ""))
        contentOfFileAfterProcess := StrReplace(contentOfFileAfterProcess, bomVersionCode, BOM_VERSION)
        contentOfFileAfterProcess := StrReplace(contentOfFileAfterProcess, classNameCode, className)
        contentOfFileAfterProcess := StrReplace(contentOfFileAfterProcess, databaseUrlCode, DATABASE_URL)
        contentOfFileAfterProcess := StrReplace(contentOfFileAfterProcess, usernameCode, DATABASE_USERNAME)
        contentOfFileAfterProcess := StrReplace(contentOfFileAfterProcess, passwordCode, DATABASE_PASSWORD)
        contentOfFileAfterProcess := StrReplace(contentOfFileAfterProcess, gradleUrlCode, GRADLE_URL)
        file := FileOpen(A_LoopFilePath, "w")
        file.Write(contentOfFileAfterProcess)
        file.Close
    }
    MsgBox "Tao project be thanh cong, dir: " TargetFolder, "Thong bao"
    ExitApp
}