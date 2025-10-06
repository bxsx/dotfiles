const browsers = {
  prv: {
    name: "com.apple.Safari",
    appType: "bundleId",
    openInBackground: false
  },
  ext: {
    name: "com.google.Chrome",
    appType: "bundleId",
    openInBackground: false
  },
};

export default {
  options: {
    keepRunning: false,
    hideIcon: true,
    logRequests: false
  },
  defaultBrowser: browsers.ext,
  handlers: [
    {
      match: finicky.matchHostnames(["github.com", "gitlab.com"]),
      browser: browsers.ext
    },
    {
      match: finicky.matchHostnames("open.spotify.com"),
      browser: "com.spotify.client"
    },
    {
      match: "https://*.slack.com/*",
      browser: "com.tinyspeck.slackmacgap"
    },
    {
      match: "https://*.zoom.us/j/*",
      browser: "us.zoom.xos"
    },
    {
      match: "https://linear.app/*",
      browser: "com.linear"
    },
    {
      match: (_url, { opener }) =>
        [
          "com.apple.AppStore",
          "com.apple.iCal",
          "com.apple.Notes",
          "com.apple.reminders",
          "com.apple.stocks",
          "com.culturedcode.ThingsMac",
          "com.ideasoncanvas.mindnode",
          "com.readdle.smartemail-Mac",
          "com.sindresorhus.Caprine",
          "com.spotify.client",
          "net.whatsapp.WhatsApp",
          "org.whispersystems.signal-desktop",
          "ru.keepcoder.Telegram",
        ].includes(opener?.bundleId ?? ""),
      browser: browsers.prv
    },
  ],
  rewrite: [
    {
      match: () => true,
      url: (url) => {
        const removeKeysStartingWith = ["utm_", "uta_"];
        const removeKeys = ["fbclid", "gclid"];

        for (const key of [...url.searchParams.keys()]) {
          if (
            removeKeysStartingWith.some((prefix) => key.startsWith(prefix))
            || removeKeys.includes(key)
          ) {
            url.searchParams.delete(key);
          }
        }

        return url.href;
      }
    },
  ],
};
