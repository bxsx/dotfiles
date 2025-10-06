export default {
  defaultBrowser: "com.google.Chrome",
  handlers: [
    {
      match: finicky.matchHostnames(["github.com", "gitlab.com"]),
      browser: "com.google.Chrome"
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
      match: ({ opener }) =>
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
        ].includes(opener.bundleId),
      browser: "com.apple.Safari"
    },
  ],
  rewrite: [
    {
      match: () => true,
      url: ({ url }) => {
        const removeKeysStartingWith = ["utm_", "uta_"];
        const removeKeys = ["fbclid", "gclid"];

        const search = url.search
          .split("&")
          .map((parameter) => parameter.split("="))
          .filter(([key]) => !removeKeysStartingWith.some((startingWith) => key.startsWith(startingWith)))
          .filter(([key]) => !removeKeys.some((removeKey) => key === removeKey));

        return {
          ...url,
          search: search.map((parameter) => parameter.join("=")).join("&"),
        };
      },
    },
  ],
};
