export default {
  defaultBrowser: "Browserosaurus",
  handlers: [
    {
      match: finicky.matchHostnames("open.spotify.com"),
      browser: "Spotify",
    },
    {
      match: "https://*.slack.com/*",
      browser: "Slack",
    },
    {
      match: "https://*.zoom.us/j/*",
      browser: "us.zoom.xos"
    },
    {
      match: "https://linear.app/*",
      browser: "Linear",
    },
  ]
};
