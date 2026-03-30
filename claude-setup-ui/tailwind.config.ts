import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          50: "#e6eef5",
          100: "#ccdde8",
          200: "#99bbd1",
          300: "#6699ba",
          400: "#3377a3",
          500: "#002c5f",
          600: "#002353",
          700: "#001a47",
          800: "#00123b",
          900: "#00092f",
        },
        accent: {
          50: "#fffae6",
          100: "#fff5cc",
          200: "#ffeb99",
          300: "#ffe166",
          400: "#ffd733",
          500: "#ffd100",
          600: "#cca700",
          700: "#997d00",
          800: "#665400",
          900: "#332a00",
        },
      },
      boxShadow: {
        'soft': '0 2px 8px rgba(0, 0, 0, 0.08)',
        'soft-lg': '0 4px 16px rgba(0, 0, 0, 0.12)',
      },
    },
  },
  plugins: [],
};

export default config;
