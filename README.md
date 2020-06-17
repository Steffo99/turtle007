# `1-group-counter`

Questo branch estende il progetto [`1-base`](https://github.com/Steffo99/turtle007/tree/1-base) implementandovi la funzionalità di conteggio automatico magazzini.

## Descrizione

Ad ogni patch che contiene cibo viene assegnato un valore unico, alle patch vuote viene assegnato il valore 0. Quando il cibo viene spostato, cambia il suo id con quello del mucchio di cui fa parte, e ad ogni tick viene contato il numero di valori unici (0 escluso). Questo permette di calcolare il numero di mucchi in tempo reale, con un errore massimo di 1.  

Il comportamento delle termiti rimane immutato.
