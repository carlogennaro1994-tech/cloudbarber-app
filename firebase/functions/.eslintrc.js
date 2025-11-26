module.exports = {
  root: true,
  env: {
    es6: true,
    node: true,
  },
  parser: "@typescript-eslint/parser",
  parserOptions: {
    project: ["tsconfig.json", "tsconfig.dev.json"],
    sourceType: "module",
  },
  plugins: ["@typescript-eslint"],
  extends: [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended"
  ],
  rules: {
    // 🔥 DISABILITO REGOLE CHE CAUSANO ERRORI INUTILI 🔥
    "max-len": "off",
    "object-curly-spacing": "off",
    "arrow-parens": "off",
    "@typescript-eslint/no-unused-vars": "off",

    // Non ti rompe mai lo sviluppo
    "@typescript-eslint/no-explicit-any": "off",
  },
};
