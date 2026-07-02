// Quick Ollama connectivity test
// run: node test-ollama.js
const http = require('http');

// 1. List available models
const listReq = http.request({
  hostname: 'localhost', port: 11434, path: '/api/tags', method: 'GET'
}, res => {
  let d = '';
  res.on('data', c => d += c);
  res.on('end', () => {
    try {
      const json = JSON.parse(d);
      const models = (json.models || []).map(m => m.name);
      console.log('✓ Ollama is running');
      console.log('  models:', models.length ? models.join(', ') : '(none)');

      if (!models.length) {
        console.log('\n✗ No models installed. Run: ollama pull llama3');
        return;
      }

      const model = models[0];
      console.log(`\nTesting chat with: ${model}`);

      // 2. Send a test message
      const body = JSON.stringify({
        model,
        messages: [{ role: 'user', content: 'say hello in one sentence' }],
        stream: false,
      });

      const chatReq = http.request({
        hostname: 'localhost', port: 11434, path: '/api/chat', method: 'POST',
        headers: { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(body) },
      }, res => {
        let d = '';
        res.on('data', c => d += c);
        res.on('end', () => {
          try {
            const json = JSON.parse(d);
            const reply = json.message && json.message.content;
            if (reply) {
              console.log('✓ Response:', reply.trim());
              console.log(`\n→ In sdj-tui.js, set CONFIG.ollama_model to: '${model}'`);
            } else {
              console.log('✗ No content in response:', d.slice(0, 200));
            }
          } catch (e) {
            console.log('✗ Parse error:', e.message, '| raw:', d.slice(0, 200));
          }
        });
      });
      chatReq.on('error', e => console.log('✗ Chat request failed:', e.message));
      chatReq.write(body);
      chatReq.end();

    } catch (e) {
      console.log('✗ Parse error:', e.message);
    }
  });
});
listReq.on('error', e => console.log('✗ Ollama unreachable:', e.message, '\n  → Is Ollama running? Try: ollama serve'));
listReq.end();
