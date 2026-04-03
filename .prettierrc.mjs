// see https://github.com/withastro/prettier-plugin-astro/blob/1150195386a80221882d603dffa94990709395fb/README.md

/** @type {import("prettier").Config} */
export default {
  plugins: ["prettier-plugin-astro"],
  overrides: [
    {
      files: "*.astro",
      options: {
        parser: "astro",
      },
    },
  ],
};
