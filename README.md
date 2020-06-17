# `1-efficiency-tiredness`

Questo progetto estende il progetto [`1-base`](https://github.com/Steffo99/turtle007/tree/1-base) aggiungendo parametri di stanchezza e controlli di efficienza alle termiti.

## Ambiente NetLogo

### Aggiunti toggle

Aggiunti due toggle, `Efficiency` e `Tiredness`, che attivano e disattivano le due funzioni.

### Aggiunto slider

Aggiunto slider `EnergyLostPerAction`, settata di defaut al 20%, che regola l'energia persa dalle formiche per ogni azione non andata a buon fine.

## Comportamento delle formiche

### Aggiunti boolean `efficient?` e `tired?`

Al programma netLogo sono state aggiunte le seguenti due funzioni booleane:

#### `efficient?`

```
to-report efficient? [needEmptyArea]
  ; Funzione booleana che dice se è efficiente eseguire l'azione che la evoca
  ; needEmptyArea è un bool che mi definisce l'obiettivo tra:
  ; - cercare una zona semi-vuota da cui prelevate cibo (true)
  ; - cercare una zona semi-piena in cui appoggiare il cibo (false)

  ; se non ho attivato la modalità efficiente, il bool è sempre soddisfatto
  if not Efficiency [report true]

  ; altrimenti, entra in gioco il needEmptyArea
  ifelse needEmptyArea [ 
    ; è considerata "vuota" un'area in cui ci sia meno del 40% di caselle con del cibo
    report (count patches in-radius 2 with [pcolor != black] /
    count patches in-radius 2 < 0.4)
  ][ 
    ; è considerata "piena" un'area in cui ci sia più del 40% di caselle con del cibo
    report (count patches in-radius 2 with [pcolor != black] /
    count patches in-radius 2 > 0.4)
  ]
end
```
#### tired?
```
to-report tired? [energy]
; Funzione booleana che monitora l'energia rimasta alla termite

  ; se non ho attivato la modalità tiredness, la formica avrà sempre energia sufficiente
  ; altrimenti, controllo se l'energia rimasta è sufficiente
  ifelse not tiredness [
    report false
  ][
    report (energy < random-float 10)
  ]
end
```
### Modificate condizioni

Sono state modificate alcune condizioni all'interno del programma, aggiungendovi `efficient?` o `tired?` a seconda della situazione.

Nello specifico sono stati aggiunti:

- un `or not efficient?(true)` dentro al `while[ pcolor = black ]` nella funzione `cerca-cibo`. In questo modo la formicha continuerà a vagare alla ricerca di cibo anche dopo averne visto, se non considererà efficiente raccoglierlo;

- un `or not efficient?(false)` è stato invece messo nella `appoggia-cibo`, nel `while[ pcolor != black ]`. La formica vagherà cercando un posto dove appoggiare cibo finchè non troverà una patch vuota E in cui appoggiare cibo sia efficiente;

- un `and not tired?(energy)` all'interno del `while[ pcolor != black ]` nella funzione `allontanati`. La formica potrebbe smettere di allontanarsi se stanca.

All'interno di `allontanati` è stato inoltre aggiunto un meccanismo che riduceva l'energia della formica ad ogni ciclo del while.

## Dinamica del sistema

Quando `Efficiency` sarà attivo, le formiche preleveranno e appoggeranno cibo solo se questa azione è efficiente. Questo porta a meno "spostamenti indesiderati" e a gruppi di cibo più tondeggianti e dai contorni ben definiti. All'inizio, con il cibo molto sparso, le formiche formeranno gruppi molto velocemente, ma appena ogni gruppo raggiungerà una certa dimensione il sistema subirà un brusco rallentamento.

Quando `Tiredness` sarà attivo, le formiche avranno una chance di smettere di allontanarsi prima di aver trovato una pezza con del cibo. Questo prota alla formazione di gruppi più frastagliati.

Quando entrambi gli switch saranno attivi, il comportamento descritto da `Efficiency` avrà la predominanza sul `Tiredness`.
