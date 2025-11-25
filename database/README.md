# Instruções para Configuração do Banco PostgreSQL

## Pré-requisitos

1. **PostgreSQL instalado** no sistema
2. **Credenciais de acesso**:
   - Usuário: `postgres`
   - Senha: `postgres`
   - Host: `localhost`
   - Porta: `5432`

## Configuração do Banco de Dados

### 1. Criar o Banco de Dados

Conecte-se ao PostgreSQL como superusuário e execute:

```sql
CREATE DATABASE insuguia_mobile;
```

### 2. Executar o Schema

1. Conecte-se ao banco `insuguia_mobile`
2. Execute o script `database/schema.sql` completo

Ou via linha de comando:

```bash
psql -U postgres -d insuguia_mobile -f database/schema.sql
```

### 3. Verificar as Tabelas

Após executar o schema, você deve ter:

- Tabela `paciente` com campos: id, nome, sexo, data_nascimento, peso, altura, created_at, updated_at
- Tabela `acompanhamento_diario` com campos: id, paciente_id, data_acompanhamento, creatinina, peso, nivel_glicose, prescricao_gerada, created_at
- Enum `gender_enum` com valores 'M' e 'F'
- Índices para performance
- Triggers para atualização automática de timestamps

## Testando a Conexão

Execute o aplicativo Flutter:

```bash
flutter run
```

Se a conexão estiver correta, você poderá:
1. Cadastrar novos pacientes
2. Criar prescrições diárias
3. Ver os dados sendo salvos no PostgreSQL

## Problemas Comuns

### Erro de Conexão

- Verifique se o PostgreSQL está rodando
- Confirme usuário/senha no arquivo `lib/services/database_service.dart`
- Verifique se o banco `insuguia_mobile` foi criado

### Erro de Schema

- Execute o script `schema.sql` novamente
- Verifique se todas as tabelas foram criadas corretamente

### Dependências Flutter

Se houver problemas com packages:

```bash
flutter clean
flutter pub get
```

## Dados de Exemplo

O schema inclui comentários para inserir dados de teste opcionais. Descomente as linhas no final do `schema.sql` se quiser dados de exemplo.