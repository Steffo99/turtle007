# `1-group-counter`

Questo branch estende il progetto [`1-base`](https://github.com/Steffo99/turtle007/tree/1-base) implementandovi la funzionalità di conteggio automatico magazzini.

## Descrizione

Ad ogni patch che contiene cibo viene assegnato un valore unico, alle patch vuote viene assegnato il valore -1. Quando il cibo viene spostato, cambia il suo id con quello del mucchio di cui fa parte, e ad ogni tick viene contato il numero di valori unici (0 escluso). Questo permette di calcolare il numero di mucchi in tempo reale, con un errore massimo di 1.  

Il comportamento delle termiti rimane immutato.

## Aggiunte / Modifiche

### Aggiunto: variabili globali e delle patch
```diff
+ globals [step carry groups]
+ patches-own [id]
```
### Modificato: setup
```diff
 to setup
   clear-all
   crt n_termiti
   ask turtles [set color white]
   ask turtles [setxy random-xcor random-ycor]
   ask turtles [set size 5]
   ask turtles [set shape "bug"]
   ask patches[
     if random-float 100 < densita_cibo[
       set pcolor yellow
     ]
   ]
+  let counter 0
+  ask patches with [pcolor = yellow] [set id counter
+    set counter counter + 1
+  ;set plabel id
+  ]
   set carry 0
   reset-ticks
 end
```
Aggiunge ad ogni patch un identificativo univoco.
### Aggiunto: locate-group
```diff
+ to locate-group
+   ask patches with [pcolor = yellow]
+   [let tmp max-one-of neighbors [id]
+     set id [id] of tmp
+   ;set plabel id
+   ]
+   let _unique remove-duplicates [id] of patches
+   set groups length _unique
+   ask patches with [pcolor = black and id != -1] [set id -1]
+ end
```
Questa funzione permette di aggiornare gli id delle patch.

### Modificato: go
```diff
 to go ;; questa è una procedura turtle
+  ifelse step < max_step or max_step = 0 [
+    ask turtles [cerca-cibo]
+    locate-group
+    ;plotxy step groups
+    set step step + 1
+    tick
+  ]
+  [ user-message (word "La simulazione ha raggiunto i " max_step " passi.")]
 end
```
Il go strutturato in questo modo permette di gestire il numero massimo di passi per la simulazione e richiama locate-groups ad ogni tick.
