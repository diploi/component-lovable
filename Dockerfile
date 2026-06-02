# This will be set by the GitHub action to the folder containing this component.
ARG FOLDER=/app

FROM node:24-slim AS base

# Enable corepack
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0
RUN corepack enable

# Setup PNPM
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PNPM_HOME/bin:$PATH"
RUN mkdir -p /home/codespace/.pnpm-store /pnpm \
  && chown -R 1000:1000 /home/codespace/.pnpm-store /pnpm

# Install dependencies only when needed
FROM base AS deps
ARG FOLDER

COPY . /app
WORKDIR ${FOLDER}

# Install dependencies based on the preferred package manager
RUN \
  if [ -f yarn.lock ]; then \
  yarn install --frozen-lockfile || yarn install; \
  elif [ -f package-lock.json ]; then \
  npm ci || npm install; \
  elif [ -f pnpm-lock.yaml ]; then \
  pnpm install --frozen-lockfile || pnpm install; \
  elif [ -f package.json ]; then \
  echo "Lockfile not found. Falling back to npm install (non-deterministic install)."; \
  npm install; \
  else \
  echo "No package manifest found. Skipping install."; \
  fi

# Rebuild the source code only when needed
FROM base AS builder
ARG FOLDER
COPY . /app
WORKDIR ${FOLDER}
COPY --from=deps ${FOLDER}/node_modules ./node_modules

# Create a vite.node.config.ts with custom node-server preset and run the build with new config,
# otherwise fall back to default build scripts.
RUN set -eux; \
  if grep -q '"@tanstack/react-start"' package.json >/dev/null 2>&1; then \
  if grep -q '^[[:space:]]*nitro:' vite.config.ts; then \
  cp vite.config.ts vite.node.config.ts; \
  else \
  awk 'NR > 1 { print prev } { prev = $0 } END { if (prev == "});") { print "  nitro: { preset: \"node-server\" },"; print prev } else { print prev } }' vite.config.ts > vite.node.config.ts; \
  echo "Custom vite.node.config.ts"; \
  cat vite.node.config.ts; \
  fi; \
  echo "Building TanStack Start with custom vite.node.config.ts"; \
  npm run build -- --config vite.node.config.ts; \
  rm vite.node.config.ts; \
  else \
  echo "Fallback for old Lovable project"; \
  if [ -f yarn.lock ]; then \
  yarn run build; \
  elif [ -f package-lock.json ]; then \
  npm run build; \
  elif [ -f pnpm-lock.yaml ]; then \
  pnpm run build; \
  elif [ -f package.json ]; then \
  echo "Lockfile not found. Falling back to npm."; \
  npm run build; \
  else \
  echo "No package manifest found. Skipping build."; \
  fi; \
  fi

# Production image, copy all the built files
# NOTE: Build will be run again in an init-container to include ENV
FROM base AS runner
ARG FOLDER

COPY --from=builder --chown=1000:1000 /app /app
WORKDIR ${FOLDER}

ENV NODE_ENV=production

USER 1000:1000

ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin
RUN npm i -g serve

EXPOSE 80
ENV PORT=80
ENV HOST="0.0.0.0"
ENV HOSTNAME="0.0.0.0"
ENV NITRO_PORT=80
ENV NITRO_HOST="0.0.0.0"

CMD ["sh", "-c", "if [ -f .output/server/index.mjs ]; then node .output/server/index.mjs; else serve -s -l ${PORT:-80} dist; fi"]
