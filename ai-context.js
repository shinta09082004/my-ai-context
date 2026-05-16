#!/usr/bin/env node
const fs = require('fs');
const path = require('path');

const projectName = process.argv[2];
if (!projectName) {
  console.error('Usage: node ai-context.js <ProjectName>');
  process.exit(1);
}

const BASE = '/workspaces/my-ai-context';
const globalDir = path.join(BASE, '00_Global');
const projectDir = path.join(BASE, 'Projects', projectName);

function readDir(dir, label) {
  if (!fs.existsSync(dir)) {
    console.error(`Directory not found: ${dir}`);
    process.exit(1);
  }
  const files = fs.readdirSync(dir).filter(f => f.endsWith('.md')).sort();
  const sections = files.map(file => {
    const content = fs.readFileSync(path.join(dir, file), 'utf8');
    return `--- [${label}/${file}] ---\n${content}`;
  });
  return sections.join('\n\n');
}

const globalContent = readDir(globalDir, '00_Global');
const projectContent = readDir(projectDir, `Projects/${projectName}`);

console.log(`=== GLOBAL CONTEXT ===\n\n${globalContent}\n\n=== PROJECT CONTEXT: ${projectName} ===\n\n${projectContent}`);
