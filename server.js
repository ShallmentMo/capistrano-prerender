const prerender = require('prerender');
const server = prerender({
  chromeFlags: ['--no-sandbox', '--headless', '--disable-gpu', '--remote-debugging-port=9222', '--hide-scrollbars']
});
server.use(require('prerender/lib/plugins/whitelist'))
server.start();
