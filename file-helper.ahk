#Requires AutoHotkey v2.0

; remove line after keyword
RemoveLineAfterKeyword(FilePath, Keyword)
{
    ; Read the file content
    FileContent := FileRead(FilePath)
    if !FileContent {
        MsgBox "Could not read file!"
        return
    }

    ; Initialize a variable to store the modified content
    ModifiedContent := ""
    FoundKeyword := false  ; To track if the keyword has been found
    SkipNextLine := false  ; To track if the next line should be skipped

    ; Split the content into lines and iterate
    for Line in StrSplit(FileContent, "`n") {
        if SkipNextLine {
            SkipNextLine := false  ; Reset skip flag after skipping one line
            continue  ; Skip this line
        }

        ; Check if this line contains the keyword and it hasn't been found before
        if !FoundKeyword && InStr(Line, Keyword) {
            FoundKeyword := true
            SkipNextLine := true  ; Set the flag to skip the next line
        }
        ; Rebuild the modified content
        ModifiedContent .= Line "`n"
    }

    ; Write the modified content back to the file
    FileDelete(FilePath)  ; Delete the old file
    FileAppend(ModifiedContent, FilePath)  ; Write the new content
}

; append text to line at keyword
FileAppendToLine(filePath, keyword, appendText)
{
    ; Read the file content
    FileContent := FileRead(filePath)
    if !FileContent
    {
        MsgBox "Could not read file!"
        return
    }

    ; Initialize a variable to store the modified content
    ModifiedContent := ""

    ; Split the content into lines and iterate
    for Line in StrSplit(FileContent, "`n")
    {
        ; Check if the line contains the keyword
        if InStr(Line, keyword)
        {
            ; Append text to this line
            Line .= appendText
        }

        ; Rebuild the modified content
        ModifiedContent .= Line "`n"
    }

    ; Write the modified content back to the file
    FileDelete(FilePath)  ; Delete the old file
    FileAppend(ModifiedContent, FilePath)  ; Write the new content
}
