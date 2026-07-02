#!/usr/bin/env node
// Usage: curl ... | node split_viz.js

let raw = ''
process.stdin.on('data', d => raw += d)
process.stdin.on('end', () => {
  const data = JSON.parse(raw)
  const { level, payouts, avgN, segmentLengths, contributions } = data

  const total      = data.amountCents
  const djPayout   = payouts[payouts.length - 1]
  const artistPool = total - djPayout.amountCents
  const WIDTH    = 20

  const levelNames = { 0: 'L0 Sequential', 1: 'L1 Lightly Layered', 2: 'L2 Heavily Layered', 3: 'L3 Composed' }

  const seg = segmentLengths
  console.log(`\n  ${levelNames[level] || 'Direct'}  |  tip: ${(total/100).toFixed(2)}$  |  N: ${avgN}  |  variance: ${seg?.variance ?? '—'}`)
  console.log(`  VOC ${seg?.VOC ?? '—'}  MEL ${seg?.MEL ?? '—'}  BAS ${seg?.BAS ?? '—'}  DRM ${seg?.DRM ?? '—'}\n`)

  const render = (label, cents) => {
    const filled = Math.round((cents / total) * WIDTH)
    const blocks = '█'.repeat(filled) + '░'.repeat(WIDTH - filled)
    return `  ${label.padEnd(8)} ${(cents/100).toFixed(2)}$  ${blocks}`
  }

  const djFilled     = Math.round((djPayout.amountCents / total) * WIDTH)
  const artistFilled = WIDTH - djFilled
  const bar = '█'.repeat(djFilled) + '░'.repeat(artistFilled)

  const djAmt     = (djPayout.amountCents / 100).toFixed(2)
  const artistAmt = (artistPool / 100).toFixed(2)

  console.log(`  dj ${djAmt}$  ${bar}  artists ${artistAmt}$${contributions.length === 0 ? '  (no artists registered yet)' : ''}`)


  console.log('')
})
