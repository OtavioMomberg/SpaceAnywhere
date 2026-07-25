### Projeto: SpaceAnywhere

## Visão Geral:

- O aplicativo tem como objetivo divulgar conhecimentos de astronomia de forma acessiva
- O aplicativo será completamente gratuito

## Funcionalidades:

1. Mostrar uma curiosidade sobre astronomia por dia
2. Adicionar a opção de "saiba mais" para aprofundamento do conteúdo
3. Disponibilizar um quiz, contendo 5 alternativas para cada pergunta
4. Fazer uma comparação entre alguns objetos astronômicos
5. Permitir a realização do download de wallpapers disponíveis no aplicativo
6. Permitir o usuário visualizar seu peso em outros planetas e objetos astronômicos
7. Demonstrar o nome de objetos astronômicos em outros idiomas

## Stack do Projeto:

# Backend (API):

- Python (FastAPI)
- SQLAlchemy ORM

# Endpoints da API:

- GET "api/v1/curiosity"

Return Type:

```json
{
    "id": 0,
    "title": "Titulo Exemplo",
    "short_answer": "Resposta curta exemplo",
    "long_answer": "Resposta longa exemplo",
    "content_font": ["https://astronomia.com", ...]
}
```

- GET "api/v1/quiz"
    
Return Type:

```json
{
    "id" : 0 (int),
    "question" : "Pergunta exemplo?" (string),
    "alternatives" : ["alternativa 1", ...] (List[string]),
    "right_answer_index" : 0 (int),
}
```

- GET "api/v1/wallpaper"

Return Type:

```json
{
    "id" : 0 (int),
    "thumbnail_image_url" : "exemplo_thumbnail/imagem" (string),
    "full_image_url": "exemplo_full_image/imagem" (string),
}
```

- GET "api/v1/translation" - (Ainda não implementado)

Return Type:

```json
{
    "id" : 0 (int),
    "object_translated" : "Exemplo" (string),
    "language_flag": "pt-BR" (string),
}
```

# Database (Supabase - PostgreSQL):

- curiosity_table:
    - id - int,
    - title - string,
    - short_answer - string,
    - long_answer - string

- question_table:
    - id - int,
    - question - string,
    - alternatives - array,
    - right_answer_index - int
    - content_font - array

- wallpaper_table:
    - id - int,
    - thumbnail_image_url - string,
    - full_image_url - string

(Ainda não implementadas)
- astronomical_object_table:
    - id - int,
    - name (unique) - string

- language_table:
    - id - int,
    - lang (unique) - string

- translation_table:
    - id - int,
    - translated - string,
    - language_flag - string,
    - astronomical_object_fk - int,
    - language_fk - int

(
    SELECT t.id, t.object_translated, t.language_flag 
    FROM ASTRONOMICAL_OBJECT_TABLE a 
    JOIN TRANSLATION_TABLE t ON a.id = t.id
    JOIN LANGUAGE_TABLE l ON t.id = l.id
    WHERE a.object_name = 'EXEMPLO' AND l.language = 'EXEMPLO';
)

# Frontend (Mobile):

- Dart/Flutter

# Design:

- Background de todo o app será composto por um gradiente entre 3 cores focadas em tons escuros de azul até o preto,
- Desenvolver Widgets com o foco em glass style

# Navigation:

- O aplicativo irá utilizar o sistema de Drawer contendo as seguintes pagínas:

1. HomePage - Essa tela terá a sessão de curiosidade do dia (Talvez alguma outra coisa também ou algum tipo de introdução)

2. QuizPage - Essa tela conterá as perguntas com as 5 alternativas cada pergunta, mostrando uma pergunta por vez tendo 2 tentativas para 
acertar a resposta, caso erre, será mostrada a resposta correta e a opção de passar para a proxíma pergunta

3. ComparisonPage - Essa tela será responsável por mostrar uma breve comparação entre objetos astronômicos como planetas, estrelas...

4. WallpaperPage - Essa tela disponibilizará uma serie de wallpapers com a tematíca de espaço para poderem ser instalados pelos usuários

5. CalculatorPage - Essa tela irá disponibilizar uma calculadora para o usuário calcular seu peso em outros planetas

# Additional Page:

- DetailReadingPage - Essa tela contará com um texto mais aprofundado a respeito da curiosidade do dia (Futuramente podendo ser expandido em outros contextos)

## Próximos Passos

- Desenvolver uma tela para mostrar os objetos astronômicos em outros idiomas, incluindo a pronúncia

- Desenvolver uma tela na qual haverá a explicação de formúlas físicas e matemáticas;
