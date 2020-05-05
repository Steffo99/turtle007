# `2-death-and-rebirth`

Questo progetto estende il progetto [`2-ant-apocalypse`](https://github.com/Steffo99/turtle007/tree/2-ant-apocalypse) permettendo alle formiche di riprodursi nel caso che il cibo accumulato nel nido superi una certa soglia.

## Attivazione / Disattivazione

Le feature di questo branch possono venire abilitate o disabilitate con gli switch `enable-birth`.

## Formiche

Le modifiche in questo ambito sono le seguenti:  
- Ad ogni `tick`, nel caso in cui si superi una certa soglia di cibo che può essere modificata con il controllo `food-surplus-threshold`, il nido userà una certa quantità di cibo (`ant-food-cost`) per creare una nuova formica.
