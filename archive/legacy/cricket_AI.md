{\rtf1\ansi\ansicpg1252\cocoartf2870
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 # Cricket AI\
\
---\
\
## Overview\
\
Cricket is the AI interface layer of EBYS.\
\
It is powered by a local LLM running through Ollama and acts as the conversational bridge between users and the EBYS system.\
\
Users interact with Cricket using natural language.\
\
---\
\
## Architecture\
\
Cricket is not a standalone model.\
\
It is a runtime interface over:\
\
- Ollama local model server\
- EBYS system state (filesystem + pipeline metadata)\
- radio status + processing logs\
\
---\
\
## Input / Output Model\
\
### Input\
Users speak in natural language:\
\
- "upload this track"\
- "what is playing on the radio?"\
- "explain EBYS"\
- "how are stems processed?"\
\
### Output\
Cricket responds using:\
- system-aware explanations\
- pipeline status summaries\
- contextual guidance\
- optional technical detail when relevant\
\
---\
\
## Role in EBYS\
\
Cricket is:\
\
- a conversational interface\
- a system explainer\
- a user onboarding layer\
- a bridge between terminal system logic and human language\
\
Cricket is NOT:\
\
- a music generation engine\
- a decision-maker for the radio\
- part of the audio pipeline\
\
---\
\
## Technical Stack\
\
- Ollama (local LLM runtime)\
- Model choice configurable (e.g. Llama, Mistral, etc.)\
- Python bridge layer to EBYS system state\
\
---\
\
## System Access\
\
Cricket has read access to:\
\
- pipeline status (watcher state)\
- file system structure\
- processing logs\
- radio generation state\
- metadata of tracks/stems/splices\
\
Cricket does NOT directly modify audio processing unless explicitly integrated with a controlled command layer.\
\
---\
\
## Interaction Design\
\
Cricket is embedded in the terminal-style web UI.\
\
Example:\
\
> user: "what is happening with my upload?"\
\
> cricket: "Track detected. Converting MP4 \uc0\u8594  WAV. Demucs separation in progress..."\
\
---\
\
## Design Principle\
\
Cricket translates:\
\
SYSTEM STATE \uc0\u8594  HUMAN LANGUAGE\
\
and\
\
HUMAN LANGUAGE \uc0\u8594  SYSTEM QUERIES\
\
via Ollama.\
\
---\
\
## Key Constraint\
\
Cricket is an interface layer, not a control layer.\
\
All deterministic audio processing remains in the EBYS pipeline.}