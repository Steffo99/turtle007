# `2-evoluzione`

Questo progetto estende il progetto [`2-metabolismo`](https://github.com/Steffo99/turtle007/tree/2-metabolismo). In questa versione vengono aggiunti i parametri riproduttivi e i meccanismi di scelta del partner, che portano ad un’evoluzione del formicaio nel suo complesso.

## Ambiente

### Variabili globali

Sono state aggiunte al modello le seguenti variabili globali:
- `sgl_scorta`, che rappresenta la quantità di risorse al di sopra della quale una formica può tentare la riproduzione;
- `prezzo`: funzione della variabile turtles-own `scorta`, rappresenta il costo in risorse della riproduzione. Solitamente è settata a `1/10*scorta`.

### Variabili delle formiche

Le formiche hanno le stesse variabili turtles-own dei precedenti modelli. In particolare, per questo progetto ci saranno utili:

- `angolo_virata`;
- `velocità`;
- `metabolismo`.

###Comportamento delle formiche

al modello sono state aggiunte queste nuove funzionalità:

- `cerca-partner`: se la `scorta` di una formica eccede `sgl_scorta` e essa sta trasportando del cibo con sé (quindi `ant color = ant-carrying-color`), essa può cercare un partner per la riproduzione. Per fare ciò, individua tutte le formiche nei dintorni, in un range di TODO caselle, le ordina in base alla loro `scorta` e, se la formica con `scorta` maggiore ha un numero di risorse maggiore di `sgl_scorta`, sceglierà quella come partner.

```TODO: funzione apposita```

- `crea_figlio`: viene creata una nuova formica. Creare un figlio è un processo dispendioso, la `scorta` dei genitori viene infatti diminuita in funzione della variabile `prezzo`. Ciascuna delle variabili turtles-own della nuova formica (ossia `velocità`, `metabolismo` e `angolo_virata`) assumerà il valore della corrispondente variabile di uno dei due genitori, scelto a caso.

```TODO: funzione apposita```

## Feedback del sistema

In aggiunta ai feedback precedenti, in questo progetto abbiamo nuovi feedback:

- <span style="background-color: lightgreen; color: darkgreen;">**Positivo**: Le formiche con più scorta, e quindi con una *fitness* più alta, hanno più possibilità di riprodursi e passare i loro parametri ai figli, che quindi, probabilmente, avranno fitness alta a loro volta e si riprodurranno spesso.</span>
- <span style="background-color: lightcoral; color: darkred;">**Negativo**: Il costo della riproduzione fa diminuire la `scorta` dei genitori, evitando che essi si riproducano a dismisura (TODO: questo è il feddback giusto?).</span>

## Dinamica del sistema

Le formiche con i parametri migliori avranno più possibilità di riprodursi, e passare suddetti parametri ai figli.
*Il sistema tende all’ottimo*: dopo un certo periodo di tempo, la maggior parte delle formiche presenti nell’ambiente avrà le variabili ideali per il suddetto.

## Osservazioni

TODO