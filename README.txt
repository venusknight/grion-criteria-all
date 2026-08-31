grION criteria

Sistema de gestão operacional, comercial, financeira e de estoque.

Como rodar em desenvolvimento:
1. Abra esta pasta no VS Code ou no terminal.
2. Crie o ambiente virtual, se ainda não existir:
   py -m venv .venv
3. Ative o ambiente:
   .venv\Scripts\activate
4. Instale as dependências:
   pip install -r requirements.txt
5. Rode o sistema:
   python main.py

Login inicial:
Usuário: admin
Senha: admin123

Banco de dados:
O arquivo grion_criteria.db é criado automaticamente no primeiro uso.
Esse banco não deve ser enviado ao GitHub junto com o código.

Como gerar executável:
1. Rode:
   .\build_exe.bat
2. O executável será criado em:
   dist\grION criteria\grION criteria.exe

Como gerar pacote para envio:
1. Rode:
   .\build_exe_zip_grion.bat
2. O arquivo ZIP será criado na pasta do projeto.

Principais recursos:
- Cadastros de produtos, parceiros, clientes, funcionários e serviços.
- Compras, vendas, faturamento e movimentações.
- Contas a pagar vinculadas às compras.
- Dashboard com critérios reais de estoque, pendências, faturamento e despesas.
- Relatórios XLSX e PDF.
- Datas no padrão DD/MM/AAAA, com conversão automática de entradas como DDMMAAAA "25072025".
- Limpeza segura dos dados operacionais mediante senha da conta logada.
