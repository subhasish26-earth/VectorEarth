// Vercel Serverless Function entrypoint for Express Backend
process.env.VERCEL = process.env.VERCEL || '1';

const app = require('../backend/src/index');

module.exports = (req, res) => {
  // Normalize req.url so Express routes match regardless of how Vercel rewrites it
  if (req.url && !req.url.startsWith('/api')) {
    req.url = '/api' + (req.url.startsWith('/') ? req.url : '/' + req.url);
  }
  return app(req, res);
};
