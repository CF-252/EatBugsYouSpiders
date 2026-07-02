// cricket-voice.js — personality training session
// run:  node cricket-voice.js
//
// Talk freely. Everything you type is saved.
// :bake          — distill your writing style into voice.md
// :bakefranglais — bake Q&A examples into the Modelfile, then re-run: ollama create franglais -f Modelfile
// :rule "..."    — add an explicit behavioral rule to rules.md
// :rules         — show current rules
// :clear         — wipe samples
// :show          — print samples
// :quit          — exit

const readline = require('readline');
const http     = require('http');
const fs       = require('fs');
const path     = require('path');

const OLLAMA_HOST  = 'localhost';
const OLLAMA_PORT  = 11434;
const MODEL        = 'llama3.1:latest';

const SAMPLES_FILE = path.join(__dirname, 'voice_samples.md');
const VOICE_FILE   = path.join(__dirname, 'voice.md');
const RULES_FILE   = path.join(__dirname, 'rules.md');

// Load existing samples
let userMessages = [];
if (fs.existsSync(SAMPLES_FILE)) {
  const raw = fs.readFileSync(SAMPLES_FILE, 'utf8');
  userMessages = raw.split('\n')
    .filter(l => l.startsWith('> '))
    .map(l => l.slice(2).trim());
  console.log(`\x1b[90m(${userMessages.length} previous messages loaded)\x1b[0m`);
}

const SYSTEM = `You are Cricket, the AI interface for EBYS — a generative audio collage engine.
You are in a voice training session. The person is talking so you can learn how they speak.
Respond naturally and briefly. Ask follow-up questions when curious. Keep it short.`;

const history = [{ role: 'system', content: SYSTEM }];

const rl = readline.createInterface({ input: process.stdin, output: process.stdout });

console.log('\x1b[36mcricket-voice\x1b[0m');
console.log('\x1b[90m:bake          — distill your voice into voice.md');
console.log(':rule "..."    — add a behavioral rule (e.g. :rule "say CHIRP when someone enters")');
console.log(':rules         — show current rules');
console.log(':clear         — wipe samples');
console.log(':show          — print samples');
console.log(':quit          — exit\x1b[0m\n');

function ask() {
  rl.question('\x1b[35m> \x1b[0m', text => {
    const trimmed = text.trim();
    if (!trimmed) { ask(); return; }

    if (trimmed === ':quit') { process.exit(0); }

    if (trimmed === ':clear') {
      userMessages = [];
      if (fs.existsSync(SAMPLES_FILE)) fs.unlinkSync(SAMPLES_FILE);
      console.log('\x1b[90msamples cleared.\x1b[0m\n');
      ask(); return;
    }

    if (trimmed === ':show') {
      if (!userMessages.length) { console.log('\x1b[90m(no samples)\x1b[0m\n'); }
      else userMessages.forEach(m => console.log('\x1b[90m  ' + m + '\x1b[0m'));
      console.log('');
      ask(); return;
    }

    if (trimmed === ':rules') {
      if (fs.existsSync(RULES_FILE)) {
        console.log('\x1b[90m--- rules.md ---');
        console.log(fs.readFileSync(RULES_FILE, 'utf8').trim());
        console.log('---\x1b[0m\n');
      } else {
        console.log('\x1b[90m(no rules yet)\x1b[0m\n');
      }
      ask(); return;
    }

    if (trimmed.startsWith(':rule ')) {
      const rule = trimmed.slice(6).replace(/^["']|["']$/g, '').trim();
      if (!rule) { ask(); return; }
      fs.appendFileSync(RULES_FILE, '- ' + rule + '\n');
      console.log('\x1b[90mrule saved: ' + rule + '\x1b[0m\n');
      ask(); return;
    }

    if (trimmed === ':bake') {
      bake(); return;
    }

    if (trimmed === ':bakefranglais') {
      bakeFranglais(); return;
    }

    // Save and send
    userMessages.push(trimmed);
    fs.appendFileSync(SAMPLES_FILE, `> ${trimmed}\n`);
    history.push({ role: 'user', content: trimmed });
    process.stdout.write('\x1b[36mcricket: \x1b[0m');

    chat(history, reply => {
      history.push({ role: 'assistant', content: reply });
      console.log(reply.trim() + '\n');
      ask();
    });
  });
}

function chat(messages, callback) {
  const body = JSON.stringify({ model: MODEL, messages, stream: false });
  const req = http.request({
    hostname: OLLAMA_HOST, port: OLLAMA_PORT,
    path: '/api/chat', method: 'POST',
    headers: { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(body) },
  }, res => {
    let d = '';
    res.on('data', c => d += c);
    res.on('end', () => {
      try {
        const json = JSON.parse(d);
        callback(json.message?.content || '(no response)');
      } catch (e) { callback('(parse error)'); }
    });
  });
  req.on('error', () => callback('(ollama unreachable)'));
  req.write(body); req.end();
}

function bake() {
  if (userMessages.length < 5) {
    console.log('\x1b[90mNeed at least 5 messages. Keep talking.\x1b[0m\n');
    ask(); return;
  }

  console.log('\x1b[90mbaking voice.md...\x1b[0m');

  // Only use the actual words — strict extraction
  const samples = userMessages.map(m => `"${m}"`).join('\n');

  const bakePrompt = `Read these messages written by one person. Extract ONLY what is directly observable in the text itself.

MESSAGES:
${samples}

Write 4–6 sentences describing how this person writes. Be specific and literal — pull actual patterns from the text. Do not invent traits. Do not generalize beyond what's visible.

Focus on:
- Sentence length and rhythm (short bursts? long explanations?)
- Formality level (casual? technical? mixed?)
- Punctuation habits (ellipsis? caps? no punctuation?)
- How they give instructions or corrections
- Specific words or phrases they actually used

Format: plain instructions for another AI, starting each sentence with "This person..." or "They..."
Output ONLY the note. Nothing else.`;

  chat(
    [
      { role: 'system', content: 'Extract only what is literally in the text. Do not invent. Output only the personality note.' },
      { role: 'user',   content: bakePrompt },
    ],
    note => {
      const trimmed = note.trim();
      fs.writeFileSync(VOICE_FILE, trimmed + '\n');
      console.log('\n\x1b[36m--- voice.md ---\x1b[0m');
      console.log(trimmed);
      console.log('\x1b[36m----------------\x1b[0m');
      console.log('\x1b[90mSaved. Restart the TUI to apply.\x1b[0m\n');
      rl.close();
      process.exit(0);
    }
  );
}

function bakeFranglais() {
  if (userMessages.length < 5) {
    console.log('\x1b[90mNeed at least 5 messages. Keep talking.\x1b[0m\n');
    ask(); return;
  }

  console.log('\x1b[90mbaking franglais examples into Modelfile...\x1b[0m');

  const samples = userMessages.map(m => `"${m}"`).join('\n');

  const bakePrompt = `Here are messages written by a québécois person talking about music and a generative audio system called EBYS:

${samples}

Generate 8 realistic Q&A conversation examples in franglais — québécois French grammar mixed with English technical words. Base the questions on what this person actually talks about. The answers should sound like a knowledgeable DJ assistant who speaks the same way.

Rules for the answers:
- French grammar and sentence structure
- English words for: track, stem, load, split, buffer, loop, slice, beat, mix, sample, file, output, start, stop, reset, pitch, filter, gain, fade, clip, waveform, onset, descriptor, layer, channel, plugin
- Short answers, casual tone
- Never "mon ami" or formal French

Format each example EXACTLY like this:
User: [question]
Cricket: [answer]

Output ONLY the 8 examples, nothing else.`;

  chat(
    [
      { role: 'system', content: 'You generate franglais conversation examples. Output only what is asked, in the exact format specified.' },
      { role: 'user',   content: bakePrompt },
    ],
    examples => {
      const trimmed = examples.trim();
      const modelfilePath = path.join(__dirname, '..', 'Modelfile');
      let modelfile = '';
      try {
        modelfile = fs.readFileSync(modelfilePath, 'utf8');
      } catch (e) {
        console.log('\x1b[31mModelfile not found at ' + modelfilePath + '\x1b[0m\n');
        ask(); return;
      }

      // Replace or append examples section
      const marker = '# === BAKED EXAMPLES ===';
      const newSection = `\n${marker}\nSYSTEM """\n${trimmed}\n"""`;
      if (modelfile.includes(marker)) {
        modelfile = modelfile.replace(new RegExp(marker + '[\\s\\S]*'), newSection.trim());
      } else {
        modelfile = modelfile.trimEnd() + '\n' + newSection;
      }
      fs.writeFileSync(modelfilePath, modelfile);

      console.log('\n\x1b[36m--- baked examples ---\x1b[0m');
      console.log(trimmed);
      console.log('\x1b[36m----------------------\x1b[0m');
      console.log('\x1b[90mSaved to Modelfile. Now run:\x1b[0m');
      console.log('\x1b[33mollama create franglais -f ' + path.join(__dirname, 'Modelfile') + '\x1b[0m\n');
      rl.close();
      process.exit(0);
    }
  );
}

ask();
