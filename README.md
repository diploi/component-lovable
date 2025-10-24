<img alt="icon" src=".diploi/icon.svg" width="32">

# Lovable Component for Diploi

[![launch with diploi badge](https://diploi.com/launch.svg)](https://diploi.com)
[![component on diploi badge](https://diploi.com/component.svg)](https://diploi.com)
[![latest tag badge](https://badgen.net/github/tag/diploi/component-lovable)](https://diploi.com)

## Operation

### Development

Will run `npm install` when component is first initialized, and `npm run dev` when deployment is started.

### Production

Will build a production ready image. Image runs `npm install` & `npm run build` in a GitHub action when being created, and `npm run build` again when being run. The second `npm run build` ensures that ENV values are applied correctly from the running deployment.
The created `/dist` folder will be served as a static site with [serve](https://github.com/vercel/serve).

## Links

- [React documentation](https://react.dev/)
- [Vite documentation](https://vite.dev/)
- [serve documentation](https://github.com/vercel/serve)
