# sistema_equipamento

![image](https://github.com/user-attachments/assets/84d41460-a4e6-481e-91f5-9261bf06893c)

Tela de Login
Objetivo:
Permitir que o usuário insira suas credenciais para acessar o sistema de gerenciamento de equipamentos.

Funcionamento:

A tela apresenta um formulário simples com dois campos:
Usuário: Entrada para o nome de usuário.
Senha: Entrada para a senha, com o texto ocultado.
Há um botão Entrar, estilizado com a cor azul, que valida as credenciais ao ser pressionado.
As credenciais são verificadas localmente (mockUsername e mockPassword no código).
Se estiverem corretas:
O usuário é redirecionado para a tela de equipamentos.
Caso contrário:
Uma caixa de diálogo é exibida com uma mensagem de erro.

![image](https://github.com/user-attachments/assets/474f5f43-a262-44c3-a622-4cd1295b29a4)

Tela de Equipamentos
Objetivo:
Exibir uma lista de equipamentos cadastrados e permitir ao usuário atualizar o inventário de cada equipamento.

Funcionamento:

Lista de Equipamentos:
Cada equipamento é exibido em um Card com:
Nome do equipamento.
Código único (QR Code ou identificador).
Data do último inventário.
Status do inventário:
"Inventário válido" (verde) se o último inventário foi há menos de 30 dias.
"Necessário realizar inventário" (vermelho) se passou mais tempo.
Botão "Inventariar":
Atualiza a data do último inventário para o momento atual.
O botão muda de cor com base no status:
Verde para válido.
Vermelho para necessário.
Botões na AppBar:
Scanner de QR Code: Permite escanear o código de um equipamento e atualizar seu status.
Acesso à Administração: Redireciona para a tela de administração.


![image](https://github.com/user-attachments/assets/8fceb833-e186-4246-9627-4373e260c2de)

Tela de Administração
Objetivo:
Gerenciar os equipamentos vinculados ao sistema.

Funcionamento:

Lista de Equipamentos Vinculados:
Semelhante à tela de equipamentos, cada equipamento é exibido em um Card.
Cada card inclui:
Nome do equipamento.
Código do equipamento.
Botão "Excluir" (ícone de lixeira):
Remove o equipamento da lista vinculada.
Atualiza a lista na interface.
Botão para Adicionar Novo Equipamento:
Posicionado no centro inferior da tela.
Permite escanear o QR Code de um novo equipamento e adicioná-lo à lista vinculada.
Design:
Segue o padrão visual da aplicação:
Fundo branco.
Azul e verde como cores principais.
O botão "Adicionar novo equipamento" é estilizado em verde (PMS 2285 C).
Ação ao adicionar equipamento:

O sistema registra um novo equipamento na lista vinculada ao escanear um QR Code.
Ação ao excluir equipamento:

O equipamento é removido imediatamente da lista e da interface.
