# `2-ant-apocalypse`

Questo progetto estende il progetto [`2-base`](https://github.com/Steffo99/turtle007/tree/2-base) tenendo traccia del cibo accumulato dalle formiche nel loro formicaio e facendole morire lentamente nel caso che esso finisca.

Inoltre, fa ricomparire il cibo nell'ambiente a intervalli irregolari di tempo.

## Attivazione / Disattivazione

Le feature di questo branch possono venire abilitate o disabilitate con gli switch `enable-hunger` e `enable-food-respawn`.

## Ambiente

Le modifiche in questo ambito sono le seguenti:  

- Il nido tiene conto di quanto cibo vi venga depositato.  
- Il cibo ha la possibilità di ricomparire dopo un certo numero di `tick`.  
    - Il numero di tick può essere modificato dall'utente interagendo con il controllo `food-ticks`.  
    - La probabilità può essere modificata dall'utente con lo slider `food-respawn-pct`. 

## Formiche

Le modifiche in questo ambito sono le seguenti:  

- Ad ogni tick, le formiche hanno una certa probabilità di aumentare il loro valore `hunger` (che parte da 0) di una certa quantità.   
    - La probabilità può essere alterata dall'utente interagendo con lo slider `hunger-increase-pct`.  
    - La quantità può essere modificata dall'utente interagendo con il controllo `hunger-per-tick`. 
- Nel caso in cui il valore `hunger` della formica superi una certa soglia (`hunger-threshold`), la formica si mette alla ricerca del cibo per sopravvivere. Se il valore `hunger` supera il parametro `hunger-max`, la formica muore.  
    - Se la formica sta trasportando cibo, mangia il cibo che sta trasportando.  
    - Se la formica non sta trasportando cibo, si reca al nest sperando di trovarne lì.  
