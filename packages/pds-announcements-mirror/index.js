import { join } from 'node:path';
import * as fs from 'node:fs/promises'
import express from 'express';

const FETCH_INTERVAL = 60_000;

const cacheFolder = process.env.CACHE_DIR || './';
const base = process.env.PDS_BASE || 'https://at.yugoslavia.best/';
const repo = process.env.ANNOUNCEMENTS_REPO;

const announcementsFile = join(cacheFolder, 'announcements.json');

async function exists(f) {
  try {
    await fs.stat(f);
    return true;
  } catch {
    return false;
  }
}

let announcements = [];

if (await exists(announcementsFile)) {
  const data = await fs.readFile(announcementsFile, 'utf8');
  const json = JSON.parse(data);

  announcements = json;
}

async function fetchAnnouncements(cursor) {
  const args = new URLSearchParams();
  args.append('repo', repo);
  args.append('collection', 'app.bsky.feed.post');
  args.append('limit', '25');
  if (cursor)
    args.append('cursor', cursor);

  const res = await fetch(`${base.replace(/\/$/, '')}/xrpc/com.atproto.repo.listRecords?${args.toString()}`);
  const { records, cursor: newCursor } = await res.json();

  for (const { uri, value } of records) {
    if (!announcements.some(a => a.uri === uri))
      announcements.push({
        uri,
        text: value.text,
        createdAt: value.createdAt,
      });
    else return;
  }

  if (newCursor) {
    await fetchAnnouncements(newCursor);
  }
}

async function cron() {
  console.log('fetching bsky posts');

  await fetchAnnouncements();

  announcements.sort((a, b) => -a.createdAt.localeCompare(b.createdAt));

  await fs.writeFile(announcementsFile, JSON.stringify(announcements));
}

setInterval(cron, FETCH_INTERVAL);

const app = express();

const port = process.env.PORT ? parseInt(process.env.PORT) : 8080;
const hostname = process.env.HOST ?? '0.0.0.0';

app.get('/', (req, res) => {
  res.status(200).send(announcements);
});

app.listen(port, hostname, () => {
  console.log(`listening on ${hostname}:${port}`);
});

cron();
