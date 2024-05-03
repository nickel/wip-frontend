FROM node:lts AS base
WORKDIR /app

RUN npm install -g pnpm

COPY package.json pnpm-lock.yaml .

FROM base AS prod-deps
RUN pnpm install --production

FROM base AS build-deps
RUN pnpm install --production=false

FROM build-deps AS build
COPY . .
RUN pnpm run build

FROM base AS runtime
COPY --from=prod-deps /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist

ENV HOST=0.0.0.0
ENV PORT=4321
EXPOSE 4321
CMD node ./dist/server/entry.mjs
