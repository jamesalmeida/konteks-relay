#!/usr/bin/env node
// SEO Audit — lightweight Node.js script (no deps)
// Usage: node audit.mjs <URL>

import https from "https";
import http from "http";
import { URL } from "url";

const url = process.argv[2];
if (!url) { console.error("Usage: node audit.mjs <URL>"); process.exit(1); }

function fetch(u) {
  return new Promise((resolve, reject) => {
    const mod = u.startsWith("https") ? https : http;
    const req = mod.get(u, { headers: { "User-Agent": "Mozilla/5.0 SEOAudit/1.0" }, timeout: 15000 }, (res) => {
      if ([301, 302, 303, 307, 308].includes(res.statusCode) && res.headers.location) {
        return resolve(fetch(new URL(res.headers.location, u).href));
      }
      let body = "";
      res.on("data", (c) => body += c);
      res.on("end", () => resolve({ status: res.statusCode, headers: res.headers, body }));
    });
    req.on("error", reject);
    req.on("timeout", () => { req.destroy(); reject(new Error("timeout")); });
  });
}

function extract(html, regex, group = 1) {
  const m = html.match(regex);
  return m ? m[group] : null;
}

function extractAll(html, regex) {
  const results = [];
  let m;
  const re = new RegExp(regex.source, regex.flags.includes("g") ? regex.flags : regex.flags + "g");
  while ((m = re.exec(html)) !== null) results.push(m);
  return results;
}

function grade(score) {
  if (score >= 90) return "A";
  if (score >= 80) return "B";
  if (score >= 70) return "C";
  if (score >= 50) return "D";
  return "F";
}

async function audit() {
  const start = Date.now();
  let res;
  try { res = await fetch(url); } catch (e) { console.error(`Failed to fetch: ${e.message}`); process.exit(1); }

  const html = res.body;
  const elapsed = Date.now() - start;
  const sizeKB = Math.round(Buffer.byteLength(html) / 1024);
  const report = { url, fetchTimeMs: elapsed, sizeKB, categories: {} };

  // META
  const title = extract(html, /<title[^>]*>([^<]+)<\/title>/i);
  const desc = extract(html, /<meta[^>]*name=["']description["'][^>]*content=["']([^"']+)["']/i)
    || extract(html, /<meta[^>]*content=["']([^"']+)["'][^>]*name=["']description["']/i);
  const ogImage = extract(html, /<meta[^>]*property=["']og:image["'][^>]*content=["']([^"']+)["']/i);
  const canonical = extract(html, /<link[^>]*rel=["']canonical["'][^>]*href=["']([^"']+)["']/i);
  const viewport = extract(html, /<meta[^>]*name=["']viewport["'][^>]*content=["']([^"']+)["']/i);
  const robots = extract(html, /<meta[^>]*name=["']robots["'][^>]*content=["']([^"']+)["']/i);

  let metaScore = 0;
  const metaIssues = [];
  if (title) { metaScore += 20; if (title.length > 60) metaIssues.push(`Title too long (${title.length} chars, aim for ≤60)`); }
  else metaIssues.push("❌ Missing <title> tag");
  if (desc) { metaScore += 20; if (desc.length > 160) metaIssues.push(`Description too long (${desc.length} chars, aim for ≤160)`); if (desc.length < 50) metaIssues.push(`Description too short (${desc.length} chars, aim for 50-160)`); }
  else metaIssues.push("❌ Missing meta description");
  if (ogImage) metaScore += 20; else metaIssues.push("⚠️ Missing og:image (no preview when shared on social)");
  if (canonical) metaScore += 20; else metaIssues.push("⚠️ Missing canonical URL");
  if (viewport) metaScore += 20; else metaIssues.push("❌ Missing viewport meta (not mobile-friendly)");

  report.categories.meta = { score: metaScore, grade: grade(metaScore), title: title?.slice(0, 80), description: desc?.slice(0, 180), issues: metaIssues };

  // HEADINGS
  const h1s = extractAll(html, /<h1[^>]*>([\s\S]*?)<\/h1>/gi);
  const h2s = extractAll(html, /<h2[^>]*>/gi);
  const h3s = extractAll(html, /<h3[^>]*>/gi);
  let headingScore = 0;
  const headingIssues = [];
  if (h1s.length === 1) headingScore += 50;
  else if (h1s.length === 0) headingIssues.push("❌ No H1 tag found");
  else headingIssues.push(`⚠️ Multiple H1 tags (${h1s.length}) — should have exactly 1`);
  if (h2s.length > 0) headingScore += 30; else headingIssues.push("⚠️ No H2 tags — add subheadings for structure");
  if (h1s.length <= 1 && h2s.length > 0) headingScore += 20;

  report.categories.headings = { score: headingScore, grade: grade(headingScore), h1Count: h1s.length, h2Count: h2s.length, h3Count: h3s.length, issues: headingIssues };

  // IMAGES
  const imgs = extractAll(html, /<img[^>]*>/gi);
  const imgsWithAlt = imgs.filter(m => /alt=["'][^"']+["']/i.test(m[0]));
  const imgScore = imgs.length === 0 ? 100 : Math.round((imgsWithAlt.length / imgs.length) * 100);
  const imgIssues = [];
  if (imgs.length > 0 && imgsWithAlt.length < imgs.length) imgIssues.push(`${imgs.length - imgsWithAlt.length} of ${imgs.length} images missing alt text`);

  report.categories.images = { score: imgScore, grade: grade(imgScore), total: imgs.length, withAlt: imgsWithAlt.length, issues: imgIssues };

  // PERFORMANCE
  let perfScore = 100;
  const perfIssues = [];
  if (sizeKB > 500) { perfScore -= 30; perfIssues.push(`Page size ${sizeKB}KB — aim for <500KB`); }
  else if (sizeKB > 200) { perfScore -= 10; perfIssues.push(`Page size ${sizeKB}KB — decent but could be leaner`); }
  if (elapsed > 3000) { perfScore -= 30; perfIssues.push(`Slow response (${elapsed}ms) — aim for <2s`); }
  else if (elapsed > 1500) { perfScore -= 10; perfIssues.push(`Response time ${elapsed}ms — acceptable but could improve`); }
  const inlineStyles = extractAll(html, /style=["'][^"']{100,}["']/gi);
  if (inlineStyles.length > 5) { perfScore -= 10; perfIssues.push(`${inlineStyles.length} large inline styles — consider external CSS`); }

  report.categories.performance = { score: Math.max(0, perfScore), grade: grade(Math.max(0, perfScore)), sizeKB, fetchTimeMs: elapsed, issues: perfIssues };

  // SECURITY
  const isHttps = url.startsWith("https");
  let secScore = isHttps ? 70 : 0;
  const secIssues = [];
  if (!isHttps) secIssues.push("❌ Not using HTTPS!");
  if (res.headers["strict-transport-security"]) secScore += 15; else secIssues.push("⚠️ Missing HSTS header");
  if (res.headers["x-content-type-options"]) secScore += 15; else secIssues.push("⚠️ Missing X-Content-Type-Options header");

  report.categories.security = { score: secScore, grade: grade(secScore), https: isHttps, issues: secIssues };

  // ACCESSIBILITY
  const lang = extract(html, /<html[^>]*lang=["']([^"']+)["']/i);
  let a11yScore = 0;
  const a11yIssues = [];
  if (lang) a11yScore += 30; else a11yIssues.push("❌ Missing lang attribute on <html>");
  if (viewport) a11yScore += 20;
  const ariaCount = extractAll(html, /aria-/gi).length;
  if (ariaCount > 3) a11yScore += 25; else if (ariaCount > 0) a11yScore += 10; else a11yIssues.push("⚠️ No ARIA attributes found");
  const skipLink = /skip.{0,5}(nav|content|main)/i.test(html);
  if (skipLink) a11yScore += 25; else a11yIssues.push("⚠️ No skip navigation link");

  report.categories.accessibility = { score: Math.min(100, a11yScore), grade: grade(Math.min(100, a11yScore)), lang, ariaCount, issues: a11yIssues };

  // OVERALL
  const cats = Object.values(report.categories);
  const overall = Math.round(cats.reduce((s, c) => s + c.score, 0) / cats.length);
  report.overall = { score: overall, grade: grade(overall) };

  // Print report
  console.log(JSON.stringify(report, null, 2));
}

audit().catch(e => { console.error(e.message); process.exit(1); });
