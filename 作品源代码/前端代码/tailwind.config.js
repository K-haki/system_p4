/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      fontFamily: {
        major: 'Major Mono Display'
      },
      animation: {
        'spin-6': 'spin 6s linear infinite',
        'spin-9': 'spin 9s linear infinite',
      },
      colors: {
        // 'primary': 'rgb(92, 251, 230)',
        'primary': 'rgb(133,199,236)',
        // "secondary": "rgb(246, 163, 254)",
        "secondary": "rgb(11,79,118)",
        'active': 'white',
        'bottom':'rgb(5,26,66)'
      }
    },
  },
  plugins: [],
}