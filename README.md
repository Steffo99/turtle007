# `2-death-and-rebirth`

Questo progetto estende il progetto [`2-ant-apocalypse`](https://github.com/Steffo99/turtle007/tree/2-ant-apocalypse) permettendo alle formiche di riprodursi nel caso che il cibo accumulato nel nido superi una certa soglia.


## Aggiunte / Modifiche

### Aggiunto: birth
```diff
+ to birth
+   create-ants 1 [set color ant-color
+   set carrying-food 0
+   set hunger 0
+   setxy nest-x nest-y
+     fd nest-size]
+   set food-in-nest food-in-nest - ant-food-cost
+   set born born + 1
+ end
```
Questa funzione permette alle formiche di riprodursi, e crea una nuova formica nel formicaio.

### Modificato: go

```diff
to go
   tick
   ask ants [t-work]
   ask patches [p-evaporate-pheromone]
   diffuse pheromone (diffusion-pct / 100)
   ask patches [p-paint-patch]
   ask ants [t-paint-ant]
   if enable-food-respawn and ticks mod food-ticks = 0[
     p-respawn-food
   ]
+  if enable-birth and (food-in-nest - ant-food-cost) >= food-surplus-threshold[
+    birth
+  ]
end
```
Se il cibo nel nido supera una certa soglia e il modulo è attivo, viene avviata la procedura birth.
## Attivazione / Disattivazione

Le feature di questo branch possono venire abilitate o disabilitate con gli switch `enable-birth`.

## Formiche

Le modifiche in questo ambito sono le seguenti:  
- Ad ogni `tick`, nel caso in cui si superi una certa soglia di cibo che può essere modificata con il controllo `food-surplus-threshold`, il nido userà una certa quantità di cibo (`ant-food-cost`) per creare una nuova formica.
