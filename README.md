# `2-random-mutation`

Questo branch estende il progetto [`2-evoluzione`](https://github.com/Steffo99/turtle007/tree/2-evoluzione).

In questa versione viene aggiunta l'aspetto della mutazione casuale nel modello: le caratteristiche migliori, come la velocità più alta o il metabolismo più basso, possono venire ottenute solo mediante mutazione in quanto non presenti nella popolazione originale.

## Ambiente

### Variabili globali

Sono state aggiunte al modello le seguenti variabili globali:

- `mutazioni`, contiene il numero di mutazioni che si sono verificate dall'inizio della simulazione;
- `mutation-chance`, la probabilità che si verifichi una mutazione;
- `max-speed-with-mutation`, la velocità massima ottenibile mediante mutazione.

### Comportamento delle formiche

Il comportamento delle formiche è stato cambiato nei seguenti modi:

#### Modificato: `t-hatch`

```diff
 let partners t-partners
 if any? partners [
   let partner item 0 sort-on [hunger] partners
   let parents (turtle-set self partner)
   ask parents [
     set hunger hunger - reproduction-cost
   ]
   hatch-ants 1 [
     t-setup-ant
+    ifelse random 100 > mutation-chance [t-inherit parents]
+    [t-mutation
+    set mutazioni (mutazioni + 1)]
+  ]
   set ant-hatches ant-hatches + 1
 ]

```

#### Aggiunto: `t-mutation`

```diff
+to t-mutation
+  set speed (random(max-speed-with-mutation) + 1)
+  set metabolism (random(max-metabolism) + 1)
+end
```

## Dinamica del sistema

La dinamica del sistema rimane pressochè invariata rispetto alla precedente versione, seppur rendendo inaccessibili le caratteristiche migliori se non mediante mutazione. La presenza di mutazione, inoltre, evita una stagnazione in una situazione sub-ottimale.
