# `2-evoluzione`

Questo progetto estende il progetto [`2-metabolismo`](https://github.com/Steffo99/turtle007/tree/2-metabolismo). In questa versione vengono aggiunti i parametri riproduttivi e i meccanismi di scelta del partner, che portano ad un’evoluzione del formicaio nel suo complesso.

## Ambiente

### Variabili globali

Sono state aggiunte al modello le seguenti variabili globali:

- `reproduction-hunger`, la quantità di `hunger` al di sopra della quale una formica può tentare di riprodursi;
- `reproduction-cost`, la quantità di `hunger` che sarà sottratta alle formiche dopo essersi riprodotte;
- `partner-radius`, la distanza massima a cui una formica può scegliere il suo partner.

### Comportamento delle formiche

Il comportamento delle formiche è stato cambiato nei seguenti modi:

#### Modificato: `t-die`

```diff
 to t-die
   set ant-deaths ant-deaths + 1
-  set ants-to-respawn ants-to-respawn + 1
   ; Die interrompe la funzione!
   die
 end
```

Dopo che sono morte, le formiche non respawnano più.

#### Modificato: `t-consume-food`

```diff
 to t-consume-food
   set hunger hunger - metabolism
   if hunger <= 0 [
     t-die
   ]
+  if hunger >= reproduction-hunger [
+    t-hatch
+  ]
 end
```

Se le formiche hanno abbastanza cibo per riprodursi, chiameranno la procedura `t-hatch` descritta in seguito.

#### Aggiunto: `t-partners`

```diff
+to-report t-partners
+  report other turtles in-radius partner-radius with [hunger >= reproduction-hunger]
+end
```

Nella scelta dei partner, le formiche considerano solo le altre formiche entro `partner-radius` patch di distanza aventi abbastanza `hunger` per riprodursi.

> Nota: La funzione `in-radius` rallenta significativamente il modello all'aumentare delle formiche presenti dall'interno di esso.
>
> È possibile realizzare una versione più efficiente utilizzando:
> ```
> to-report t-partners
>  report other turtles-here with [hunger >= reproduction-hunger]
> end
> ```
>
> Ciò però sacrifica la possibilità di decidere il raggio a cui le formiche si possono riprodurre, limitandolo al valore "0" (ovvero, la patch stessa in cui si trova attualmente la formica).

#### Aggiunto: `t-hatch`

```diff
+to t-hatch
+  let partners t-partners
+  if any? partners [
+    let partner item 0 sort-on [hunger] partners
+    let parents (turtle-set self partner)
+    ask parents [
+      set hunger hunger - reproduction-cost
+    ]
+    hatch-ants 1 [
+      t-setup-ant
+      t-inherit parents
+    ]
+    set ant-hatches ant-hatches + 1
+  ]
+end
```

Se le formiche trovano almeno un partner con cui riprodursi, scelgono il partner con il valore di `hunger` più alto e creano una nuova formica, che eredita i valori di `speed` e `metabolism` dei genitori con `t-inherit` (descritta sotto).

### Aggiunto: `t-inherit`

```diff
+to t-inherit [parents]
+  let top-speed max [speed] of parents
+  let bottom-speed min [speed] of parents
+  set speed (bottom-speed + random (top-speed - bottom-speed + 1))
+
+  let top-metabolism max [metabolism] of parents
+  let bottom-metabolism min [metabolism] of parents
+  set metabolism (bottom-metabolism + random (top-metabolism - bottom-metabolism + 1))
+end
```

Le nuove formiche nate prendono come `speed` e `metabolism` un valore casuale tra i valori dei rispettivi parametri posseduti dai genitori.

## Feedback del sistema

In aggiunta ai feedback precedenti, in questo progetto abbiamo nuovi feedback:

- <span style="background-color: lightgreen; color: darkgreen;">**Positivo**: Le formiche con più `hunger` (praticamente la funzione *fitness* del modello), hanno più possibilità di riprodursi e passare i loro parametri ai figli.</span>
- <span style="background-color: lightcoral; color: darkred;">**Negativo**: Il `reproduction-cost` fa diminuire l'`hunger` dei genitori, rendendo più probabile la loro morte (e quindi sostituzione).</spaw>

## Dinamica del sistema

Le formiche con i parametri migliori si riprodurranno più spesso, e passeranno i loro parametri ai loro figli.

*Il sistema tende all’ottimo*: dopo un certo numero di ticks (~2100 con la configurazione predefinita), le uniche formiche restanti nel sistema saranno quelle con valori ideali (o prevalenti, in caso di convergenza prematura) per le variabili `speed` e `metabolism`; tutte le altre si saranno **estinte**. Il sistema tende quindi ad una condizione in cui tutte le formiche sono uguali, oppure estinte in caso di convergenza prematura tremendamente sfavorevole (ad esempio, velocità 1 metabolismo 5).

## Branches

E' presente una variazione di questo modello, [`2-Random-Mutation`](https://github.com/Steffo99/turtle007/tree/2-Random-Mutation).
