# Système EBYS

Instrument de DJ génératif, radio web et protocole de pourboire — montréal

---

## Vue d'ensemble

EBYS est un instrument de DJ basé sur l'intelligence artificielle. Il découpe des pistes musicales en tranches spectrales et les réassemble en temps réel, créant des mélanges qui maintiennent une continuité sonore à travers les coupures tout en permettant au DJ de piloter l'énergie et la direction.

L'instrument tourne localement sur un ordinateur portable. La radio web diffuse les performances en direct. Le protocole de pourboire permet aux auditeurs de rémunérer les DJs et les artistes en quelques secondes, sans application, sans compte.

---

## Radio web

La radio diffuse en continu les performances EBYS — live ou archivées. La page montre ce qui joue : la piste, l'artiste, le niveau de transformation. Le bouton de pourboire est toujours visible.

Les auditeurs écoutent sans compte. Le pourboire passe par Stripe (carte, Apple Pay) — 30 secondes, terminé.

---

## Le déclencheur de température

L'entropie du moteur EBYS varie avec la température extérieure :

```
entropy = clamp(0.5 + (δT / 5.0), 0.0, 1.0)
```

`δT` = température d'aujourd'hui − moyenne historique (même date calendaire, fenêtre de 10 ans)

- **Température normale** → entropy ~0.5 → mixage équilibré, continuité spectrale prioritaire
- **Température élevée** (ex. +5°C au-dessus de la moyenne) → entropy ~1.0 → mode expérimental maximum, transitions surprenantes
- **Température fraîche** (ex. −5°C en dessous) → entropy ~0.0 → mode conservateur, séquencement serré

L'indicateur climatique est affiché en direct sur la page radio. L'auditeur voit l'écart de température et comprend pourquoi la musique sonne comme ça ce soir.

---

## Calendrier d'événements

La page radio affiche un calendrier d'événements à venir : performances live, sessions de bake, showcases d'artistes. Les DJs soumettent leurs dates via leur profil. Les événements sont visibles par tous les auditeurs sans compte.

---

## Console de mixage (visualisation)

La page radio inclut une visualisation en direct du deck EBYS : les quatre tiges (voix, mélodie, basse, batterie), les niveaux de transformation par tige, les VU-mètres, l'indicateur de momentum.

Ce n'est pas juste une visualisation — c'est la fenêtre sur le processus de curation. L'auditeur voit les choix que le moteur fait en temps réel.

---

## Araignée (spider)

Le personnage central de la marque EBYS est une araignée — l'EatBugsYouSpider. Elle apparaît sur la page radio, dans la visualisation du deck, dans les visuels de marque.

L'araignée n'est pas expliquée. Elle est là. Elle mange des bugs. Elle mange votre musique. Elle vous regarde.

---

## Infrastructure technique

| Composant | Technologie |
|-----------|-------------|
| Analyse audio | Python, HTDemucs, madmom, Essentia, FluCoMa |
| Moteur de lecture | Max/MSP, karma~, fluid.bufstretch~ |
| Interface de contrôle | Node.js TUI (cricket-voice.js / sdj-tui.js) |
| Backend API | Node.js, Express, Railway |
| Base de données | SQLite (ebys.db) |
| Paiements | Stripe, Stripe Connect |
| Streaming | Icecast, Liquidsoap, BlackHole (macOS) |
| Index de similarité | FAISS |
