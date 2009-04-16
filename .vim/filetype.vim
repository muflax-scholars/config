" myfiletypefile

augroup filetypedetect
    autocm! BufRead,BufNewFile *.ifm    setfiletype ifm
augroup END
