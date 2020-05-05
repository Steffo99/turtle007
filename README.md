# Da insiemi di agenti a sistemi swarm adattativi

_Di [Balugani Lorenzo](https://github.com/LBindustries), [Calzolari Chiara](https://github.com/Cookie-CHR) e [Pigozzi Stefano](https://github.com/Steffo99)_

## Descrizione

Il progetto complessivo consiste in una **serie di realizzazioni di un modello multiagente** e di esperimenti su di esso; ogni nuova versione del modello è più raffinata della precedente. La versione iniziale non è un sistema collettivo; la versione finale realizza un sistema collettivo i cui elementi sono capaci di evolvere e di adattarsi all’ambiente.

## Ambiente

L’ambiente è un [toroide](https://it.wikipedia.org/wiki/Toro_(geometria)) composto da 150x150 patch.

Dopo il `setup` dell'ambiente, questo conterrà 3 gruppi di cibo, un nido e un numero configurabile di formiche.

### Formiche

Dopo il `setup`, nell'ambiente saranno presenti un numero configurabile di formiche, 3 ammassi di cibo e un nido (la posizione di queste entità può essere modificata dall'utente). I colori delle formiche (che trasportano cibo o meno), del cibo e del nido possono essere modificati dall'utente.

Esse (una alla volta, in ordine casuale) effettueranno ad ogni `tick` le seguenti azioni: 

1. Se la formica trasporta del cibo, si orienta verso il nido e rilascia feromoni.
2. Se la formica non trasporta del cibo, si orienta verso una possibile fonte di feromoni. Se il feromone percepito non è nell'intervallo 0.05-2 viene ignorato.
3. La formica si ruota a destra e a sinistra di angolo casuale (il cui massimo può venire scelto dall'utente) e si muove avanti di 1.
4. La formica tenta di prendere del cibo da terra. Se c'è del cibo e non ne sta trasportando altro, lo raccoglie, girandosi poi di 180°.
5. La formica tenta di appoggiare del cibo a terra. Se trasporta del cibo e si trova sopra il nido, lo deposita, girandosi poi di 180°.  

Le patch (una alla volta, in ordine casuale) effetuano ad ogni `tick` le seguenti azioni:

1. Le patch fanno evaporare il ferormone (il quale viene poi diffuso nel go).
2. In base alla configurazione, le patch vengono colorate per mostrare:
    a. Se viene attivato lo switch `show-pheromone`, viene mostrato il feromone.
    b. Se viene attiato lo switch `show-distance`, viene mostrata la distanza della patch dal nido.
    c. Se viene attivato lo switch `show-food`, viene mostrato il cibo.
    d. Se viene attivato lo switch `show-nest`, viene mostrato il nido.


## Dinamica del sistema

Le formiche, ad ogni `tick`, in base a ciò che trasportano, cercano o di prendere del cibo o di portarlo verso il nest. Sulla via di ritorno al nest, le formiche rilasciano feromone, che spinge altre formiche a risalirlo per giungere quindi alla fonte di cibo.
L'ambiente gioca un ruolo importante dal momento che, facendo evaporare i feromoni, elimina vecchi percorsi che portano a fonti di cibo esaurite.

## Feedback del sistema

Nel sistema sono presenti due tipi di feedback:
- <span style="background-color: lightgreen; color: darkgreen;">**Positivo**: Più intensa e recente è la traccia di feromone, più le formiche contribuiranno ad aumentarne l'intensità tornando dalla fonte di cibo.
- <span style="background-color: lightcoral; color: darkred;">**Negativo**: Con l'esaurimento della fonte di cibo, il feromone viene a mancare, cancellando un percorso non più produttivo.

## Esperimenti

TBD

## Branches

Variazioni al modello sono visibili nei branch di questo repository.

In particolare, si evidenziano i branch:

- [`2-poison`](https://github.com/Steffo99/turtle007/tree/2-poison), una versione del modello che include anche una sorgente di veleno.
- [`2-ant-apocalypse`](https://github.com/Steffo99/turtle007/tree/2-ant-apocalypse), una versione del modello che rende necessario alle formiche di nutrirsi, pena la morte.
- [`2-death-and-rebirth`](https://github.com/Steffo99/turtle007/tree/2-death-and-rebirth), una versione del modello che rende necessario alle formiche di nutrirsi, pena la morte, ma che permette loro anche di riprodursi in situazioni di prosperità.
