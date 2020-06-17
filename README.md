# `2-poison`

Questo branch estende il progetto [`2-base`](https://github.com/Steffo99/turtle007/tree/2-base) aggiungendo due pozze di veleno che uccidono le formiche che provano a raccoglierlo.

Le formiche morte rilasciano feromoni "negativi", che invitano le formiche circostanti ad evitare l'area con il veleno.

## Ambiente

### Variabili delle patch

Al modello è stata aggiunta una variabile `poison` posseduta dalle patch, che indica se quella particolare patch contiene veleno.

### Aggiunte sorgenti di veleno

Sono state aggiunte due sorgenti di veleno, entrambe di raggio 4:

- `poison1`, di coordinate (14, -18);
- `poison2`, di coordinate (-14, 14), particolarmente utile perché si trova sul percorso minimo per andare ad una delle sorgenti di cibo.

### Aggiunta funzione: t-subtract-pheromone

Questa funzione permette di sottrarre una elevata quantità di feromone dall'ambiente, fino a renderlo negativo: per una formica, è l'eqivalente del rilascio di "feromoni di allarme" volti ad allertare le compagne della presenza di veleno.

```
to t-subtract-pheromone
  ask patch-here [
    set pheromone pheromone - 240
  ]
end
```
### Modifica funzione: t-paint-patch

```
ifelse pheromone >= 0 [
    set pcolor scale-color pheromone-color pheromone 0 pheromone-max
][ 
    set pcolor scale-color poison-color pheromone 0 pheromone-min
]
```

### Comportamento delle formiche

Il comportamento delle formiche è stato cambiato nei seguenti modi:

#### Aggiunta funzione: `t-is-over-poison`

```
to-report t-is-over-poison
  report ([poison] of patch-here = 1)
end
```

#### Aggiunta funzione: `t-try-pick up poison`

```
to t-try-pick-up-poison
  if carrying-food = 0 and t-is-over-poison [
    t-pick-up-poison
  ]
end
```

#### Aggiunta funzione: `t-pick-up-poison`

```
to t-pick-up-poison
  ask patch-here [
    set poison 0
  ]
  t-subtract-pheromone
  die
  rt 180
end
```

## Dinamica del sistema

Come nella precedente versione, le formiche vagano alla ricerca di cibo. Se trovano del veleno, lo raccolgono credendolo cibo, e per questo muoiono. Alla loro morte rilasciano una grande quantità di feromoni negativi, in modo da tentare di evitare che le compagne facciano la stessa fine. Per un po' i ferormoni negativi tengono lontane le formiche, ma con il tempo suddetto feromone evapora, e una nuova formica torna a cadere nella trappola.

Tale trappola è molto efficace se messa sul cammino per una fonte di cibo (come è accaduto con `poison2`): le formiche che trasportano cibo al nido rilasciano feromoni in ogni momento, quindi anche mentre passano sopra al veleno, e questo contribuisce a mitigare l'effetto degli ormoni negativi e a far dirigere ancora più formiche verso la trappola velenosa.
