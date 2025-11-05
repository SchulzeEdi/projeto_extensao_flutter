# InsuGuia Mobile — Extensão do Curso de Sistemas de Informação (T28)

- Alunos: @[CaioMicael] e @[SchulzeEdi]
  (https://github.com/CaioMicael)
  (https://github.com/SchulzeEdi)
- Tema: Extensão em Saúde — InsuGuia Mobile

## Descrição
Projeto de Extensão do Curso de Sistemas de Informação (T28) para desenvolvimento de um protótipo de aplicativo móvel em Flutter chamado "InsuGuia Mobile". O objetivo é possibilitar a interação dialógica entre acadêmicos e a sociedade em demandas reais da área da saúde, aplicando conhecimentos de Plataformas Móveis.

> Protótipo acadêmico sem validade clínica — serve como prova de conceito para apoio à prescrição e manejo da hiperglicemia hospitalar.

## Propósito
Possibilitar que o acadêmico tenha uma interação dialógica com a sociedade envolvendo questões sociais e contemporâneas, gerando conhecimento e promovendo mudanças nas comunidades por meio da articulação entre Ensino, Práticas Investigativas e Extensão.

O projeto está vinculado aos programas de apoio à Extensão da Unidavi, incluindo (exemplos):
- Cultura, História e Arte
- Desenvolvimento Regional
- Desenvolvimento e Cidadania
- Sustentabilidade e Responsabilidade Ambiental
- Universidade Solidária
- Vida em Equilíbrio
- Educação Continuada

## Objetivo
Permitir que os acadêmicos desenvolvam um protótipo de aplicativo móvel em Flutter aplicando conceitos e conhecimentos do curso, em especial na disciplina de Plataformas Móveis, a partir de uma demanda real da área da saúde.

## Contexto
Demanda apresentada pelo Endocrinologista Dr. Itairan da Silva Terres para criar ferramentas digitais que apoiem o manejo da hiperglicemia hospitalar conforme diretrizes da Sociedade Brasileira de Diabetes. O app deverá auxiliar profissionais na prescrição de insulina para pacientes internados.

## Escopo Acadêmico
- Desenvolver um protótipo em Flutter.
- Implementar o cenário "Paciente Não Crítico" com regras básicas de cálculo e geração de prescrição sugerida.
- Resultado esperado: protótipo acadêmico (sem validade clínica) como prova de conceito.

## Funcionalidades
- Cadastro de paciente: peso, altura, creatinina.
- Classificação clínica: nesta versão apenas o cenário não crítico terá cálculos implementados.
- Sugestão de prescrição (texto e/ou tabela simples) com itens como:
  - dieta, monitorização glicêmica, insulina basal, insulina de ação rápida e orientações para hipoglicemia.

## Como usar (instruções iniciais de desenvolvimento)
Pré-requisitos:
- Flutter SDK instalado (versão estável recomendada).
- Editor (VS Code, Android Studio, etc.).

Passos básicos para iniciar o desenvolvimento localmente:
1. Clonar o repositório:

```powershell
git clone <repo-url>
cd projeto_extensao_flutter
```

2. Instalar dependências:

```powershell
flutter pub get
```

3. Se as pastas de plataforma (web/windows/android/ios) não existirem, gere-as com:

```powershell
flutter create .
```

4. Rodar no navegador (Chrome) para teste rápido:

```powershell
flutter run -d chrome
```

5. Para rodar no Windows (desktop), certifique-se de que o Visual Studio possui o workload "Desktop development with C++" instalado e então:

```powershell
flutter run -d windows
```

## Estrutura do repositório (resumida)
- `lib/` — código-fonte Flutter (UI, modelos, serviços, telas)
- `flutter/` — (pasta de apoio; confirme a organização do projeto)
- `pubspec.yaml` — dependências e metadados do projeto