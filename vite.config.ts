import { defineConfig } from 'vite'
import { svelte } from '@sveltejs/vite-plugin-svelte'

// https://vite.dev/config/
export default defineConfig({
  plugins: [svelte()],
  publicDir: 'public',
  resolve: {
    alias: {
      '$lib': '/src',
      '$components': '/src/components',
      '$stores': '/src/stores',
      '$types': '/src/types',
      '$utils': '/src/utils'
    }
  },
  build: {
    outDir: 'dist',
    assetsDir: 'assets',
    sourcemap: false,
    minify: 'esbuild'
  }
})
