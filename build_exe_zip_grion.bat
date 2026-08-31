@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo ==========================================
echo GERADOR DO EXECUTAVEL + ZIP
echo grION criteria
echo ==========================================
echo.

set INCLUIR_BANCO=N

set APP_NAME=grION criteria
set ZIP_NAME=grION_criteria_Enviar.zip
set PACKAGE_DIR=pacote_envio

echo Fechando possivel sistema aberto...
taskkill /F /IM "%APP_NAME%.exe" >nul 2>nul

echo.
echo Verificando arquivos principais...
echo.

if not exist main.py (
    echo ERRO: main.py nao encontrado.
    echo Coloque este BAT na mesma pasta do main.py.
    echo.
    pause
    exit /b
)

if not exist assets\logo_empresa.png (
    echo AVISO: assets\logo_empresa.png nao encontrada.
    echo A logo nao sera copiada para a versao final.
    echo.
)

echo Verificando ambiente virtual...
echo.

if not exist .venv (
    echo Criando ambiente virtual...
    py -m venv .venv
)

call .venv\Scripts\activate

echo.
echo Atualizando pip...
python -m pip install --upgrade pip

echo.
echo Instalando dependencias...
pip install pyinstaller

if exist requirements.txt (
    pip install -r requirements.txt
)

echo.
echo Limpando builds anteriores...
if exist build rmdir /s /q build
if exist dist rmdir /s /q dist
if exist "%PACKAGE_DIR%" rmdir /s /q "%PACKAGE_DIR%"
if exist "%APP_NAME%.spec" del /q "%APP_NAME%.spec"
if exist "%ZIP_NAME%" del /q "%ZIP_NAME%"

echo.
echo Gerando executavel...
echo.

if exist icone.ico (
    pyinstaller --noconfirm --clean --onedir --windowed --icon=icone.ico --name "%APP_NAME%" main.py
) else (
    pyinstaller --noconfirm --clean --onedir --windowed --name "%APP_NAME%" main.py
)

if errorlevel 1 (
    echo.
    echo ERRO: O PyInstaller falhou ao gerar o executavel.
    echo Verifique as mensagens acima.
    echo.
    pause
    exit /b
)

echo.
echo Aguardando liberar arquivos internos...
timeout /t 5 /nobreak >nul

echo.
echo Copiando arquivos complementares...
echo.

if exist assets (
    xcopy assets "dist\%APP_NAME%\assets" /E /I /Y >nul
)

if /I "%INCLUIR_BANCO%"=="S" (
    if exist grion_criteria.db (
        copy /Y grion_criteria.db "dist\%APP_NAME%\grion_criteria.db" >nul
        echo Banco atual copiado para a pasta final.
    ) else (
        echo Banco grion_criteria.db nao encontrado. O sistema criara um novo no primeiro uso.
    )
) else (
    echo Banco atual NAO foi copiado. O cliente recebera o sistema limpo.
)

echo.
echo Criando pasta temporaria para envio...
mkdir "%PACKAGE_DIR%" >nul 2>nul

echo.
echo Copiando pasta final para o pacote...
robocopy "dist\%APP_NAME%" "%PACKAGE_DIR%\%APP_NAME%" /E /NFL /NDL /NJH /NJS /R:5 /W:2 >nul

if %ERRORLEVEL% GEQ 8 (
    echo.
    echo ERRO: Nao foi possivel copiar os arquivos para o pacote.
    echo Feche o sistema, feche o Explorador nesta pasta e tente novamente.
    echo.
    pause
    exit /b
)

echo.
echo Criando ZIP para envio...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Compress-Archive -Path '%PACKAGE_DIR%\%APP_NAME%' -DestinationPath '%ZIP_NAME%' -Force -ErrorAction Stop; exit 0 } catch { Write-Host $_.Exception.Message; exit 1 }"

if errorlevel 1 (
    echo.
    echo ERRO: O ZIP nao foi criado.
    echo.
    echo POSSIVEIS SOLUCOES:
    echo 1. Feche o grION criteria.exe se ele estiver aberto.
    echo 2. Feche a pasta dist no Explorador de Arquivos.
    echo 3. Pause o OneDrive temporariamente.
    echo 4. Mova o projeto para C:\grION_criteria e rode novamente.
    echo.
    pause
    exit /b
)

echo.
echo ==========================================
echo PROCESSO FINALIZADO COM SUCESSO!
echo ==========================================
echo.
echo Pasta do executavel:
echo dist\%APP_NAME%
echo.
echo Arquivo para enviar ao cliente:
echo %ZIP_NAME%
echo.
echo INSTRUCAO PARA O CLIENTE:
echo 1. Extrair o ZIP em uma pasta.
echo 2. Abrir a pasta extraida.
echo 3. Executar "%APP_NAME%.exe".
echo 4. Criar atalho na area de trabalho, se desejar.
echo.
echo IMPORTANTE:
echo Nao abrir o EXE diretamente de dentro do ZIP.
echo Primeiro precisa extrair.
echo ==========================================
echo.

pause

