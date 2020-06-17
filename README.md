# `2-ant-apocalypse`

Questo branch estende il progetto [`2-base`](https://github.com/Steffo99/turtle007/tree/2-base) tenendo traccia del cibo accumulato dalle formiche nel loro formicaio e facendole morire lentamente nel caso che esso finisca.

Inoltre, fa ricomparire il cibo nell'ambiente a intervalli irregolari di tempo.

## Aggiunte / Modifiche

### Aggiunto: `t-set-hunger`

```diff
+to t-set-hunger
+  if random-float 100 < hunger-increase-pct[
+  set hunger hunger + hunger-per-tick
+  ]
+end
```

Questa funzione aumenta la fame della formica casualmente.

### Aggiunto: `t-try-eat-food`

```diff
+to t-try-eat-food
+  if carrying-food = 1[
+    set hunger 0
+    set carrying-food 0
+  ]
+  if t-is-over-nest and food-in-nest > 0[
+    set hunger 0
+    set food-in-nest food-in-nest - 1]
+end
```

Questa funzione permette alla formica di provare a consumare cibo.  
Se si trova sul nido, riduce di 1 la scorta del magazzino, se ne sta trasportando mangia quello.  

### Modificato: `t-work`

```diff
 to t-work
+  ifelse carrying-food = 1 or (hunger >= hunger-threshold and enable-hunger)[
+    t-rotate-nest
+    if carrying-food = 1[
+      t-add-pheromone]
+  ][
+    t-rotate-pheromone
+  ]
   left random random-angle
   right random random-angle
   fd 1
   t-try-pick-up-food
   t-try-drop-food
+  t-set-hunger
+  if hunger >= hunger-threshold and enable-hunger [
+    t-try-eat-food
+    if hunger >= hunger-max [
+      die]
+   ]
 end
```

Se la formica è affamata (e la fame è attiva), la formica si dirige verso il nido per mangiare.

Se la fame supera una certa soglia prova a mangiare il cibo e se non riesce a farlo prima che superi un valore massimo, la formica muore.

### Aggiunto: `p-respawn-food`

```diff
+to p-respawn-food
+  if random-float 100 < food-respawn-pct[
+    setup-food
+  ]
+end
```
Questa funzione permette al cibo di ricomparire con una certa probabilità.

### Modificato: `go`

```diff
 to go
   tick
   ask ants [t-work]
   ask patches [p-evaporate-pheromone]
   diffuse pheromone (diffusion-pct / 100)
   ask patches [p-paint-patch]
   ask ants [t-paint-ant]
+  if enable-food-respawn and ticks mod food-ticks = 0[
+    p-respawn-food
+  ]
 end
```

Il `go` ora rigenererà il cibo.

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
