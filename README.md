# Wubot

## Membros
- Artur Souto
- Andres Mejia

## API Commands

### Fruits
- random: Mostra a informação nutricional uma fruta aleatoria.
- all: Mostra a lista completa de frutas.
- 'nome de fruta especifico': Mostra a informaçao nutricional dessa fruta.

Exemplo de uso:

`!fruit all`

`!fruit random`

`!fruit Apple`

### Bible
- bible: Envia mensagem com uma frase aleatoria da biblia junto com libro, capitulo e versiculo.

Exemplo de uso:

`!bible`

### Football
- leagues: Mostra lista de ligas cuja informação esta disponivel.
- seasons 'Codigo da liga': Mostra anos das temporadas disponiveis da liga escolhida.
- 'codigo da liga' 'ano': Mostra a tabela de posições desse ano da lga escolhida.

Exemplo de uso:

`!football`

`!football leagues`

`!football seasons eng.1`

`!football eng.1 2016 `

### Programming Quote
- programmingquote: Envia frase famosa sobre programação com nome do autor.

Exemplo de uso:

`!programmingquote`

### Covid
- countries '# pagina': Mostra os nomes dos paises na pagina escolhida.
- deaths 'nome do pais': Mostra numeros das mortes no pais especifico.
- cases 'nome do pais': Mostra numeros dos casos no pais especifico.
- recovered 'nome do pais': Mostra conta das pessoas recuperadas no pais especifico.
- recovered 'nome do pais': Mostra conta de casos ativos no pais especifico.

Exemplo de uso:

`!covid`

`!covid countries 1`

`!covid deaths Brazil`

`!covid cases Brazil`

`!covid recovered Brazil`

`!covid active Brazil`

### Fox
- mostra imagem de uma raposa

Exemplo de uso:

`!fox`

### Password
- generate '# de carateres': Gera uma senha com o numero de carateres dado, se nao tiver um numero especifico o numero de carateres sera aleatorio.

Exemplo de uso:

`!password`

`!password generate`

`!password generate 8`

### Crypto
- top10: Mostra as 10 crypto moedas com maior valor em ordem decrescente.
- random: Mostra as informações de uma moeda aleatoria.
- 'Nome da moeda': Mostra as informações da moeda escolhida.

Exemplo de uso:

`!crypto`

`!crypto random`

`!crypto top10`

`!crypto bitcoin`

### Programming Contest
- sites: Envia uma lista dos diferentes sites para competiçoes de programação junto com o URL.
- contests 'nome do site' 'today?': Mostra uma lista das competiçoes futuras nesse site. Se a palavra today estiver no final, a lista so tera as competições que aconteceram nas proximas 24 horas.

Exemplo de uso:

`!programmingcontest`

`!programmingcontest sites`

`!programmingcontest contests codeforces`

`!programmingcontest contests codeforces today`

### IsEven
- 'número': mostra se número é par ou ímpar

Exemplo de uso:

`!iseven`

`!iseven 5`
