# Wubot

## Membros
- Artur Souto
- Andres Mejia

## API Commands

### Fruits
- random: Mostra a informação nutricional uma fruta aleatoria.
- all: Mostra a lista completa de frutas.
- 'nome de fruta especifico': Mostra a informaçao nutricional dessa fruta.
`!fruit all
!fruit random
!fruit Apple`

### Bible
- bible: Envia mensagem com uma frase aleatoria da biblia junto com libro, capitulo e versiculo.

### Programming Quote
- programmingquote: Envia frase famosa sobre programação com nome do autor.

### Football
- leagues: Mostra lista de ligas cuja informação esta disponivel.
- seasons 'Codigo da liga': Mostra anos das temporadas disponiveis da liga escolhida.
- 'codigo da liga' 'ano': Mostra a tabela de posições desse ano da lga escolhida.
`!football
!football leagues
!football seasons eng.1
!football eng.1 2016 `

### Covid
- countries '# pagina': Mostra os nomes dos paises na pagina escolhida.
- deaths 'nome do pais': Mostra numeros das mortes no pais especifico.
- cases 'nome do pais': Mostra numeros dos casos no pais especifico.
- recovered 'nome do pais': Mostra conta das pessoas recuperadas no pais especifico.
- recovered 'nome do pais': Mostra conta de casos ativos no pais especifico.
`!covid
!covid countries 1
!covid deaths Brazil
!covid cases Brazil
!covid recovered Brazil
!covid active Brazil`

### Password
- generate '# de carateres': Gera uma senha com o numero de carateres dado, se nao tiver um numero especifico o numero de carateres sera aleatorio.
`!password
!password generate
!password generate 8`

### Programming Contest
- sites: Envia uma lista dos difrentes sites para competiçoes de programação junto com o URL.
- contests 'nome do site' 'today?': Mostra uma lista das competiçoes futuras nesse site. Se a palavra today estiver no final, a lista so tera as competições que aconteceram nas proximas 24 horas.
`!programmingcontest
!programmingcontest sites
!programmingcontest contests codeforces
!programmingcontest contests codeforces today`

### Fox
- mostra imagem de uma raposa

### Crypto
- top10: Mostra as 10 crypto moedas com maior valor em ordem decrescente.
- random: Mostra as informações de uma moeda aleatoria.
- 'Nome da moeda': Mostra as informações da moeda escolhida.

