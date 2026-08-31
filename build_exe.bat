@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo ==========================================
echo GERADOR DO EXECUTAVEL - grION criteria
echo ==========================================
echo.

if not exist main.py (
    echo ERRO: O arquivo main.py nao foi encontrado nesta pasta.
    echo Coloque este build_exe.bat na mesma pasta do main.py.
    echo.
    pause
    exit /b
)

if not exist assets\logo_empresa.png (
    echo AVISO: assets\logo_empresa.png nao foi encontrada.
    echo O sistema sera gerado sem a logo dentro da tela.
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
if exist "grION criteria.spec" del /q "grION criteria.spec"

echo.
echo Gerando executavel...
echo.

if exist icone.ico (
    pyinstaller --noconfirm --clean --onedir --windowed --icon=icone.ico --name "grION criteria" main.py
) else (
    pyinstaller --noconfirm --clean --onedir --windowed --name "grION criteria" main.py
)

echo.
echo Copiando arquivos extras...
echo.

if exist grion_criteria.db (
    copy /Y grion_criteria.db "dist\grION criteria\grion_criteria.db" >nul
)

if exist assets (
    xcopy assets "dist\grION criteria\assets" /E /I /Y >nul
)

echo.
echo ==========================================
echo EXECUTAVEL GERADO COM SUCESSO!
echo ==========================================
echo.
echo Abra a pasta:
echo dist\grION criteria
echo.
echo Arquivo principal:
echo grION criteria.exe
echo.
echo IMPORTANTE:
echo Nao tire o EXE de dentro da pasta dist\grION criteria.
echo Crie apenas um atalho na area de trabalho.
echo.
echo A pasta assets deve ficar junto do EXE.
echo ==========================================
echo.

pause

